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

#include <girffi.h>



typedef struct PLGICallbackClosure
{ PLGICallableInfo *callback_info;
  ffi_cif cif;
  ffi_closure *foreign_closure;
  predicate_t handler;
  GIScopeType scope;
  gpointer user_data;
} PLGICallbackClosure;



void
plgi_callback_marshaller(ffi_cif  *cif,
                         void     *result,
                         void    **args,
                         void     *data)
{
  PLGICallbackClosure *closure;
  PLGICallableInfo *callable_info;
  PLGIBaseArgInfo *base_args_info;
  PLGIBaseArgInfo *return_arg_info;
  GIArgument *args_data;
  PLGIArgCache *arg_cache;
  term_t t0;
  gint n_args;
  gint pl_arg_pos;
  gint i, ret;
  gsize arity;
  atom_t name;
  module_t module;
  predicate_t predicate;
  fid_t fid;
  qid_t qid;
  term_t except;

  PLGI_debug_header;

  closure = data;
  if ( !closure )
  { return;
  }

  callable_info = closure->callback_info;

  PLGI_debug("marshalling callback: %s()", PL_atom_chars(callable_info->name));

  fid = PL_open_foreign_frame();

  base_args_info = callable_info->args_info;
  n_args = callable_info->n_args;
  return_arg_info = base_args_info + n_args;

  args_data = g_malloc0_n(n_args+1, sizeof(*args_data));
  arg_cache = g_malloc0(sizeof(*arg_cache));
  arg_cache->id = plgi_cache_id();

  predicate = closure->handler;
  PL_predicate_info(predicate, &name, &arity, &module);

  t0 = PL_new_term_refs(arity);

  /* bind (in) FFI args to GI args */
  for ( i = 0; i < n_args; i++ )
  { PLGIBaseArgInfo *base_arg_info;
    PLGIArgInfo *arg_info;
    GIArgument *arg_data;

    base_arg_info = base_args_info + i;
    arg_info = base_arg_info->arg_info;
    arg_data = args_data + i;

    if ( base_arg_info->direction == GI_DIRECTION_OUT )
    { continue;
    }

    PLGI_debug("  binding (in) arg %d. ffi_arg: %p gi_arg: %p",
               i, args[i], arg_data);

    if ( base_arg_info->direction == GI_DIRECTION_IN )
    { plgi_ffi_arg_to_gi_arg(args[i], arg_info, arg_data);
    }

    else if ( base_arg_info->direction == GI_DIRECTION_INOUT )
    { gpointer *inout_arg = args[i];
      plgi_ffi_arg_to_gi_arg(*inout_arg, arg_info, arg_data);
    }

  }

  /* populate in terms */
  pl_arg_pos = 0;
  for ( i = 0; i < n_args && pl_arg_pos < arity; i++ )
  { PLGIBaseArgInfo *base_arg_info;
    PLGIArgInfo *arg_info;
    GIArgument *arg_data;

    base_arg_info = base_args_info + i;
    arg_info = base_arg_info->arg_info;
    arg_data = args_data + i;

    PLGI_debug("  reading in arg %d. arg_info: %p arg_data: %p",
               i, base_arg_info, arg_data);

    if ( callable_info->arg_mask & (1 << i) &&
         arg_info->type_tag != GI_TYPE_TAG_ERROR )
    { PLGI_debug("    masked arg: %p --- skipped", &arg_data);
      continue;
    }

    if ( base_arg_info->direction == GI_DIRECTION_IN ||
         base_arg_info->direction == GI_DIRECTION_INOUT )
    {
      if ( arg_info->flags & PLGI_ARG_IS_CLOSURE )
      { arg_data->v_pointer = closure->user_data;
      }
      if ( !plgi_arg_to_term(arg_data, arg_info, t0+pl_arg_pos) )
      { ret = FALSE;
        goto cleanup;
      }

      PLGI_debug("  deallocating in arg %d. arg_info: %p arg_data: %p",
                 i, base_arg_info, arg_data);

      switch ( base_arg_info->transfer )
      {
        case GI_TRANSFER_NOTHING:
        { break;
        }
        case GI_TRANSFER_CONTAINER:
        { plgi_dealloc_arg(arg_data, base_arg_info->arg_info);
          break;
        }
        case GI_TRANSFER_EVERYTHING:
        { plgi_dealloc_arg_full(arg_data, base_arg_info->arg_info);
          break;
        }
      }

      pl_arg_pos++;
    }

    if ( base_arg_info->direction == GI_DIRECTION_OUT ||
         base_arg_info->direction == GI_DIRECTION_INOUT )
    {
      pl_arg_pos++;
    }
  }

  PLGI_debug("  invoking callback: %s:%s/%zd",
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

  PLGI_debug("  callback retval: %d", ret);

  if ( !ret )
  { goto cleanup;
  }

  /* populate out args */
  pl_arg_pos = 0;
  for ( i = 0; i < n_args && pl_arg_pos < arity; i++ )
  { PLGIBaseArgInfo *base_arg_info;
    PLGIArgInfo *arg_info;
    GIArgument *arg_data;

    base_arg_info = base_args_info + i;
    arg_info = base_arg_info->arg_info;
    arg_data = args_data + i;

    PLGI_debug("  reading out term %d. arg_info: %p arg_data: %p",
               i, base_arg_info, arg_data);

    if ( callable_info->arg_mask & (1 << i) &&
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
      { ret = FALSE;
        goto cleanup;
      }

      pl_arg_pos++;
    }
  }

  /* populate return arg */
  if ( return_arg_info->arg_info->type_tag != GI_TYPE_TAG_VOID &&
       pl_arg_pos < arity )
  { GIArgument *arg_data = args_data + n_args;

    PLGI_debug("  populating return term using %s return arg...",
               g_type_tag_to_string(return_arg_info->arg_info->type_tag));

    if ( !plgi_term_to_arg(t0+pl_arg_pos, return_arg_info->arg_info,
                           arg_cache, arg_data) )
    { ret = FALSE;
      goto cleanup;
    }
  }

  /* bind (out) GI args to FFI args */
  for ( i = 0; i < n_args; i++ )
  { PLGIBaseArgInfo *base_arg_info;
    PLGIArgInfo *arg_info;
    GIArgument *arg_data;

    base_arg_info = base_args_info + i;
    arg_info = base_arg_info->arg_info;
    arg_data = args_data + i;

    if ( base_arg_info->direction == GI_DIRECTION_IN )
    { continue;
    }

    PLGI_debug("  binding (out) arg %d. gi_arg: %p ffi_arg: %p",
               i, arg_data, args[i]);

    plgi_gi_arg_to_ffi_arg(arg_data, arg_info, args[i]);
  }

  /* bind return gi_arg to ffi result */
  if ( return_arg_info->arg_info->type_tag != GI_TYPE_TAG_VOID )
  { GIArgument *arg_data = args_data + n_args;

    PLGI_debug("  binding return_arg. gi_arg: %p ffi_arg: %p",
               arg_data, result);

    plgi_gi_arg_to_ffi_arg(arg_data, return_arg_info->arg_info, &result);
  }

 cleanup:

  if ( !ret )
  { GIArgument arg = { 0, };

    for ( i = 0; i < n_args; i++ )
    { PLGIBaseArgInfo *base_arg_info;
      PLGIArgInfo *arg_info;

      base_arg_info = base_args_info + i;
      arg_info = base_arg_info->arg_info;

      if ( base_arg_info->direction != GI_DIRECTION_OUT )
      { continue;
      }

      PLGI_debug("  zeroing (out) arg %d. ffi_arg: %p", i, args[i]);
      plgi_gi_arg_to_ffi_arg(&arg, arg_info, args[i]);
    }

    PLGI_debug("  zeroing return_arg. ffi_arg: %p", result);
    plgi_gi_arg_to_ffi_arg(&arg, return_arg_info->arg_info, &result);
  }

  PL_discard_foreign_frame(fid);

  if ( closure->scope == GI_SCOPE_TYPE_ASYNC )
  { plgi_cache_in_async_store(closure, plgi_dealloc_callback);
  }

  if ( !ret )
  { plgi_dealloc_arg_cache(arg_cache, TRUE);
  }
  else
  { plgi_cache_in_async_store(arg_cache, NULL);
  }

  g_free(args_data);

  PLGI_debug_trailer;

  return;
}


gboolean
plgi_term_to_callback_functor(term_t     t,
                              module_t *module,
                              functor_t *functor)
{
  term_t t0 = PL_new_term_ref();
  term_t t_functor = PL_new_term_ref();
  term_t t_arity = PL_new_term_ref();
  atom_t ATOM_slash = PL_new_atom("/");
  atom_t name;
  gsize arity;

  *module = PL_new_module(PL_new_atom("user"));

  if ( !PL_strip_module(t, module, t0) )
  { return FALSE;
  }

  if ( !( PL_get_name_arity(t0, &name, &arity) &&
          name == ATOM_slash && arity == 2 ) )
  { return PL_type_error("callback (in name/arity form)", t);
  }

  _PL_get_arg(1, t0, t_functor);
  if ( !PL_get_atom(t_functor, &name) )
  { return PL_type_error("callback (in name/arity form)", t);
  }

  _PL_get_arg(2, t0, t_arity);
  if ( !PL_get_integer(t_arity, (int*)&arity) )
  { return PL_type_error("callback (in name/arity form)", t);
  }

  *functor = PL_new_functor(name, arity);

  return TRUE;
}


void
plgi_dealloc_callback(gpointer data)
{
  PLGICallbackClosure *closure = data;

  PLGI_debug("    dealloc callback closure: %p", closure);

  g_callable_info_free_closure (closure->callback_info->info,
                                closure->foreign_closure);

  if ( closure->user_data ) PL_erase(closure->user_data);
  g_free(closure);
}


gboolean
plgi_term_to_callback(term_t               t,
                      PLGICallbackArgInfo *callback_arg_info,
                      GIArgument          *arg)
{
  PLGICallbackClosure *closure;
  PLGICallableInfo *callback_info;
  ffi_closure *foreign_closure;
  gpointer *callback;
  module_t module;
  functor_t functor;
  predicate_t predicate;

  callback = &arg->v_pointer;

  PLGI_debug("    term: 0x%lx  --->  callback: (%s) %p [scope: %d]",
             t, PL_atom_chars(callback_arg_info->callback_info->name),
             callback, callback_arg_info->scope);

  if ( !plgi_term_to_callback_functor(t, &module, &functor) )
  { return FALSE;
  }

  predicate = PL_pred(functor, module);
  /* FIXME: check existence of callback predicate */

  callback_info = callback_arg_info->callback_info;
  closure = g_malloc0(sizeof(*closure));

  foreign_closure = g_callable_info_prepare_closure(callback_info->info,
                                                    &closure->cif,
                                                    plgi_callback_marshaller,
                                                    closure);

  PLGI_debug("    callback closure: %p, foreign closure: %p",
             closure, foreign_closure);

  closure->callback_info = callback_info;
  closure->foreign_closure = foreign_closure;
  closure->handler = predicate;
  closure->scope = callback_arg_info->scope;

  if ( callback_arg_info->closure_offset )
  { GIArgument *closure_arg;
    term_t closure_term;

    closure_arg = arg + callback_arg_info->closure_offset;
    closure_arg->v_pointer = closure;
    closure_term = t + callback_arg_info->closure_offset;

    closure->user_data = PL_record(closure_term);
  }

  if ( closure->scope == GI_SCOPE_TYPE_CALL )
  { plgi_cache_in_async_store(closure, plgi_dealloc_callback);
  }

  if ( closure->scope == GI_SCOPE_TYPE_NOTIFIED &&
       callback_arg_info->destroy_offset )
  { GIArgument *destroy_arg;

    destroy_arg = arg + callback_arg_info->destroy_offset;
    destroy_arg->v_pointer = plgi_dealloc_callback;
  }

  *callback = foreign_closure;

  return TRUE;
}


gboolean
plgi_term_to_closure_data(term_t t, gpointer *v)
{
  *v = PL_record(t);

  PLGI_debug("    term: 0x%lx -->  closure data: %p", t, *v);

  return TRUE;
}

gboolean
plgi_closure_data_to_term(gpointer v, term_t t)
{
  PLGI_debug("    closure data: %p -->  term: 0x%lx", v, t);

  if ( !v )
  { return plgi_put_null(t);
  }

  return PL_recorded(v, t);
}
