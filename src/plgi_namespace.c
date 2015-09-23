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



void plgi_register_callable(atom_t             namespace,
                            atom_t             name,
                            GICallableInfo    *callable_info,
                            PLGICallableInfo **reg_callable_info)
{
  PLGICallableInfo *reg_callable_info0;
  gint n_args, n_in_args, n_out_args, n_ret_args, arity;
  GITypeInfo *return_type_info;
  GITypeTag return_type_tag;
  gint array_length_pos, destroy_pos;
  guint arg_mask, in_arg_mask, out_arg_mask;
  gint i;

  n_args = g_callable_info_get_n_args(callable_info);
  return_type_info = g_callable_info_get_return_type(callable_info);
  return_type_tag = g_type_info_get_tag(return_type_info);

  PLGI_debug("registering callable: %s()", PL_atom_chars(name));

  arity = 0;
  n_in_args = n_out_args = n_ret_args = 0;
  in_arg_mask = out_arg_mask = 0;

  for ( i = 0; i < n_args; i++ )
  { GIArgInfo *arg_info;
    GITypeInfo *arg_type_info;
    GIDirection direction;

    arg_info = g_callable_info_get_arg(callable_info, i);
    arg_type_info = g_arg_info_get_type(arg_info);
    direction = g_arg_info_get_direction(arg_info);
    array_length_pos = g_type_info_get_array_length(arg_type_info);
    destroy_pos = g_arg_info_get_destroy(arg_info);

    g_base_info_unref(arg_type_info);

    if ( direction == GI_DIRECTION_IN || direction == GI_DIRECTION_INOUT )
    { n_in_args++;
      if ( g_arg_info_is_skip(arg_info) )
      { in_arg_mask |= 1 << i;
      }
      if ( array_length_pos != -1 )
      { in_arg_mask |= 1 << array_length_pos;
      }
      if ( destroy_pos != -1 )
      { in_arg_mask |= 1 << destroy_pos;
      }
    }

    if ( direction == GI_DIRECTION_OUT || direction == GI_DIRECTION_INOUT )
    { n_out_args++;
      if ( g_arg_info_is_skip(arg_info) )
      { out_arg_mask |= 1 << i;
      }
      if ( array_length_pos != -1 )
      { out_arg_mask |= 1 << array_length_pos;
      }
    }
  }

  if ( !g_callable_info_skip_return(callable_info) )
  {
    if ( return_type_tag != GI_TYPE_TAG_VOID &&
         return_type_tag != GI_TYPE_TAG_ERROR )
    { n_ret_args++;
    }
    else if ( return_type_tag == GI_TYPE_TAG_VOID &&
              g_type_info_is_pointer(return_type_info) )
    { n_ret_args++;
    }
  }

  array_length_pos = g_type_info_get_array_length(return_type_info);
  if ( array_length_pos != -1 )
  { out_arg_mask |= 1 << array_length_pos;
  }

  arg_mask = in_arg_mask | out_arg_mask;

  if ( g_callable_info_is_method(callable_info) )
  { n_args++;
    n_in_args++;
    arg_mask = arg_mask << 1;
  }

  i = 0;
  for ( ; in_arg_mask; i++ )
  { in_arg_mask &= in_arg_mask - 1;
  }
  for ( ; out_arg_mask; i++ )
  { out_arg_mask &= out_arg_mask - 1;
  }

  arity = n_in_args + n_out_args + n_ret_args - i;

  reg_callable_info0 = g_malloc0(sizeof(*reg_callable_info0));
  reg_callable_info0->info = callable_info;
  reg_callable_info0->namespace = namespace;
  reg_callable_info0->name = name;
  reg_callable_info0->n_args = n_args;
  reg_callable_info0->n_in_args = n_in_args;
  reg_callable_info0->n_out_args = n_out_args;
  reg_callable_info0->n_pl_args = arity;
  reg_callable_info0->arg_mask = arg_mask;
  if ( g_callable_info_is_method(callable_info) )
  { reg_callable_info0->flags |= PLGI_FUNC_IS_METHOD;
  }

  plgi_cache_callable_info(reg_callable_info0);

  if ( reg_callable_info )
  { *reg_callable_info = reg_callable_info0;
  }
}


void plgi_register_function(atom_t          namespace,
                            GIFunctionInfo *function_info)
{
  PLGICallableInfo *reg_function_info;
  atom_t name;

  name = PL_new_atom(g_function_info_get_symbol(function_info));

  PLGI_debug("registering function: %s", PL_atom_chars(name));

  plgi_register_callable(namespace, name, function_info, &reg_function_info);

  PL_register_foreign_in_module(PL_atom_chars(namespace), PL_atom_chars(name),
                                reg_function_info->n_pl_args,
                                plgi_marshaller__va, PL_FA_VARARGS);
}


void plgi_register_signal(atom_t        namespace,
                          atom_t        object_name,
                          GISignalInfo *signal_info)
{
  atom_t name;
  gchar buf[1024];

  g_snprintf(buf, sizeof(buf), "%s::%s",
             PL_atom_chars(object_name), g_base_info_get_name(signal_info));
  name = PL_new_atom(buf);

  PLGI_debug("registering signal: %s", PL_atom_chars(name));

  plgi_register_callable(namespace, name, signal_info, NULL);
}


void plgi_register_callback(atom_t          namespace,
                            GICallbackInfo *callback_info)
{
  atom_t name;
  gchar buf[1024];

  g_snprintf(buf, sizeof(buf), "%s%s",
             g_irepository_get_c_prefix(NULL, PL_atom_chars(namespace)),
             g_base_info_get_name(callback_info));
  name = PL_new_atom(buf);

  PLGI_debug("registering callback: %s", PL_atom_chars(name));

  plgi_register_callable(namespace, name, callback_info, NULL);
}


void plgi_register_interface(atom_t           namespace,
                             GIInterfaceInfo *interface_info)
{
  PLGIInterfaceInfo *reg_interface_info;
  GIFunctionInfo *function_info;
  GISignalInfo *signal_info;
  atom_t name;
  gint n_methods, n_signals, i;

  name = PL_new_atom(g_registered_type_info_get_type_name(interface_info));

  PLGI_debug("registering interface: %s", PL_atom_chars(name));

  reg_interface_info = g_malloc0(sizeof(*reg_interface_info));
  reg_interface_info->info = interface_info;
  reg_interface_info->namespace = namespace;
  reg_interface_info->name = name;
  reg_interface_info->n_properties = g_interface_info_get_n_properties(interface_info);

  n_methods = g_interface_info_get_n_methods(interface_info);
  for ( i = 0; i < n_methods; i++ )
  { function_info = g_interface_info_get_method(interface_info, i);
    plgi_register_function(namespace, function_info);
  }

  n_signals = g_interface_info_get_n_signals(interface_info);
  for ( i = 0; i < n_signals; i++ )
  { signal_info = g_interface_info_get_signal(interface_info, i);
    plgi_register_signal(namespace, name, signal_info);
  }

  plgi_cache_interface_info(reg_interface_info);
}


void plgi_register_object(atom_t        namespace,
                          GIObjectInfo *object_info)
{
  PLGIObjectInfo *reg_object_info;
  GIObjectInfo *parent_object_info;
  GIFunctionInfo *function_info;
  GISignalInfo *signal_info;
  atom_t name, parent_name;
  gint n_methods, n_signals, i;

  name = PL_new_atom(g_registered_type_info_get_type_name(object_info));

  PLGI_debug("registering object: %s", PL_atom_chars(name));

  reg_object_info = g_malloc0(sizeof(*reg_object_info));
  reg_object_info->info = object_info;
  reg_object_info->namespace = namespace;
  reg_object_info->name = name;
  reg_object_info->n_properties = g_object_info_get_n_properties(object_info);
  reg_object_info->n_interfaces = g_object_info_get_n_interfaces(object_info);

  parent_object_info = g_object_info_get_parent(object_info);
  if ( parent_object_info )
  { parent_name = PL_new_atom(g_registered_type_info_get_type_name(parent_object_info));
    reg_object_info->parent_name = parent_name;
    g_base_info_unref(parent_object_info);
  }

  n_methods = g_object_info_get_n_methods(object_info);
  for ( i = 0; i < n_methods; i++ )
  { function_info = g_object_info_get_method(object_info, i);
    plgi_register_function(namespace, function_info);
  }

  n_signals = g_object_info_get_n_signals(object_info);
  for ( i = 0; i < n_signals; i++ )
  { signal_info = g_object_info_get_signal(object_info, i);
    plgi_register_signal(namespace, name, signal_info);
  }

  plgi_cache_object_info(reg_object_info);
}


void plgi_register_struct(atom_t        namespace,
                          GIStructInfo *struct_info)
{
  PLGIStructInfo *reg_struct_info;
  GIFunctionInfo *function_info;
  atom_t name;
  gchar buf[1024];
  gint n_methods, i;

  if ( g_struct_info_is_gtype_struct(struct_info) )
  { return;
  }

  if ( g_registered_type_info_get_type_name(struct_info) )
  { name = PL_new_atom(g_registered_type_info_get_type_name(struct_info));
  }
  else
  { g_snprintf(buf, sizeof(buf), "%s%s",
               g_irepository_get_c_prefix(NULL, PL_atom_chars(namespace)),
               g_base_info_get_name(struct_info));
    name = PL_new_atom(buf);
  }

  PLGI_debug("registering struct: %s", PL_atom_chars(name));

  reg_struct_info = g_malloc0(sizeof(*reg_struct_info));
  reg_struct_info->info = struct_info;
  reg_struct_info->namespace = namespace;
  reg_struct_info->name = name;
  reg_struct_info->size = g_struct_info_get_size(struct_info);
  reg_struct_info->n_fields = g_struct_info_get_n_fields(struct_info);

  n_methods = g_struct_info_get_n_methods(struct_info);
  for ( i = 0; i < n_methods; i++ )
  { function_info = g_struct_info_get_method(struct_info, i);
    plgi_register_function(namespace, function_info);
  }

  plgi_cache_struct_info(reg_struct_info);
}


void plgi_register_union(atom_t       namespace,
                         GIUnionInfo *union_info)
{
  PLGIUnionInfo *reg_union_info;
  GIFunctionInfo *function_info;
  atom_t name;
  gchar buf[1024];
  gint n_methods, i;

  if ( g_registered_type_info_get_type_name(union_info) )
  { name = PL_new_atom(g_registered_type_info_get_type_name(union_info));
  }
  else
  { g_snprintf(buf, sizeof(buf), "%s%s",
               g_irepository_get_c_prefix(NULL, PL_atom_chars(namespace)),
               g_base_info_get_name(union_info));
    name = PL_new_atom(buf);
  }

  PLGI_debug("registering union: %s", PL_atom_chars(name));

  reg_union_info = g_malloc0(sizeof(*reg_union_info));
  reg_union_info->info = union_info;
  reg_union_info->namespace = namespace;
  reg_union_info->name = name;
  reg_union_info->size = g_union_info_get_size(union_info);
  reg_union_info->n_fields = g_union_info_get_n_fields(union_info);

  n_methods = g_union_info_get_n_methods(union_info);
  for ( i = 0; i < n_methods; i++ )
  { function_info = g_union_info_get_method(union_info, i);
    plgi_register_function(namespace, function_info);
  }

  plgi_cache_union_info(reg_union_info);
}


void plgi_register_enum(atom_t      namespace,
                        GIEnumInfo *enum_info)
{
  PLGIEnumInfo *reg_enum_info;
  GIFunctionInfo *function_info;
  atom_t name;
  gchar buf[1024];
  gint n_methods, i;

  if ( g_registered_type_info_get_type_name(enum_info) )
  { name = PL_new_atom(g_registered_type_info_get_type_name(enum_info));
  }
  else
  { g_snprintf(buf, sizeof(buf), "%s%s",
               g_irepository_get_c_prefix(NULL, PL_atom_chars(namespace)),
               g_base_info_get_name(enum_info));
    name = PL_new_atom(buf);
  }

  PLGI_debug("registering enum: %s", PL_atom_chars(name));

  reg_enum_info = g_malloc0(sizeof(*reg_enum_info));
  reg_enum_info->info = enum_info;
  reg_enum_info->namespace = namespace;
  reg_enum_info->name = name;
  reg_enum_info->type_tag = g_enum_info_get_storage_type(enum_info);
  reg_enum_info->n_values = g_enum_info_get_n_values(enum_info);

  n_methods = g_enum_info_get_n_methods(enum_info);
  for ( i = 0; i < n_methods; i++ )
  { function_info = g_enum_info_get_method(enum_info, i);
    plgi_register_function(namespace, function_info);
  }

  plgi_cache_enum_info(reg_enum_info);
}


void plgi_register_namespace(atom_t namespace)
{
  PLGINamespaceInfo *ns_info;
  const gchar *ns;
  gint n_infos, i;

  if ( plgi_get_namespace_info(namespace, &ns_info) )
  { return;
  }

  ns = PL_atom_chars(namespace);

  PLGI_debug("registering namespace: %s", ns);

  ns_info = g_malloc0(sizeof(*ns_info));
  ns_info->namespace = namespace;
  plgi_cache_namespace_info(ns_info);

  n_infos = g_irepository_get_n_infos(NULL, ns);
  for ( i = 0; i < n_infos; i++ )
  { GIBaseInfo *base_info;
    GIInfoType type;

    base_info = g_irepository_get_info(NULL, ns, i);
    type = g_base_info_get_type(base_info);

    if ( type == GI_INFO_TYPE_FUNCTION )
    { plgi_register_function(namespace, base_info);
    }
    else if ( type == GI_INFO_TYPE_OBJECT )
    { plgi_register_object(namespace, base_info);
    }
    else if ( type == GI_INFO_TYPE_INTERFACE )
    { plgi_register_interface(namespace, base_info);
    }
    else if ( type == GI_INFO_TYPE_STRUCT )
    { plgi_register_struct(namespace, base_info);
    }
    else if ( type == GI_INFO_TYPE_UNION )
    { plgi_register_union(namespace, base_info);
    }
    else if ( type == GI_INFO_TYPE_ENUM )
    { plgi_register_enum(namespace, base_info);
    }
    else if ( type == GI_INFO_TYPE_FLAGS )
    { plgi_register_enum(namespace, base_info);
    }
    else if ( type == GI_INFO_TYPE_CALLBACK )
    { plgi_register_callback(namespace, base_info);
    }
    else
    { /* FIXME: support namespace constants */
      g_base_info_unref(base_info);
    }
  }
}



                 /*******************************
                 *      Foreign Predicates      *
                 *******************************/

PLGI_PRED_IMPL(plgi_load_namespace)
{
  term_t namespace = FA0;

  atom_t name;
  GError *error = NULL;

  if ( !PL_get_atom(namespace, &name) )
  { return PL_type_error("atom", namespace);
  }

  g_irepository_require(NULL,                /* repository */
                        PL_atom_chars(name), /* namespace */
                        NULL,                /* version */
                        0,                   /* flags */
                        &error);             /* error */

  if ( error )
  { plgi_raise_error(error->message);
    g_error_free(error);
    return FALSE;
  }

  plgi_register_namespace(name);

  return TRUE;
}


PLGI_PRED_IMPL(plgi_load_namespace_from_dir)
{
  term_t namespace = FA0;
  term_t dir       = FA1;

  atom_t name;
  gchar *typelib_dir;
  GError *error = NULL;

  if ( !PL_get_atom(namespace, &name) )
  { return PL_type_error("atom", namespace);
  }

  if ( !PL_get_atom_chars(dir, &typelib_dir) )
  { return PL_type_error("atom", dir);
  }

  g_irepository_require_private(NULL,                /* repository */
                                typelib_dir,         /* typelib dir */
                                PL_atom_chars(name), /* namespace */
                                NULL,                /* version */
                                0,                   /* flags */
                                &error);             /* error */

  if ( error )
  { plgi_raise_error(error->message);
    g_error_free(error);
    return FALSE;
  }

  plgi_register_namespace(name);

  return TRUE;
}


PLGI_PRED_IMPL(plgi_namespace_deps)
{
  term_t namespace = FA0;
  term_t tdeps = FA1;

  atom_t name;
  gchar **deps;
  GError *error = NULL;
  int n_deps, i;
  term_t list = PL_copy_term_ref(tdeps);
  term_t head = PL_new_term_ref();

  if ( !PL_get_atom(namespace, &name) )
  { return PL_type_error("atom", namespace);
  }

  g_irepository_require(NULL,                /* repository */
                        PL_atom_chars(name), /* namespace */
                        NULL,                /* version */
                        0,                   /* flags */
                        &error);             /* error */

  if ( error )
  { plgi_raise_error(error->message);
    g_error_free(error);
    return FALSE;
  }

  deps = g_irepository_get_dependencies(NULL, PL_atom_chars(name));

  if ( !deps )
  { return PL_unify_nil(list);
  }

  n_deps = g_strv_length(deps);

  for ( i = 0; i < n_deps; i++ )
  { gchar **dep_tokens;
    term_t a = PL_new_term_ref();

    dep_tokens = g_strsplit(deps[i], "-", 2);

    if ( !plgi_utf8_to_term(dep_tokens[0], a) )
    { g_strfreev(deps);
      g_strfreev(dep_tokens);
      return FALSE;
    }

    if ( !(PL_unify_list(list, head, list) &&
           PL_unify(head, a)) )
    { g_strfreev(deps);
      g_strfreev(dep_tokens);
      return FALSE;
    }

    g_strfreev(dep_tokens);
  }
  g_strfreev(deps);

  if ( !PL_unify_nil(list) )
  { return FALSE;
  }

  return TRUE;
}


PLGI_PRED_IMPL(plgi_current_namespace)
{
  term_t namespace = FA0;
  control_t ctxt = FCTXT;

  PLGINamespaceInfo* info;
  int idx;

  switch(PL_foreign_control(ctxt))
  { case PL_FIRST_CALL:
    { idx = 0;
      break;
    }
    case PL_REDO:
    { idx = (int)PL_foreign_context(ctxt);
      break;
    }
    case PL_PRUNED:
    { return TRUE;
    }
    default:
    { assert(0);
    }
  }

  info = plgi_namespace_info_iter(&idx);

  if ( info )
  { if ( !PL_unify_atom(namespace, info->namespace) )
    { return FALSE;
    }
    PL_retry(idx);
  }
  else
  { return FALSE;
  }
}


PLGI_PRED_IMPL(plgi_registered_namespace)
{
  term_t object_name = FA0;

  atom_t name;
  PLGINamespaceInfo *namespace_info;

  if ( !PL_get_atom(object_name, &name) )
  { return PL_type_error("atom", object_name);
  }

  if ( !plgi_get_namespace_info(name, &namespace_info) )
  { return FALSE;
  }

  return TRUE;
}


PLGI_PRED_IMPL(plgi_registered_object)
{
  term_t object_name = FA0;

  atom_t name;
  PLGIObjectInfo *object_info;

  if ( !PL_get_atom(object_name, &name) )
  { return PL_type_error("atom", object_name);
  }

  if ( !plgi_get_object_info(name, &object_info) )
  { return FALSE;
  }

  return TRUE;
}


PLGI_PRED_IMPL(plgi_registered_enum)
{
  term_t enum_name = FA0;

  atom_t name;
  PLGIEnumInfo *enum_info;

  if ( !PL_get_atom(enum_name, &name) )
  { return PL_type_error("atom", enum_name);
  }

  if ( !plgi_get_enum_info(name, &enum_info) )
  { return FALSE;
  }

  return TRUE;
}


PLGI_PRED_IMPL(plgi_registered_struct)
{
  term_t struct_name = FA0;

  atom_t name;
  PLGIStructInfo *struct_info;

  if ( !PL_get_atom(struct_name, &name) )
  { return PL_type_error("atom", struct_name);
  }

  if ( !plgi_get_struct_info(name, &struct_info) )
  { return FALSE;
  }

  return TRUE;
}


PLGI_PRED_IMPL(plgi_registered_union)
{
  term_t union_name = FA0;

  atom_t name;
  PLGIUnionInfo *union_info;

  if ( !PL_get_atom(union_name, &name) )
  { return PL_type_error("atom", union_name);
  }

  if ( !plgi_get_union_info(name, &union_info) )
  { return FALSE;
  }

  return TRUE;
}


PLGI_PRED_IMPL(plgi_registered_callback)
{
  term_t callback_name = FA0;

  atom_t name;
  PLGICallableInfo *callback_info;

  if ( !PL_get_atom(callback_name, &name) )
  { return PL_type_error("atom", callback_name);
  }

  if ( !plgi_get_callable_info(name, &callback_info) )
  { return FALSE;
  }

  return TRUE;
}
