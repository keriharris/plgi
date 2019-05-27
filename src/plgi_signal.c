/*  This file is part of PLGI.

    Copyright (C) 2015 Keri Harris <keri@gentoo.org>

    PLGI is free software: you can redistribute it and/or modify
    it under the terms of the GNU Lesser General Public License as
    published by the Free Software Foundation, either version 2.1
    of the License, or (at your option) any later version.

    PLGI is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with PLGI.  If not, see <http://www.gnu.org/licenses/>.
*/

#include "plgi.h"



typedef struct PLGISignalClosure
{ GClosure closure;
  PLGICallableInfo *signal_info;
  predicate_t handler;
  record_t user_data;
  gboolean swapped;
} PLGISignalClosure;


void plgi_signal_marshaller(GClosure     *closure,
                            GValue       *return_value,
                            guint         n_param_values,
                            const GValue *param_values,
                            gpointer      invocation_hint,
                            gpointer      marshal_data)
{
  PLGISignalClosure *plgi_closure;
  PLGICallableInfo *signal_info;
  PLGIBaseArgInfo *base_args_info;
  PLGIBaseArgInfo *return_arg_info;
  GIArgument *args_data;
  PLGIArgCache *arg_cache;
  term_t t0;
  gint n_args, pl_arg_pos, i, ret;
  gsize arity;
  atom_t name;
  module_t module;
  predicate_t predicate;
  fid_t fid;
  qid_t qid;
  term_t except;

  PLGI_debug_header;

  plgi_closure = (PLGISignalClosure*)closure;
  signal_info = plgi_closure->signal_info;

  PLGI_debug("marshalling signal: %s", PL_atom_chars(signal_info->name));

  base_args_info = signal_info->args_info;
  n_args = signal_info->n_args;
  return_arg_info = base_args_info + n_args;

  predicate = plgi_closure->handler;
  PL_predicate_info(predicate, &name, &arity, &module);

  if ( n_param_values != n_args )
  { return;
  }

  fid = PL_open_foreign_frame();

  args_data = g_malloc0_n(n_args+1, sizeof(*args_data));
  arg_cache = g_malloc0(sizeof(*arg_cache));
  arg_cache->id = plgi_cache_id();

  t0 = PL_new_term_refs(arity);

  /* bind (in) GValue args to GI args */
  for ( i = 0; i < n_args; i++ )
  { PLGIBaseArgInfo *base_arg_info;
    PLGIArgInfo *arg_info;
    GIArgument *arg_data;
    GValue *gvalue;

    base_arg_info = base_args_info + i;
    arg_info = base_arg_info->arg_info;
    arg_data = args_data + i;
    gvalue = (GValue*)(param_values + i);

    if ( base_arg_info->direction == GI_DIRECTION_OUT )
    { continue;
    }

    PLGI_debug("  binding (in) arg %d. GValue: %p gi_arg: %p",
               i, gvalue, arg_data);

    plgi_gvalue_to_arg(gvalue, arg_info, arg_data);
  }

  pl_arg_pos = 0;
  if ( plgi_closure->swapped && pl_arg_pos < arity )
  { if ( !plgi_closure_data_to_term(plgi_closure->user_data, t0) )
    { goto cleanup;
    }
    pl_arg_pos++;
  }

  /* populate in terms */
  for ( i = 0; i < n_args && pl_arg_pos < arity; i++ )
  { PLGIBaseArgInfo *base_arg_info;
    PLGIArgInfo *arg_info;
    GIArgument *arg_data;

    base_arg_info = base_args_info + i;
    arg_info = base_arg_info->arg_info;
    arg_data = args_data + i;

    PLGI_debug("  reading in arg %d. arg_info: %p arg_data: %p",
               i, base_arg_info, arg_data);

    if ( signal_info->arg_mask & (1 << i) &&
         arg_info->type_tag != GI_TYPE_TAG_ERROR )
    { PLGI_debug("    masked arg: %p --- skipped", &arg_data);
      continue;
    }

    if ( base_arg_info->direction == GI_DIRECTION_IN ||
         base_arg_info->direction == GI_DIRECTION_INOUT )
    { if ( !plgi_arg_to_term(arg_data, arg_info, t0+pl_arg_pos) )
      { goto cleanup;
      }

      pl_arg_pos++;
    }

    if ( base_arg_info->direction == GI_DIRECTION_OUT ||
         base_arg_info->direction == GI_DIRECTION_INOUT )
    {
      pl_arg_pos++;
    }
  }

  if ( !plgi_closure->swapped && pl_arg_pos < arity )
  { if ( !plgi_closure_data_to_term(plgi_closure->user_data, t0+pl_arg_pos) )
    { goto cleanup;
    }
  }

  PLGI_debug("  invoking signal handler: %s:%s/%zd",
             PL_atom_chars(PL_module_name(module)), PL_atom_chars(name), arity);

  qid = PL_open_query(module, PL_Q_NORMAL|PL_Q_CATCH_EXCEPTION, predicate, t0);
  ret = PL_next_solution(qid);
  PL_cut_query(qid);

  except = PL_exception(qid);
  if ( except )
  { predicate_t print_message = PL_predicate("print_message", 2, "user");
    term_t ex_args = PL_new_term_refs(2);
    PL_put_atom(ex_args+0, PL_new_atom("error"));
    PL_put_term(ex_args+1, except);
    PL_call_predicate(module, PL_Q_NODEBUG|PL_Q_CATCH_EXCEPTION, print_message, ex_args);
    PL_clear_exception();
  }

  PLGI_debug("    signal handler retval: %d", ret);

  if ( !ret )
  { goto cleanup;
  }

  /* populate out args */
  pl_arg_pos = 0;
  if ( plgi_closure->swapped && pl_arg_pos < arity )
  { pl_arg_pos++;
  }
  for ( i = 0; i < n_args && pl_arg_pos < arity; i++ )
  { PLGIBaseArgInfo *base_arg_info;
    PLGIArgInfo *arg_info;
    GIArgument *arg_data;

    base_arg_info = base_args_info + i;
    arg_info = base_arg_info->arg_info;
    arg_data = args_data + i;

    PLGI_debug("  reading out term %d. arg_info: %p arg_data: %p",
               i, base_arg_info, arg_data);

    if ( signal_info->arg_mask & (1 << i) &&
         base_arg_info->arg_info->type_tag != GI_TYPE_TAG_ERROR )
    { PLGI_debug("    masked arg: %p --- skipped", arg_data);
      continue;
    }

    if ( base_arg_info->direction == GI_DIRECTION_IN ||
         base_arg_info->direction == GI_DIRECTION_INOUT )
    { pl_arg_pos++;
    }

    if ( base_arg_info->direction == GI_DIRECTION_OUT ||
         base_arg_info->direction == GI_DIRECTION_INOUT )
    { if ( !plgi_term_to_arg(t0+pl_arg_pos, arg_info, arg_cache, arg_data) )
      { goto cleanup;
      }

      pl_arg_pos++;
    }
  }

  if ( !plgi_closure->swapped && pl_arg_pos < arity )
  { pl_arg_pos++; /* user data */
  }

  /* populate return arg */
  if ( return_arg_info->arg_info->type_tag != GI_TYPE_TAG_VOID &&
       pl_arg_pos < arity )
  { GIArgument *arg_data = args_data + n_args;

    PLGI_debug("  populating return term using %s return arg...",
               g_type_tag_to_string(return_arg_info->arg_info->type_tag));

    if ( !plgi_term_to_arg(t0+pl_arg_pos, return_arg_info->arg_info,
                           arg_cache, arg_data) )
    { goto cleanup;
    }
  }

  /* bind (out) GI args to GValue args */
  for ( i = 0; i < n_args; i++ )
  { PLGIBaseArgInfo *base_arg_info;
    PLGIArgInfo *arg_info;
    GIArgument *arg_data;
    GValue *gvalue;

    base_arg_info = base_args_info + i;
    arg_info = base_arg_info->arg_info;
    arg_data = args_data + i;
    gvalue = (GValue*)(param_values + i);

    if ( base_arg_info->direction == GI_DIRECTION_IN )
    { continue;
    }

    PLGI_debug("  binding (out) arg %d. gi_arg: %p GValue: %p",
               i, arg_data, gvalue);

    plgi_arg_to_gvalue(arg_data, arg_info, gvalue);
  }

  /* bind return gi_arg to GValue result */
  if ( return_arg_info->arg_info->type_tag != GI_TYPE_TAG_VOID )
  { GIArgument *arg_data = args_data + n_args;

    PLGI_debug("  binding return_arg. gi_arg: %p GValue: %p",
               arg_data, return_value);

    plgi_arg_to_gvalue(arg_data, return_arg_info->arg_info, return_value);
  }

 cleanup:

  PL_discard_foreign_frame(fid);

  plgi_dealloc_arg_cache(arg_cache, TRUE);
  g_free(args_data);

  PLGI_debug_trailer;

  return;
}


void plgi_signal_closure_cleanup(gpointer data, GClosure *closure)
{
  PLGISignalClosure *plgi_closure;

  PLGI_debug("  signal closure cleanup:  closure: %p", closure);

  plgi_closure = (PLGISignalClosure*)closure;
  PL_erase(plgi_closure->user_data);
}



                 /*******************************
                 *      Foreign Predicates      *
                 *******************************/

PLGI_PRED_IMPL(plgi_signal_connect_data)
{
  term_t object        = FA0;
  term_t sig           = FA1;
  term_t handler       = FA2;
  term_t user_data     = FA3;
  term_t connect_flags = FA4;
  term_t handler_id    = FA5;

  PLGIBlob *object_blob;
  PLGISignalClosure *closure = NULL;
  PLGICallableInfo *signal_info;
  GObject *gobject;
  gchar *detailed_signal = NULL, *signal_name;
  gchar **signal_details = NULL;
  gchar buf[1024];
  guint signal_id;
  GSignalQuery signal_query;
  atom_t signal_key;
  module_t module;
  functor_t functor;
  gulong id;
  GConnectFlags flags;
  gboolean ret = TRUE;
  term_t list = PL_copy_term_ref(connect_flags);
  term_t head = PL_new_term_ref();

  PLGI_debug("Connecting Signal:  signal: 0x%lx  --->  handler: 0x%lx",
             sig, handler);

  if ( !plgi_object_get_blob(object, &object_blob) )
  { ret = FALSE;
    goto cleanup;
  }

  gobject = object_blob->data;

  if ( !plgi_term_to_utf8(sig, &detailed_signal) )
  { ret = FALSE;
    goto cleanup;
  }

  signal_details = g_strsplit(detailed_signal, "::", 2);
  signal_name = signal_details[0];

  signal_id = g_signal_lookup(signal_name, G_TYPE_FROM_INSTANCE(gobject));
  if ( !signal_id )
  { ret = PL_domain_error("signal", sig);
    goto cleanup;
  }

  g_signal_query(signal_id, &signal_query);
  g_snprintf(buf, sizeof(buf), "%s::%s",
             g_type_name(signal_query.itype), signal_name);
  signal_key = PL_new_atom(buf);

  if ( !plgi_get_callable_info(signal_key, &signal_info) )
  { plgi_raise_error__va("unregistered signal %s",
                         PL_atom_chars(signal_key));
    ret = FALSE;
    goto cleanup;
  }

  /* FIXME: check handler exists */

  if ( !plgi_term_to_callback_functor(handler, &module, &functor) )
  { ret = FALSE;
    goto cleanup;
  }

  if ( PL_skip_list(list, 0, NULL) != PL_LIST )
  { ret = PL_type_error("list", connect_flags);
    goto cleanup;
  }

  atom_t ATOM_g_connect_after = PL_new_atom("G_CONNECT_AFTER");
  atom_t ATOM_g_connect_swapped = PL_new_atom("G_CONNECT_SWAPPED");

  flags = 0;
  while ( PL_get_list(list, head, list) )
  { atom_t flag_name;

    if ( !PL_get_atom(head, &flag_name) )
    { ret = PL_type_error("GConnectFlags", head);
      goto cleanup;
    }

    if ( flag_name == ATOM_g_connect_after )
    { flags |= G_CONNECT_AFTER;
    }
    else if ( flag_name == ATOM_g_connect_swapped )
    { flags |= G_CONNECT_SWAPPED;
    }
    else
    { ret = PL_domain_error("GConnectFlags", head);
      goto cleanup;
    }
  }

  PLGI_debug("    signal: 0x%x (%s)  --->  handler: %s:%s/%zd [flags: 0x%x]",
             signal_id, detailed_signal, PL_atom_chars(PL_module_name(module)),
             PL_atom_chars(PL_functor_name(functor)), PL_functor_arity(functor),
             flags);

  if ( flags & G_CONNECT_SWAPPED )
  { PLGIBlob *user_data_blob;
    if ( !plgi_object_get_blob(user_data, &user_data_blob) )
    { ret = FALSE;
      goto cleanup;
    }
  }

  closure = (PLGISignalClosure*)g_closure_new_simple(sizeof(PLGISignalClosure), NULL);
  closure->signal_info = signal_info;
  closure->handler = PL_pred(functor, module);
  closure->swapped = (flags & G_CONNECT_SWAPPED ? TRUE : FALSE);
  closure->user_data = PL_record(user_data);

  g_closure_set_marshal((GClosure*)closure, plgi_signal_marshaller);
  g_closure_add_finalize_notifier((GClosure*)closure, NULL,
                                  plgi_signal_closure_cleanup);

  id = g_signal_connect_closure(gobject, detailed_signal, (GClosure*)closure,
                                flags & G_CONNECT_AFTER ? TRUE : FALSE);

  PLGI_debug("    signal closure: %p, handler id: 0x%lu", closure, id);

  if ( !id )
  { ret = FALSE;
    goto cleanup;
  }

  term_t id_term = PL_new_term_ref();

  if ( !plgi_gulong_to_term(id, id_term) )
  { ret = FALSE;
    goto cleanup;
  }
  if ( !PL_unify(handler_id, id_term) )
  { ret = FALSE;
    goto cleanup;
  }

 cleanup:

  if ( !ret )
  { if ( closure ) g_free(closure);
  }

  if ( detailed_signal ) g_free(detailed_signal);
  if ( signal_details ) g_strfreev(signal_details);

  return ret;
}


PLGI_PRED_IMPL(plgi_signal_emit)
{
  term_t object   = FA0;
  term_t sig_name = FA1;
  term_t detail   = FA2;
  term_t args     = FA3;

  PLGIBlob *object_blob;
  PLGICallableInfo *signal_info;
  PLGIBaseArgInfo *base_args_info;
  GIArgument *args_data = NULL;
  PLGIArgCache *arg_cache = NULL;
  GObject *gobject;
  gchar *signal_name = NULL, *signal_detail;
  gchar buf[1024];
  guint signal_id;
  GSignalQuery signal_query;
  GQuark detail_quark;
  GValue *params = NULL;
  GValue return_gvalue = { 0, };
  GType return_type = G_TYPE_NONE;
  atom_t signal_key;
  gsize len, exp_len;
  gint n_args, i;
  term_t list = PL_copy_term_ref(args);
  term_t head = PL_new_term_ref();
  gboolean ret = TRUE;

  if ( !plgi_object_get_blob(object, &object_blob) )
  { ret = FALSE;
    goto cleanup;
  }

  gobject = object_blob->data;

  if ( !plgi_term_to_utf8(sig_name, &signal_name) )
  { ret = FALSE;
    goto cleanup;
  }

  if ( !( plgi_get_null(detail, (gpointer*)&signal_detail) ||
          plgi_term_to_utf8(detail, &signal_detail) ) )
  { ret = PL_type_error("atom", detail);
    goto cleanup;
  }

  signal_id = g_signal_lookup(signal_name, G_TYPE_FROM_INSTANCE(gobject));
  if ( !signal_id )
  { ret = PL_domain_error("signal", sig_name);
    goto cleanup;
  }

  g_signal_query(signal_id, &signal_query);
  g_snprintf(buf, sizeof(buf), "%s::%s",
             g_type_name(signal_query.itype), signal_name);
  signal_key = PL_new_atom(buf);

  if ( !plgi_get_callable_info(signal_key, &signal_info) )
  { plgi_raise_error__va("unregistered signal %s",
                         PL_atom_chars(signal_key));
    ret = FALSE;
    goto cleanup;
  }

  base_args_info = signal_info->args_info;
  n_args = signal_info->n_args;

  detail_quark = g_quark_from_string(signal_detail);

  if ( PL_skip_list(args, 0, &len) != PL_LIST )
  { ret = PL_type_error("list", args);
    ret = FALSE;
    goto cleanup;
  }

  return_type = signal_query.return_type & ~G_SIGNAL_TYPE_STATIC_SCOPE;
  exp_len = signal_info->n_pl_args - 1;

  if ( len != exp_len )
  { plgi_raise_error__va("Expected %d args, received %d args", exp_len, len);
    ret = FALSE;
    goto cleanup;
  }

  args_data = g_malloc0_n(n_args+1, sizeof(*args_data));
  arg_cache = g_malloc0(sizeof(*arg_cache));
  arg_cache->id = plgi_cache_id();

  params = g_malloc0_n(signal_query.n_params + 1, sizeof(*params));
  g_value_init(params, object_blob->gtype);
  g_value_set_object(params, gobject);

  for ( i = 0; i < signal_query.n_params; i++ )
  { GValue *gvalue = (GValue*)(params + i+1);
    g_value_init(gvalue,
                 signal_query.param_types[i] & ~G_SIGNAL_TYPE_STATIC_SCOPE);
  }

  if ( return_type != G_TYPE_NONE )
  { g_value_init(&return_gvalue, return_type);
  }

  /* populate in args */
  for ( i = 1; i < n_args; i++ )
  { PLGIBaseArgInfo *base_arg_info;
    PLGIArgInfo *arg_info;
    GIArgument *arg_data;

    base_arg_info = base_args_info + i;
    arg_info = base_arg_info->arg_info;
    arg_data = args_data + i;

    PLGI_debug("  building arg %d. arg_info: %p arg_data: %p",
               i, base_arg_info, arg_data);

    if ( signal_info->arg_mask & (1 << i) )
    { PLGI_debug("    masked arg: %p --- skipped", arg_data);
      continue;
    }

    if ( !G_TYPE_TAG_IS_BASIC(arg_info->type_tag) &&
         signal_query.param_types[i-1] & G_SIGNAL_TYPE_STATIC_SCOPE )
    { plgi_raise_error__va("cannot pass-by-value %s types",
                           g_type_tag_to_string(arg_info->type_tag));
      ret = FALSE;
      goto cleanup;
    }

    if ( base_arg_info->direction == GI_DIRECTION_IN )
    { if ( !PL_get_list(list, head, list) )
      { ret = FALSE;
        goto cleanup;
      }

      if ( !plgi_term_to_arg(head, arg_info, arg_cache, arg_data) )
      { ret = FALSE;
        goto cleanup;
      }
    }

    else if ( base_arg_info->direction == GI_DIRECTION_OUT )
    { if ( !PL_get_list(list, head, list) )
      { ret = FALSE;
        goto cleanup;
      }

      if ( arg_info->flags & PLGI_ARG_IS_CALLER_ALLOCATES &&
           !plgi_alloc_arg(arg_data, arg_info) )
      { ret = FALSE;
        goto cleanup;
      }
    }

    else if ( base_arg_info->direction == GI_DIRECTION_INOUT )
    { if ( !PL_get_list(list, head, list) )
      { ret = FALSE;
        goto cleanup;
      }

      if ( !plgi_term_to_arg(head, arg_info, arg_cache, arg_data) )
      { ret = FALSE;
        goto cleanup;
      }

      if ( !PL_get_list(list, head, list) )
      { ret = FALSE;
        goto cleanup;
      }
    }
  }

  /* bind (in) GI args to GValue args */
  for ( i = 1; i < n_args; i++ )
  { PLGIBaseArgInfo *base_arg_info;
    PLGIArgInfo *arg_info;
    GIArgument *arg_data;
    GValue *gvalue;

    base_arg_info = base_args_info + i;
    arg_info = base_arg_info->arg_info;
    arg_data = args_data + i;
    gvalue = (GValue*)(params + i);

    if ( base_arg_info->direction == GI_DIRECTION_OUT )
    { continue;
    }

    PLGI_debug("  binding (in) arg %d. gi_arg: %p GValue: %p",
               i, arg_data, gvalue);

    plgi_arg_to_gvalue(arg_data, arg_info, gvalue);
  }

  PLGI_debug("Emitting Signal:  id: 0x%x, name: %s", signal_id, signal_name);

  g_signal_emitv(params, signal_id, detail_quark, &return_gvalue);

  /* populate out terms */
  list = PL_copy_term_ref(args);
  for ( i = 1; i < n_args; i++ )
  { PLGIBaseArgInfo *base_arg_info;
    PLGIArgInfo *arg_info;
    GIArgument *arg_data;
    GValue *gvalue;

    base_arg_info = base_args_info + i;
    arg_info = base_arg_info->arg_info;
    arg_data = args_data + i;
    gvalue = (GValue*)(params + i);

    PLGI_debug("  reading out arg %d. arg_info: %p arg_data: %p",
               i, base_arg_info, arg_data);

    if ( signal_info->arg_mask & (1 << i) &&
         arg_info->type_tag != GI_TYPE_TAG_ERROR )
    { PLGI_debug("    masked arg: %p --- skipped", arg_data);
      continue;
    }

    if ( base_arg_info->direction == GI_DIRECTION_IN ||
         base_arg_info->direction == GI_DIRECTION_INOUT )
    { if ( !PL_get_list(list, head, list) )
      { ret = FALSE;
        goto cleanup;
      }
    }

    if ( base_arg_info->direction == GI_DIRECTION_OUT ||
         base_arg_info->direction == GI_DIRECTION_INOUT )
    { term_t out_term = PL_new_term_ref();

      plgi_gvalue_to_arg(gvalue, arg_info, arg_data);
      if ( !plgi_arg_to_term(arg_data, arg_info, out_term) )
      { ret = FALSE;
        goto cleanup;
      }

      if ( !PL_get_list(list, head, list) )
      { ret = FALSE;
        goto cleanup;
      }
      if ( !PL_unify(head, out_term) )
      { ret = FALSE;
        goto cleanup;
      }
    }
  }

  /* populate return term */
  if ( return_type != G_TYPE_NONE )
  { PLGIBaseArgInfo *base_arg_info;
    PLGIArgInfo *arg_info;
    GIArgument *arg_data;
    term_t return_term = PL_new_term_ref();

    base_arg_info = base_args_info + n_args;
    arg_info = base_arg_info->arg_info;
    arg_data = args_data + n_args;

    plgi_gvalue_to_arg(&return_gvalue, arg_info, arg_data);
    if ( !plgi_arg_to_term(arg_data, arg_info, return_term) )
    { ret = FALSE;
      goto cleanup;
    }

    if ( !PL_get_list(list, head, list) )
    { ret = FALSE;
      goto cleanup;
    }
    if ( !PL_unify(head, return_term) )
    { ret = FALSE;
      goto cleanup;
    }
  }

 cleanup:

  if ( signal_name ) g_free(signal_name);
  if ( args_data ) g_free(args_data);
  if ( arg_cache ) plgi_dealloc_arg_cache(arg_cache, TRUE);

  if ( params )
  { for ( i = 0; i < n_args; i++ )
    { GValue *gvalue;

      gvalue = (GValue*)(params + i);
      g_value_reset(gvalue);
    }
    g_free(params);
  }

  if ( return_type != G_TYPE_NONE )
  { g_value_reset(&return_gvalue);
  }

  return ret;
}


