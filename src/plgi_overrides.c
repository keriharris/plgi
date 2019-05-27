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



                 /*******************************
                 *             Glib             *
                 *******************************/

typedef struct PLGIIdleClosure
{ predicate_t handler;
  gpointer user_data;
} PLGIIdleClosure;




gboolean
plgi_idle_marshaller(gpointer data)
{
  PLGIIdleClosure *closure;
  gint ret;
  gsize arity;
  atom_t name;
  module_t module;
  predicate_t predicate;
  term_t user_data = PL_new_term_ref();
  fid_t fid;
  qid_t qid;
  term_t except;

  PLGI_debug_header;

  closure = data;
  if ( !closure )
  { return G_SOURCE_REMOVE;
  }

  fid = PL_open_foreign_frame();

  if ( !plgi_closure_data_to_term(closure->user_data, user_data) )
  { goto cleanup;
  }
  PL_erase(closure->user_data);

  predicate = closure->handler;
  PL_predicate_info(predicate, &name, &arity, &module);

  PLGI_debug("  invoking idle goal: %s:%s/%zd",
             PL_atom_chars(PL_module_name(module)), PL_atom_chars(name), arity);

  qid = PL_open_query(module, PL_Q_NORMAL|PL_Q_CATCH_EXCEPTION, predicate, user_data);
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

  PLGI_debug("  idle goal retval: %d", ret);

  PLGI_debug_trailer;

cleanup:

  PL_discard_foreign_frame(fid);

  return G_SOURCE_REMOVE;
}


PLGI_PRED_IMPL(plgi_g_idle_add)
{
  term_t goal = FA0;
  term_t user_data = FA1;

  PLGIIdleClosure *closure;
  module_t module;
  functor_t functor;
  predicate_t predicate;
  gpointer closure_data;

  PLGI_debug_header;

  if ( !plgi_term_to_callback_functor(goal, &module, &functor) )
  { goto error;
  }

  PLGI_debug("    term: 0x%lx  --->  goal %s:%s/%zd",
             goal,
             PL_atom_chars(PL_module_name(module)),
             PL_atom_chars(PL_functor_name(functor)),
             PL_functor_arity(functor));

  if ( !plgi_term_to_closure_data(user_data, &closure_data) )
  { goto error;
  }

  PLGI_debug("    term: 0x%lx  --->  gpointer: %p",
             user_data, closure_data);

  predicate = PL_pred(functor, module);
  /* FIXME: check existence of callback predicate */

  closure = g_malloc0(sizeof(*closure));

  PLGI_debug("  idle goal closure: %p", closure);

  closure->handler = predicate;
  closure->user_data = closure_data;

  PLGI_debug("  calling g_idle_add()");

  g_idle_add(plgi_idle_marshaller, closure);

  PLGI_debug_trailer;

  return TRUE;

error:
  PLGI_debug_trailer;
  return FALSE;
}



                 /*******************************
                 *           GObject            *
                 *******************************/

PLGI_PRED_IMPL(plgi_g_closure_invoke)
{
  term_t closure         = FA0;
  term_t return_value    = FA1;
  term_t param_values    = FA2;
  term_t invocation_hint = FA3;

  PLGIBlob *closure_blob;
  PLGIBlob *return_value_blob;

  GClosure *gclosure;
  GValue *greturn_value;
  GValue *gparam_values;
  guint n_param_values;
  gpointer ginvocation_hint;

  term_t list = PL_copy_term_ref(param_values);
  term_t head = PL_new_term_ref();
  size_t len;

  PLGI_debug_header;

  if ( !( plgi_get_blob(closure, &closure_blob) &&
          g_type_is_a( closure_blob->gtype, G_TYPE_CLOSURE ) ) )
  { PL_type_error("GClosure", closure);
    goto error;
  }
  gclosure = closure_blob->data;

  PLGI_debug("    term: 0x%lx  --->  GClosure: %p",
             closure, gclosure);

  if ( !( plgi_get_blob(return_value, &return_value_blob) &&
          g_type_is_a( return_value_blob->gtype, G_TYPE_VALUE ) ) )
  { PL_type_error("GValue", return_value);
    goto error;
  }
  greturn_value = return_value_blob->data;

  PLGI_debug("    term: 0x%lx  --->  GValue: %p",
             return_value, greturn_value);

  if ( PL_skip_list(param_values, 0, &len) != PL_LIST )
  { PL_type_error("list", param_values);
    goto error;
  }
  gparam_values = g_malloc0_n(len, sizeof(*gparam_values));

  n_param_values = 0;
  while ( PL_get_list(list, head, list) )
  { PLGIBlob *param_blob;
    GValue *param;

    if ( !( plgi_get_blob(head, &param_blob) &&
            g_type_is_a( param_blob->gtype, G_TYPE_VALUE ) ) )
    { g_free(gparam_values);
      PL_type_error("GValue", head);
      goto error;
    }
    param = param_blob->data;

    g_value_copy(param, gparam_values + n_param_values);

    PLGI_debug("    term: 0x%lx  --->  GValue: %p",
               head, gparam_values + n_param_values);

    n_param_values++;
  }

  if ( !plgi_get_null(invocation_hint, &ginvocation_hint) )
  { if ( !PL_get_pointer_ex(invocation_hint, &ginvocation_hint) )
    { g_free(gparam_values);
      goto error;
    }
  }

  PLGI_debug("    term: 0x%lx  --->  gpointer: %p",
             invocation_hint, ginvocation_hint);

  PLGI_debug("  calling g_closure_invoke()");

  g_closure_invoke(gclosure, greturn_value, n_param_values, gparam_values, ginvocation_hint);

  g_free(gparam_values);

  PLGI_debug_trailer;

  return TRUE;

error:
  PLGI_debug_trailer;
  return FALSE;
}


PLGI_PRED_IMPL(plgi_g_is_object)
{
  term_t object = FA0;

  PLGIBlob *object_blob;
  int retval;

  PLGI_debug_header;

  retval = plgi_object_get_blob(object, &object_blob);

  PLGI_debug_trailer;

  return retval;
}


PLGI_PRED_IMPL(plgi_g_is_value)
{
  term_t gvalue = FA0;

  int retval;

  PLGI_debug_header;

  retval = plgi_blob_is_a(gvalue, G_TYPE_VALUE);

  PLGI_debug_trailer;

  return retval;
}


PLGI_PRED_IMPL(plgi_g_object_type)
{
  term_t object = FA0;
  term_t type   = FA1;

  PLGIBlob *object_blob;
  term_t type0 = PL_new_term_ref();

  PLGI_debug_header;

  if ( !plgi_object_get_blob(object, &object_blob) )
  { goto error;
  }

  PLGI_debug("    term: 0x%lx  --->  GObject: %p",
             object, object_blob->data);

  if ( !plgi_gtype_to_term(object_blob->gtype, type0) )
  { goto error;
  }

  PLGI_debug_trailer;

  return PL_unify(type, type0);

error:
  PLGI_debug_trailer;
  return FALSE;
}


PLGI_PRED_IMPL(plgi_g_param_spec_value_type)
{
  term_t param_spec = FA0;
  term_t value_type = FA1;

  PLGIBlob *object_blob;
  GType gtype;
  term_t value_type0 = PL_new_term_ref();

  PLGI_debug_header;

  if ( !plgi_object_get_blob(param_spec, &object_blob ) )
  { goto error;
  }

  if ( !G_IS_PARAM_SPEC(object_blob->data) )
  { PL_type_error("GParamSpec", param_spec);
    goto error;
  }

  PLGI_debug("    term: 0x%lx  --->  GParamSpec: %p",
             param_spec, object_blob->data);

  PLGI_debug("  calling G_PARAM_SPEC_VALUE_TYPE()");

  gtype = G_PARAM_SPEC_VALUE_TYPE(object_blob->data);

  PLGI_debug("    retval: %lu", gtype);

  if ( !plgi_gtype_to_term(gtype, value_type0) )
  { goto error;
  }

  PLGI_debug_trailer;

  return PL_unify(value_type, value_type0);

error:
  PLGI_debug_trailer;
  return FALSE;
}


PLGI_PRED_IMPL(plgi_g_value_get_boxed)
{
  term_t value = FA0;
  term_t boxed = FA1;

  PLGIBlob *blob;
  GValue *gvalue;
  GType gtype;
  gpointer gboxed;
  term_t t = PL_new_term_ref();

  PLGI_debug_header;

  if ( !( plgi_get_blob(value, &blob) &&
          g_type_is_a( blob->gtype, G_TYPE_VALUE ) ) )
  { PL_type_error("GValue", value);
    goto error;
  }
  gvalue = blob->data;

  if ( !G_VALUE_HOLDS(gvalue, G_TYPE_BOXED) )
  { PL_type_error("GValue holding GBoxed type", value);
    goto error;
  }

  PLGI_debug("    term: 0x%lx  --->  GValue: %p",
             value, gvalue);

  PLGI_debug("  calling g_value_get_boxed()");

  gboxed = g_value_get_boxed(gvalue);

  PLGI_debug("    retval: %p", gboxed);

  gtype = G_VALUE_TYPE(gvalue);

  PLGI_debug("    gpointer: %p -->  term: 0x%lx", gboxed, t);

  if ( gtype == G_TYPE_STRV )
  { if ( !plgi_gstrv_to_term(gboxed, t) )
    { goto error;
    }
  }
  else
  { if ( !gboxed )
    { if ( !plgi_put_null(t) )
      { goto error;
      }
    }
    else if ( !plgi_put_blob(PLGI_BLOB_BOXED, gtype, PL_new_atom(g_type_name(gtype)),
                        FALSE, gboxed, t) )
    { goto error;
    }
  }

  PLGI_debug_trailer;

  return PL_unify(boxed, t);

error:
  PLGI_debug_trailer;
  return FALSE;  
}


PLGI_PRED_IMPL(plgi_g_value_holds)
{
  term_t value = FA0;
  term_t type = FA1;

  PLGIBlob *blob;
  GValue *gvalue;
  GType gtype;
  gint ret;

  PLGI_debug_header;

  if ( !( plgi_get_blob(value, &blob) &&
          g_type_is_a( blob->gtype, G_TYPE_VALUE ) ) )
  { PL_type_error("GValue", value);
    goto error;
  }
  gvalue = blob->data;

  PLGI_debug("    term: 0x%lx  --->  GValue: %p",
             value, gvalue);

  if ( !plgi_term_to_gtype(type, &gtype) )
  { PL_type_error("GType", type);
    goto error;
  }

  PLGI_debug("  calling G_VALUE_HOLDS()");

  ret = G_VALUE_HOLDS(gvalue, gtype);

  PLGI_debug("    retval: %d", ret);

  PLGI_debug_trailer;

  return ret;

error:
  PLGI_debug_trailer;
  return FALSE;
}


PLGI_PRED_IMPL(plgi_g_value_init)
{
  term_t type = FA0;
  term_t value = FA1;

  term_t struct_blob = PL_new_term_ref();
  atom_t name = PL_new_atom("GValue");
  GValue *gvalue;
  GType gtype;

  PLGI_debug_header;

  if ( !plgi_term_to_gtype(type, &gtype) )
  { PL_type_error("GType", type);
    goto error;
  }

  gvalue = malloc(sizeof(*gvalue));
  memset(gvalue, 0, sizeof(*gvalue));

  PLGI_debug("  GValue: %p", gvalue);
  PLGI_debug("  calling g_value_init()");

  g_value_init(gvalue, gtype);

  PLGI_debug("    GValue: %p -->  term: 0x%lx", gvalue, value);

  if ( !plgi_put_blob(PLGI_BLOB_BOXED, G_TYPE_VALUE, name, TRUE,
                      gvalue, struct_blob) )
  { goto error;
  }

  PLGI_debug_trailer;

  return PL_unify(value, struct_blob);

error:
  PLGI_debug_trailer;
  return FALSE;
}


PLGI_PRED_IMPL(plgi_g_value_set_boxed)
{
  term_t value = FA0;
  term_t boxed = FA1;

  PLGIBlob *gvalue_blob, *gboxed_blob;
  GValue *gvalue;
  GType gtype;
  gpointer gboxed;

  PLGI_debug_header;

  if ( !( plgi_get_blob(value, &gvalue_blob) &&
          g_type_is_a( gvalue_blob->gtype, G_TYPE_VALUE ) ) )
  { PL_type_error("GValue", value);
    goto error;
  }
  gvalue = gvalue_blob->data;

  if ( !G_VALUE_HOLDS(gvalue, G_TYPE_BOXED) )
  { PL_type_error("GValue holding GBoxed type", value);
    goto error;
  }

  PLGI_debug("    term: 0x%lx  --->  GValue: %p",
             value, gvalue);

  if ( !plgi_get_null(boxed, &gboxed) )
  { gtype = G_VALUE_TYPE(gvalue);

    if ( gtype == G_TYPE_STRV )
    { if ( !plgi_term_to_gstrv(boxed, (GStrv*)&gboxed) )
      { goto error;
      }
    }
    else
    { if ( !( plgi_get_blob(value, &gboxed_blob) &&
              g_type_is_a( gboxed_blob->gtype, G_TYPE_BOXED ) ) )
      { PL_type_error("GBoxed", boxed);
        goto error;
      }
      gboxed = gboxed_blob->data;
    }
  }

  PLGI_debug("    term: 0x%lx  --->  gpointer: %p",
             boxed, gboxed);

  PLGI_debug("  calling g_value_get_boxed()");

  g_value_set_boxed(gvalue, gboxed);

  PLGI_debug_trailer;

  return TRUE;

error:
  PLGI_debug_trailer;
  return FALSE;
}
