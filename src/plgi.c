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



typedef struct PLGITask
{ PLGICallableInfo *callable_info;
  GIArgument       *in_args;
  GIArgument       *out_args;
  GIArgument       *return_arg;
  GError           *error;
  gboolean          ret;
} PLGITask;


gboolean
plgi_main_loop_service_task(gpointer data)
{
  PLGITask *task = data;
  gboolean ret;

  PLGI_debug("  servicing function: %s()",
             g_function_info_get_symbol(task->callable_info->info));

  ret = g_function_info_invoke(task->callable_info->info,
                               task->in_args, task->callable_info->n_in_args,
                               task->out_args, task->callable_info->n_out_args,
                               task->return_arg, &task->error);

  task->ret = ret;
  PLGI_debug("    function retval: %d", ret);

  return G_SOURCE_REMOVE;
}


void plgi_calling_context(control_t *context, atom_t *module, atom_t *name, int *arity)
{
  predicate_t pred;
  module_t m;
  atom_t n;
  int a;

  pred = PL_foreign_context_predicate(context);
  PL_predicate_info(pred, &n, &a, &m);

  if ( module ) *module = PL_module_name(m);
  if ( name ) *name = n;
  if ( arity ) *arity = a;
}


foreign_t
plgi_marshaller__va(term_t t0, int arity, void *context)
{
  atom_t namespace, name;
  PLGICallableInfo *callable_info;
  PLGIBaseArgInfo *base_args_info;
  PLGIBaseArgInfo *return_arg_info;
  GIArgument *in_args, *out_args;
  GIArgument *return_arg;
  GIArgument *args_data;
  PLGIArgCache *arg_cache;
  PLGITask task;
  gint n_args, i;
  GError *error = NULL;
  gboolean func_invoked = FALSE;
  gboolean ret = TRUE;

  PLGI_debug_header;

  plgi_calling_context(context, &namespace, &name, NULL);

  PLGI_debug("marshalling %s:%s/%d",
             PL_atom_chars(namespace), PL_atom_chars(name), arity);

  if ( !plgi_get_callable_info(name, &callable_info) )
  { plgi_raise_error__va("unregistered function %s", PL_atom_chars(name));
    return FALSE;
  }

  base_args_info = callable_info->args_info;
  n_args = callable_info->n_args;
  return_arg_info = base_args_info + n_args;

  in_args = g_malloc0_n(callable_info->n_in_args, sizeof(*in_args));
  out_args = g_malloc0_n(callable_info->n_out_args, sizeof(*out_args));

  args_data = g_malloc0_n(n_args+1, sizeof(*args_data));
  return_arg = args_data + n_args;

  arg_cache = g_malloc0(sizeof(*arg_cache));
  arg_cache->id = plgi_cache_id();

  PLGI_debug("  in_args: %p, out_args: %p", in_args, out_args);

  /* build args */
  gint pl_arg_pos = 0;
  for ( i = 0; i < n_args; i++ )
  { PLGIBaseArgInfo *base_arg_info;
    GIArgument *arg_data;

    base_arg_info = base_args_info + i;
    arg_data = args_data + i;

    PLGI_debug("  building arg %d. arg_info: %p arg_data: %p",
               i, base_arg_info, arg_data);

    if ( callable_info->arg_mask & (1 << i) )
    { PLGI_debug("    masked arg: %p --- skipped", arg_data);
      continue;
    }

    if ( base_arg_info->arg_info->flags & PLGI_ARG_IS_CLOSURE )
    { pl_arg_pos++;
      continue;
    }

    if ( base_arg_info->direction == GI_DIRECTION_IN )
    { if ( !plgi_term_to_arg(t0+pl_arg_pos, base_arg_info->arg_info,
                             arg_cache, arg_data) )
      { ret = FALSE;
        goto cleanup;
      }

      pl_arg_pos++;
    }

    else if ( base_arg_info->direction == GI_DIRECTION_OUT )
    { if ( base_arg_info->arg_info->flags & PLGI_ARG_IS_CALLER_ALLOCATES &&
           !plgi_alloc_arg(arg_data, base_arg_info->arg_info) )
      { ret = FALSE;
        goto cleanup;
      }

      pl_arg_pos++;
    }

    else if ( base_arg_info->direction == GI_DIRECTION_INOUT )
    { if ( !plgi_term_to_arg(t0+pl_arg_pos, base_arg_info->arg_info,
                             arg_cache, arg_data) )
      { ret = FALSE;
        goto cleanup;
      }

      pl_arg_pos += 2;
    }
  }

  /* bind args to arg data */
  PLGI_debug("  binding %d in/out args to arg data...", n_args);
  for ( i = 0; i < n_args; i++ )
  { PLGIBaseArgInfo *base_arg_info;
    GIArgument *arg_data;
    GIArgument *in_arg, *out_arg;

    base_arg_info = base_args_info + i;
    arg_data = args_data + i;

    if ( base_arg_info->direction == GI_DIRECTION_IN )
    { in_arg = in_args + base_arg_info->in_pos;
      in_arg->v_pointer = arg_data->v_pointer;

      PLGI_debug("    arg: %d (in_arg) %p  --->  arg: %p",
                 i, in_arg, arg_data);
    }

    else if ( base_arg_info->direction == GI_DIRECTION_OUT )
    { out_arg = out_args + base_arg_info->out_pos;

      if ( base_arg_info->arg_info->flags & PLGI_ARG_IS_CALLER_ALLOCATES )
      { out_arg->v_pointer = arg_data->v_pointer;
      }
      else
      { out_arg->v_pointer = arg_data;
      }

      PLGI_debug("    arg: %d (out_arg) %p  --->  arg: %p",
                 i, out_arg, arg_data);
    }

    else if ( base_arg_info->direction == GI_DIRECTION_INOUT )
    { in_arg = in_args + base_arg_info->in_pos;
      in_arg->v_pointer = arg_data;
      out_arg = out_args + base_arg_info->out_pos;
      out_arg->v_pointer = arg_data;

      PLGI_debug("    arg: %d (in_arg) %p  --->  arg: %p",
                 i, in_arg, arg_data);
      PLGI_debug("    arg: %d (out_arg) %p  --->  arg: %p",
                 i, out_arg, arg_data);
    }
  }

  task.callable_info = callable_info;
  task.in_args = in_args;
  task.out_args = out_args;
  task.return_arg = return_arg;
  task.error = error;

  g_main_context_invoke(NULL, plgi_main_loop_service_task, &task);

  ret = task.ret;
  error = task.error;
  func_invoked = TRUE;

  for ( i = 0; i < n_args; i++ )
  { PLGIBaseArgInfo *base_arg_info = base_args_info + i;
    GIArgument *arg_data = args_data + i;
    if ( base_arg_info->direction == GI_DIRECTION_OUT ||
         base_arg_info->direction == GI_DIRECTION_INOUT )
    { GIArgument *out_arg = out_args + base_arg_info->out_pos;
      PLGI_debug("    dump: out_arg: %p [%p], data: %p [%p]",
                 out_arg, out_arg->v_pointer,
                 arg_data, arg_data->v_pointer);
    }
  }
  PLGI_debug("    dump: return arg: %p [%p]",
             return_arg, return_arg->v_pointer);

  if ( !ret )
  { ret = plgi_raise_gerror(error);
    g_error_free(error);
    goto cleanup;
  }
  else
  { term_t ex = PL_exception(0);
    if ( ex )
    { PLGI_debug("    uncaught exception: 0x%lx", ex);
      ret = FALSE;
      goto cleanup;
    }
  }

  /* populate out terms */
  pl_arg_pos = 0;
  for ( i = 0; i < n_args; i++ )
  { PLGIBaseArgInfo *base_arg_info;
    GIArgument *arg_data;

    base_arg_info = base_args_info + i;
    arg_data = args_data + i;

    PLGI_debug("  reading out arg %d. arg_info: %p arg_data: %p",
               i, base_arg_info, arg_data);

    if ( callable_info->arg_mask & (1 << i) )
    { PLGI_debug("    masked arg: %p --- skipped", arg_data);
      continue;
    }

    if ( base_arg_info->direction == GI_DIRECTION_IN ||
         base_arg_info->direction == GI_DIRECTION_INOUT )
    { pl_arg_pos++;
    }

    if ( base_arg_info->direction == GI_DIRECTION_OUT ||
         base_arg_info->direction == GI_DIRECTION_INOUT )
    { term_t out_term = PL_new_term_ref();

      if ( !plgi_arg_to_term(arg_data, base_arg_info->arg_info, out_term) )
      { ret = FALSE;
        goto cleanup;
      }
      if ( !PL_unify(t0+pl_arg_pos, out_term) )
      { ret = FALSE;
        goto cleanup;
      }

      pl_arg_pos++;
    }
  }

  /* populate return term */
  if ( !g_callable_info_skip_return(callable_info->info) &&
       ( return_arg_info->arg_info->type_tag != GI_TYPE_TAG_VOID ||
         return_arg_info->arg_info->flags & PLGI_ARG_IS_POINTER ) )
  { term_t ret_term = PL_new_term_ref();

    PLGI_debug("  populating return term using %s return arg...",
               g_type_tag_to_string(return_arg_info->arg_info->type_tag));

    if ( !plgi_arg_to_term(return_arg, return_arg_info->arg_info, ret_term) )
    { ret = FALSE;
      goto cleanup;
    }
    if ( return_arg_info->arg_info->type_tag == GI_TYPE_TAG_ERROR )
    { ret = PL_raise_exception(ret_term);
      goto cleanup;
    }
    else if ( !PL_unify(t0+pl_arg_pos, ret_term) )
    { ret = FALSE;
      goto cleanup;
    }
  }

 cleanup:

  /* free args */
  for ( i = 0; i < n_args; i++ )
  { PLGIBaseArgInfo *base_arg_info;
    GIArgument *arg_data;

    base_arg_info = base_args_info + i;
    arg_data = args_data + i;

    if ( base_arg_info->direction == GI_DIRECTION_OUT ||
         base_arg_info->direction == GI_DIRECTION_INOUT )
    { PLGI_debug("  deallocating out arg %d. arg_info: %p arg_data: %p",
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
    }
  }

  PLGI_debug("  deallocating return arg: arg_info: %p arg_data: %p",
             return_arg, return_arg_info);
  switch ( return_arg_info->transfer )
  {
    case GI_TRANSFER_NOTHING:
    { break;
    }
    case GI_TRANSFER_CONTAINER:
    { plgi_dealloc_arg(return_arg, return_arg_info->arg_info);
      break;
    }
    case GI_TRANSFER_EVERYTHING:
    { plgi_dealloc_arg_full(return_arg, return_arg_info->arg_info);
      break;
    }
  }

  PLGI_debug("  deallocating arg cache");
  plgi_dealloc_arg_cache(arg_cache, !ret & !func_invoked);

  PLGI_debug("  deallocating async cache");
  plgi_dealloc_async_cache();

  g_free(in_args);
  g_free(out_args);
  g_free(args_data);

  PLGI_debug("marshaller retval: %d", ret);

  PLGI_debug_trailer;

  return ret;
}


install_t
install_plgi()
{
  PLGI_PRED_REG("plgi_load_namespace", 1, plgi_load_namespace);
  PLGI_PRED_REG("plgi_load_namespace_from_dir", 2, plgi_load_namespace_from_dir);
  PLGI_PRED_REG("plgi_namespace_deps", 2, plgi_namespace_deps);

  PLGI_PRED_REG("plgi_registered_object", 1, plgi_registered_object);
  PLGI_PRED_REG("plgi_registered_struct", 1, plgi_registered_struct);
  PLGI_PRED_REG("plgi_registered_union", 1, plgi_registered_union);
  PLGI_PRED_REG("plgi_registered_enum", 1, plgi_registered_enum);
  PLGI_PRED_REG("plgi_registered_callback", 1, plgi_registered_callback);

  PLGI_PRED_REG("plgi_g_param_spec_value_type", 2, plgi_g_param_spec_value_type);

  PLGI_PRED_REG("plgi_g_is_object", 1, plgi_g_is_object);
  PLGI_PRED_REG("plgi_g_object_type", 2, plgi_g_object_type);
  PLGI_PRED_REG("plgi_object_new", 3, plgi_object_new);
  PLGI_PRED_REG("plgi_object_get_property", 3, plgi_object_get_property);
  PLGI_PRED_REG("plgi_object_set_property", 3, plgi_object_set_property);

  PLGI_PRED_REG("plgi_signal_connect_data", 6, plgi_signal_connect_data);
  PLGI_PRED_REG("plgi_signal_emit", 4, plgi_signal_emit);

  PLGI_PRED_REG("plgi_g_is_value", 1, plgi_g_is_value);
  PLGI_PRED_REG("plgi_g_value_holds", 2, plgi_g_value_holds);
  PLGI_PRED_REG("plgi_g_value_get_boxed", 2, plgi_g_value_get_boxed);
  PLGI_PRED_REG("plgi_g_value_set_boxed", 2, plgi_g_value_set_boxed);
  PLGI_PRED_REG("plgi_struct_new", 2, plgi_struct_new);
  PLGI_PRED_REG("plgi_struct_get_field", 3, plgi_struct_get_field);
  PLGI_PRED_REG("plgi_struct_set_field", 3, plgi_struct_set_field);
  PLGI_PRED_REG("plgi_struct_term", 2, plgi_struct_term);

  PLGI_PRED_REG("plgi_union_new", 2, plgi_union_new);
  PLGI_PRED_REG("plgi_union_get_field", 3, plgi_union_get_field);
  PLGI_PRED_REG("plgi_union_set_field", 3, plgi_union_set_field);

  PLGI_PRED_REG("plgi_enum_value", 2, plgi_enum_value);
}
