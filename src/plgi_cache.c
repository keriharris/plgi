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
                 *         PLGIArgCache         *
                 *******************************/

typedef struct PLGIArgCacheElement
{ PLGIArgInfo *arg_info;
  GIArgument arg;
} PLGIArgCacheElement;


typedef struct PLGIAsyncCacheElement
{ gpointer   data;
  void     (*free_fn)();
} PLGIAsyncCacheElement;



G_LOCK_DEFINE(cache_lock);

guint plgi_cache_id(void)
{
  static gint cache_id = 0;
  guint id;

  G_LOCK(cache_lock);
  id = cache_id++;
  G_UNLOCK(cache_lock);

  return id;
}

void
plgi_cache_arg(GIArgument   *arg,
               PLGIArgInfo  *arg_info,
               PLGIArgCache *arg_cache)
{
  PLGIArgCacheElement *element;

  element = g_malloc0(sizeof(*element));
  element->arg_info = arg_info;
  element->arg.v_pointer = arg->v_pointer;

  PLGI_debug("    arg: (%s) %p  -->  arg cache (0x%x) element: %p",
             g_type_tag_to_string(arg_info->type_tag), arg,
             arg_cache->id, &element->arg);

  arg_cache->elements = g_slist_prepend(arg_cache->elements, element);
}


void
plgi_dealloc_arg_cache(PLGIArgCache *arg_cache,
                       gboolean      free_everything)
{
  PLGIArgCacheElement *element;
  GSList *elements;

  PLGI_debug("    dealloc arg cache with ID: 0x%x", arg_cache->id);

  elements = arg_cache->elements;
  while ( elements )
  { element = elements->data;

    PLGI_debug("    dealloc arg cache element: (%s) %p  [xfer: %d]",
               g_type_tag_to_string(element->arg_info->type_tag),
               &element->arg, element->arg_info->transfer);

    if ( element->arg_info->transfer == GI_TRANSFER_NOTHING || free_everything )
    { plgi_dealloc_arg(&element->arg, element->arg_info);
    }
    g_free(element);
    elements = g_slist_next(elements);
  }

  g_slist_free(arg_cache->elements);
  g_free(arg_cache);
}


static GPrivate async_cache_key;

void
plgi_cache_in_async_store(gpointer data, void (*free_fn))
{
  GSList *async_cache;
  PLGIAsyncCacheElement *element;

  element = g_malloc0(sizeof(*element));
  element->free_fn = free_fn;
  element->data = data;

  PLGI_debug("    data: %p  -->  async cache element: %p", data, &element->data);

  async_cache = g_private_get(&async_cache_key);
  async_cache = g_slist_prepend(async_cache, element);
  g_private_set(&async_cache_key, async_cache);
}

void
plgi_dealloc_async_cache(void)
{
  GSList *async_cache;
  PLGIAsyncCacheElement *element;
  GSList *elements;

  async_cache = g_private_get(&async_cache_key);

  if ( !async_cache )
  { return;
  }

  elements = async_cache;
  while ( elements )
  { element = elements->data;

    PLGI_debug("    dealloc async cache element: %p", &element->data);

    if ( element->free_fn )
    { element->free_fn(element->data);
    }
    else
    { plgi_dealloc_arg_cache(element->data, FALSE);
    }
    g_free(element);
    elements = g_slist_next(elements);
  }

  g_slist_free(async_cache);
  g_private_set(&async_cache_key, NULL);
}



                 /*******************************
                 *      PLGINamespaceInfo       *
                 *******************************/

static GPtrArray *namespace_info_cache = NULL;

gboolean
plgi_get_namespace_info(atom_t              name,
                        PLGINamespaceInfo **info)
{
  PLGINamespaceInfo *info0;
  int i;

  if ( !namespace_info_cache )
  { return FALSE;
  }

  for ( i = 0; i < namespace_info_cache->len; i++ )
  { info0 = g_ptr_array_index(namespace_info_cache, i);
    if ( info0->namespace == name )
    { *info = info0;
      return TRUE;
    }
  }

  return FALSE;
}


gboolean
plgi_cache_namespace_info(PLGINamespaceInfo *info)
{
  PLGI_debug("cacheing namespace: %p (%s)",
             info, PL_atom_chars(info->namespace));

  if ( !namespace_info_cache )
  { namespace_info_cache = g_ptr_array_new();
  }

  g_ptr_array_add(namespace_info_cache, info);

  return TRUE;
}


PLGINamespaceInfo*
plgi_namespace_info_iter(int *idx)
{
  PLGINamespaceInfo *info = NULL;
  int i = *idx;

  if ( !namespace_info_cache )
  { return NULL;
  }

  if ( i >= namespace_info_cache->len )
  { return NULL;
  }

  info = g_ptr_array_index(namespace_info_cache, i);

  (*idx)++;

  return info;
}



                 /*******************************
                 *       PLGICallableInfo       *
                 *******************************/

static GHashTable *callable_info_cache = NULL;

gboolean
plgi_get_callable_info(atom_t             name,
                       PLGICallableInfo **callable_info)
{
  PLGICallableInfo *callable_info0;

  if ( !callable_info_cache )
  { return FALSE;
  }

  callable_info0 = g_hash_table_lookup(callable_info_cache, (gpointer)name);

  if ( !callable_info0 )
  { return FALSE;
  }

  if ( !callable_info0->args_info )
  { cache_callable_args_metadata(callable_info0, callable_info0->namespace);
  }

  *callable_info = callable_info0;

  return TRUE;
}


gboolean
plgi_cache_callable_info(PLGICallableInfo *callable_info)
{
  PLGINamespaceInfo *namespace_info;

  PLGI_debug("cacheing callable: %p (%s)",
             callable_info, PL_atom_chars(callable_info->name));

  if ( !callable_info_cache )
  { callable_info_cache = g_hash_table_new(NULL, NULL);
  }

  g_hash_table_insert(callable_info_cache, (gpointer)callable_info->name, callable_info);

  if ( plgi_get_namespace_info(callable_info->namespace, &namespace_info) )
  { namespace_info->n_functions++;
  }

  return TRUE;
}



                 /*******************************
                 *      PLGIInterfaceInfo       *
                 *******************************/

static GHashTable *interface_info_cache = NULL;

gboolean
plgi_get_interface_info(atom_t              name,
                        PLGIInterfaceInfo **interface_info)
{
  PLGIInterfaceInfo *interface_info0;

  if ( !interface_info_cache )
  { return FALSE;
  }

  interface_info0 = g_hash_table_lookup(interface_info_cache, (gpointer)name);

  if ( !interface_info0 )
  { return FALSE;
  }

  if ( !interface_info0->gtype )
  { interface_info0->gtype = g_registered_type_info_get_g_type(interface_info0->info);
  }

  if ( !interface_info0->properties_info )
  { gint n_properties, i;

    n_properties = interface_info0->n_properties;
    interface_info0->properties_info = g_malloc0_n(n_properties, sizeof(*interface_info0->properties_info));

    for ( i = 0; i < n_properties; i++ )
    { PLGIPropertyInfo *cached_property_info = interface_info0->properties_info + i;
      PLGIArgInfo *arg_info;
      GIPropertyInfo *property_info = g_interface_info_get_property(interface_info0->info, i);
      GITypeInfo *type_info = g_property_info_get_type(property_info);
      GITypeTag type_tag = g_type_info_get_tag(type_info);
      GITransfer transfer = g_property_info_get_ownership_transfer(property_info);
      atom_t property_namespace = PL_new_atom(g_base_info_get_namespace(type_info));

      PLGI_debug("    cacheing interface property \'%s\' (%s)",
                 g_base_info_get_name(property_info), g_type_tag_to_string(type_tag));

      cached_property_info->name = PL_new_atom(g_base_info_get_name(property_info));

      cache_args_metadata(type_info, GI_DIRECTION_INOUT, transfer,
                          GI_SCOPE_TYPE_INVALID, i, 0, 0,
                          property_namespace, &arg_info);
      cached_property_info->arg_info = arg_info;

      arg_info->flags |= PLGI_ARG_MAY_BE_NULL;
      if ( g_type_info_is_pointer(type_info) || !G_TYPE_TAG_IS_BASIC(type_tag) )
      { arg_info->flags |= PLGI_ARG_IS_POINTER;
      }

      g_base_info_unref(property_info);
      g_base_info_unref(type_info);
    }
  }

  *interface_info = interface_info0;

  return TRUE;
}


gboolean
plgi_cache_interface_info(PLGIInterfaceInfo *interface_info)
{
  PLGINamespaceInfo *namespace_info;

  PLGI_debug("cacheing interface info: %p (%s)",
             interface_info, PL_atom_chars(interface_info->name));

  if ( !interface_info_cache )
  { interface_info_cache = g_hash_table_new(NULL, NULL);
  }

  g_hash_table_insert(interface_info_cache, (gpointer)interface_info->name, interface_info);

  if ( plgi_get_namespace_info(interface_info->namespace, &namespace_info) )
  { namespace_info->n_interfaces++;
  }

  return TRUE;
}



                 /*******************************
                 *        PLGIObjectInfo        *
                 *******************************/

static GHashTable *object_info_cache = NULL;

gboolean
plgi_get_object_info(atom_t           name,
                     PLGIObjectInfo **object_info)
{
  PLGIObjectInfo *object_info0;

  if ( !object_info_cache )
  { return FALSE;
  }

  object_info0 = g_hash_table_lookup(object_info_cache, (gpointer)name);

  if ( !object_info0 )
  { return FALSE;
  }

  if ( !object_info0->gtype )
  { object_info0->gtype = g_registered_type_info_get_g_type(object_info0->info);
  }

  if ( !object_info0->interfaces_info )
  { gint n_interfaces, i;

    n_interfaces = object_info0->n_interfaces;
    object_info0->interfaces_info = g_malloc0_n(n_interfaces, sizeof(*object_info0->interfaces_info));

    for ( i = 0; i < n_interfaces; i++ )
    { PLGIInterfaceInfo **cached_interface_info = object_info0->interfaces_info + i;
      GIInterfaceInfo *interface_info = g_object_info_get_interface(object_info0->info, i);
      atom_t interface_name = PL_new_atom(g_registered_type_info_get_type_name(interface_info));
      atom_t interface_namespace = PL_new_atom(g_base_info_get_namespace(interface_info));

      PLGI_debug("    cacheing object interface \'%s\'",
                 PL_atom_chars(interface_name));

      if ( !plgi_get_interface_info(interface_name, cached_interface_info) )
      { plgi_register_interface(interface_namespace, interface_info);
        plgi_get_interface_info(interface_name, cached_interface_info);
      }

      g_base_info_unref(interface_info);
    }
  }

  if ( !object_info0->properties_info )
  { gint n_properties, i;

    n_properties = object_info0->n_properties;
    object_info0->properties_info = g_malloc0_n(n_properties, sizeof(*object_info0->properties_info));

    for ( i = 0; i < n_properties; i++ )
    { PLGIPropertyInfo *cached_property_info = object_info0->properties_info + i;
      PLGIArgInfo *arg_info;
      GIPropertyInfo *property_info = g_object_info_get_property(object_info0->info, i);
      GITypeInfo *type_info = g_property_info_get_type(property_info);
      GITypeTag type_tag = g_type_info_get_tag(type_info);
      GITransfer transfer = g_property_info_get_ownership_transfer(property_info);
      atom_t property_namespace = PL_new_atom(g_base_info_get_namespace(type_info));

      PLGI_debug("    cacheing object property \'%s\' (%s)",
                 g_base_info_get_name(property_info), g_type_tag_to_string(type_tag));

      cached_property_info->name = PL_new_atom(g_base_info_get_name(property_info));

      cache_args_metadata(type_info, GI_DIRECTION_INOUT, transfer,
                          GI_SCOPE_TYPE_INVALID, i, 0, 0,
                          property_namespace, &arg_info);
      cached_property_info->arg_info = arg_info;

      arg_info->flags |= PLGI_ARG_MAY_BE_NULL;
      if ( g_type_info_is_pointer(type_info) || !G_TYPE_TAG_IS_BASIC(type_tag) )
      { arg_info->flags |= PLGI_ARG_IS_POINTER;
      }

      g_base_info_unref(property_info);
      g_base_info_unref(type_info);
    }
  }

  *object_info = object_info0;

  return TRUE;
}


gboolean
plgi_cache_object_info(PLGIObjectInfo *object_info)
{
  PLGINamespaceInfo *namespace_info;

  PLGI_debug("cacheing object info: %p (%s)",
             object_info, PL_atom_chars(object_info->name));

  if ( !object_info_cache )
  { object_info_cache = g_hash_table_new(NULL, NULL);
  }

  g_hash_table_insert(object_info_cache, (gpointer)object_info->name, object_info);

  if ( plgi_get_namespace_info(object_info->namespace, &namespace_info) )
  { namespace_info->n_objects++;
  }

  return TRUE;
}



                 /*******************************
                 *        PLGIStructInfo        *
                 *******************************/

static GHashTable *struct_info_cache = NULL;

gboolean
plgi_get_struct_info(atom_t           name,
                     PLGIStructInfo **struct_info)
{
  PLGIStructInfo *struct_info0;

  if ( !struct_info_cache )
  { return FALSE;
  }

  struct_info0 = g_hash_table_lookup(struct_info_cache, (gpointer)name);

  if ( !struct_info0 )
  { return FALSE;
  }

  if ( !struct_info0->gtype )
  { struct_info0->gtype = g_registered_type_info_get_g_type(struct_info0->info);
  }

  if ( !struct_info0->fields_info )
  { gint n_fields, i;

    n_fields = struct_info0->n_fields;
    struct_info0->fields_info = g_malloc0_n(n_fields, sizeof(*struct_info0->fields_info));

    for ( i = 0; i < n_fields; i++ )
    { PLGIFieldInfo *cached_field_info = struct_info0->fields_info + i;
      PLGIArgInfo *arg_info;
      GIFieldInfo *field_info = g_struct_info_get_field(struct_info0->info, i);
      GITypeInfo *type_info = g_field_info_get_type(field_info);
      GITypeTag type_tag = g_type_info_get_tag(type_info);
      atom_t field_namespace = PL_new_atom(g_base_info_get_namespace(type_info));

      PLGI_debug("    cacheing struct field \'%s\' (%s)",
                 g_base_info_get_name(field_info), g_type_tag_to_string(type_tag));

      cached_field_info->name = PL_new_atom(g_base_info_get_name(field_info));
      cached_field_info->size = g_field_info_get_size(field_info);
      cached_field_info->offset = g_field_info_get_offset(field_info);
      cached_field_info->flags = g_field_info_get_flags(field_info);

      if ( cached_field_info->flags & GI_FIELD_IS_READABLE ||
           cached_field_info->flags & GI_FIELD_IS_WRITABLE )
      { cache_args_metadata(type_info, GI_DIRECTION_INOUT, GI_TRANSFER_EVERYTHING,
                            GI_SCOPE_TYPE_INVALID, i, 0, 0,
                            field_namespace, &arg_info);
        cached_field_info->arg_info = arg_info;

        arg_info->flags |= PLGI_ARG_MAY_BE_NULL;
      }

      g_base_info_unref(field_info);
      g_base_info_unref(type_info);
    }
  }

  *struct_info = struct_info0;

  return TRUE;
}


gboolean
plgi_cache_struct_info(PLGIStructInfo *struct_info)
{
  PLGINamespaceInfo *namespace_info;

  PLGI_debug("cacheing struct info: %p (%s)",
             struct_info, PL_atom_chars(struct_info->name));

  if ( !struct_info_cache )
  { struct_info_cache = g_hash_table_new(NULL, NULL);
  }

  g_hash_table_insert(struct_info_cache, (gpointer)struct_info->name, struct_info);

  if ( plgi_get_namespace_info(struct_info->namespace, &namespace_info) )
  { namespace_info->n_structs++;
  }

  return TRUE;
}



                 /*******************************
                 *        PLGIUnionInfo         *
                 *******************************/

static GHashTable *union_info_cache = NULL;

gboolean
plgi_get_union_info(atom_t          name,
                    PLGIUnionInfo **union_info)
{
  PLGIUnionInfo *union_info0;

  if ( !union_info_cache )
  { return FALSE;
  }

  union_info0 = g_hash_table_lookup(union_info_cache, (gpointer)name);

  if ( !union_info0 )
  { return FALSE;
  }

  if ( !union_info0->gtype )
  { union_info0->gtype = g_registered_type_info_get_g_type(union_info0->info);
  }

  if ( !union_info0->fields_info )
  { gint n_fields, i;

    n_fields = union_info0->n_fields;
    union_info0->fields_info = g_malloc0_n(n_fields, sizeof(*union_info0->fields_info));

    for ( i = 0; i < n_fields; i++ )
    { PLGIFieldInfo *cached_field_info = union_info0->fields_info + i;
      PLGIArgInfo *arg_info;
      GIFieldInfo *field_info = g_union_info_get_field(union_info0->info, i);
      GITypeInfo *type_info = g_field_info_get_type(field_info);
      GITypeTag type_tag = g_type_info_get_tag(type_info);
      atom_t field_namespace = PL_new_atom(g_base_info_get_namespace(type_info));

      PLGI_debug("      cacheing union field \'%s\' (%s)",
                 g_base_info_get_name(field_info), g_type_tag_to_string(type_tag));

      cached_field_info->name = PL_new_atom(g_base_info_get_name(field_info));
      cached_field_info->size = g_field_info_get_size(field_info);
      cached_field_info->offset = g_field_info_get_offset(field_info);
      cached_field_info->flags = g_field_info_get_flags(field_info);

      if ( cached_field_info->flags & GI_FIELD_IS_READABLE ||
           cached_field_info->flags & GI_FIELD_IS_WRITABLE )
      { cache_args_metadata(type_info, GI_DIRECTION_INOUT, GI_TRANSFER_EVERYTHING,
                            GI_SCOPE_TYPE_INVALID, i, 0, 0,
                            field_namespace, &arg_info);
        cached_field_info->arg_info = arg_info;

        arg_info->flags |= PLGI_ARG_MAY_BE_NULL;
      }

      g_base_info_unref(field_info);
      g_base_info_unref(type_info);
    }
  }

  *union_info = union_info0;

  return TRUE;
}


gboolean
plgi_cache_union_info(PLGIUnionInfo *union_info)
{
  PLGINamespaceInfo *namespace_info;

  PLGI_debug("cacheing union info: %p (%s)",
             union_info, PL_atom_chars(union_info->name));

  if ( !union_info_cache )
  { union_info_cache = g_hash_table_new(NULL, NULL);
  }

  g_hash_table_insert(union_info_cache, (gpointer)union_info->name, union_info);

  if ( plgi_get_namespace_info(union_info->namespace, &namespace_info) )
  { namespace_info->n_unions++;
  }

  return TRUE;
}



                 /*******************************
                 *         PLGIEnumInfo         *
                 *******************************/

static GHashTable *enum_info_cache = NULL;
static GHashTable *enum_cache = NULL;

gboolean
plgi_get_enum_info(atom_t         name,
                   PLGIEnumInfo **enum_info)
{
  PLGIEnumInfo *enum_info0;

  if ( !enum_info_cache )
  { return FALSE;
  }

  enum_info0 = g_hash_table_lookup(enum_info_cache, (gpointer)name);

  if ( !enum_info0 )
  { return FALSE;
  }

  if ( !enum_info0->gtype )
  { enum_info0->gtype = g_registered_type_info_get_g_type(enum_info0->info);
  }

  if ( !enum_info0->values_info )
  { gint n_values, i;

    n_values = enum_info0->n_values;
    enum_info0->values_info = g_malloc0_n(n_values, sizeof(*enum_info0->values_info));

    for ( i = 0; i < n_values; i++ )
    { PLGIValueInfo *cached_value_info = enum_info0->values_info + i;
      GIValueInfo *value_info = g_enum_info_get_value(enum_info0->info, i);
      const gchar *value = g_base_info_get_attribute(value_info, "c:identifier");

      PLGI_debug("      cacheing enum value \'%s\'",
                 g_base_info_get_name(value_info));

      cached_value_info->name = PL_new_atom(value);
      cached_value_info->value = g_value_info_get_value(value_info);

      g_base_info_unref(value_info);
    }
  }

  *enum_info = enum_info0;

  return TRUE;
}


gboolean
plgi_cache_enum_info(PLGIEnumInfo *enum_info)
{
  PLGINamespaceInfo *namespace_info;
  gint i;

  PLGI_debug("cacheing enum info: %p (%s)",
             enum_info, PL_atom_chars(enum_info->name));

  if ( !enum_info_cache )
  { enum_info_cache = g_hash_table_new(NULL, NULL);
  }

  g_hash_table_insert(enum_info_cache, (gpointer)enum_info->name, enum_info);

  if ( !enum_cache )
  { enum_cache = g_hash_table_new(NULL, NULL);
  }

  for ( i = 0; i < enum_info->n_values; i++ )
  { GIValueInfo *value_info = g_enum_info_get_value(enum_info->info, i);
    const gchar *value = g_base_info_get_attribute(value_info, "c:identifier");

    g_hash_table_insert(enum_cache, (gpointer)PL_new_atom(value),
                        (gpointer)g_value_info_get_value(value_info));

    g_base_info_unref(value_info);
  }

  if ( plgi_get_namespace_info(enum_info->namespace, &namespace_info) )
  { namespace_info->n_enums++;
  }

  return TRUE;
}


gboolean
plgi_get_enum_value(atom_t  value_name,
                    gint64 *enum_value)
{
  gpointer enum_value0;

  if ( !enum_cache )
  { return FALSE;
  }

  if ( !g_hash_table_lookup_extended(enum_cache, (gpointer)value_name, NULL,
                                     &enum_value0) )
  { return FALSE;
  }

  *enum_value = (gint64)(intptr_t)enum_value0;

  return TRUE;
}


gboolean
plgi_get_flags_value(term_t  t,
                     gint64 *flags_value)
{
  gint64 flags_value0 = 0;
  atom_t value_name;
  term_t list = PL_copy_term_ref(t);
  term_t head = PL_new_term_ref();

  if ( !enum_cache )
  { return FALSE;
  }

  if ( PL_skip_list(list, 0, NULL) != PL_LIST )
  { return FALSE;
  }

  while ( PL_get_list(list, head, list) )
  { gpointer flag_value;

    if ( !PL_get_atom(head, &value_name) )
    { return FALSE;
    }

    if ( !g_hash_table_lookup_extended(enum_cache, (gpointer)value_name, NULL,
                                       &flag_value) )
    { return FALSE;
    }

    flags_value0 |= (gint64)(intptr_t)flag_value;
  }

  *flags_value = flags_value0;

  return TRUE;
}



                 /*******************************
                 *    Callable ArgInfo Cache    *
                 *******************************/

void
cache_array_arg_metadata(GITypeInfo        *type_info,
                         GIDirection        direction,
                         GITransfer         transfer,
                         gint               arg_pos,
                         atom_t             namespace,
                         PLGIArrayArgInfo **array_arg_info)
{
  PLGIArrayArgInfo *array_arg_info0;
  PLGIArgInfo *element_arg_info;
  GITypeInfo *element_type_info;
  GITransfer element_transfer;
  atom_t element_namespace;

  array_arg_info0 = g_malloc0(sizeof(*array_arg_info0));

  PLGI_debug("    cacheing array arg metadata: %p", array_arg_info0);

  array_arg_info0->array_type = g_type_info_get_array_type(type_info);
  array_arg_info0->fixed_size = g_type_info_get_array_fixed_size(type_info);

  if ( array_arg_info0->fixed_size > 0 )
  { array_arg_info0->flags |= PLGI_ARRAY_IS_FIXED_SIZED;
  }

  if ( g_type_info_is_zero_terminated(type_info) )
  { array_arg_info0->flags |= PLGI_ARRAY_IS_ZERO_TERMINATED;
  }

  if ( g_type_info_get_array_length(type_info) != -1 )
  { gint offset = g_type_info_get_array_length(type_info) - arg_pos;
    array_arg_info0->length_arg_offset = offset;
    array_arg_info0->flags |= PLGI_ARRAY_HAS_LENGTH_ARG;
  }

  element_type_info = g_type_info_get_param_type(type_info, 0);
  element_namespace = PL_new_atom(g_base_info_get_namespace(element_type_info));

  if ( transfer == GI_TRANSFER_CONTAINER )
  { element_transfer = GI_TRANSFER_NOTHING;
  }
  else
  { element_transfer = transfer;
  }

  cache_args_metadata(element_type_info, direction, element_transfer,
                      GI_SCOPE_TYPE_INVALID, arg_pos, 0, 0,
                      element_namespace, &element_arg_info);

  element_arg_info->type_tag = g_type_info_get_tag(element_type_info);

  g_base_info_unref(element_type_info);

  array_arg_info0->element_info = element_arg_info;
  *array_arg_info = array_arg_info0;
}


void
cache_interface_arg_metadata(GIInterfaceInfo       *interface_info,
                             atom_t                 namespace,
                             atom_t                 name,
                             PLGIInterfaceArgInfo **interface_arg_info)
{
  PLGIInterfaceArgInfo *interface_arg_info0;
  PLGIInterfaceInfo *cached_interface_info;
  atom_t full_name;

  full_name = PL_new_atom(g_registered_type_info_get_type_name(interface_info));

  interface_arg_info0 = g_malloc0(sizeof(*interface_arg_info0));

  PLGI_debug("    cacheing interface arg metadata: (%s) %p",
             PL_atom_chars(full_name), interface_arg_info0);

  plgi_get_interface_info(full_name, &cached_interface_info);
  interface_arg_info0->interface_info = cached_interface_info;

  *interface_arg_info = interface_arg_info0;
}


void
cache_object_arg_metadata(GIObjectInfo       *object_info,
                          atom_t              namespace,
                          atom_t              name,
                          PLGIObjectArgInfo **object_arg_info)
{
  PLGIObjectArgInfo *object_arg_info0;
  PLGIObjectInfo *cached_object_info;
  atom_t full_name;

  full_name = PL_new_atom(g_registered_type_info_get_type_name(object_info));

  object_arg_info0 = g_malloc0(sizeof(*object_arg_info0));

  PLGI_debug("    cacheing object arg metadata: (%s) %p",
             PL_atom_chars(full_name), object_arg_info0);

  plgi_get_object_info(full_name, &cached_object_info);
  object_arg_info0->object_info = cached_object_info;

  *object_arg_info = object_arg_info0;
}


void
cache_struct_arg_metadata(GIStructInfo       *struct_info,
                          atom_t              namespace,
                          atom_t              name,
                          PLGIStructArgInfo **struct_arg_info)
{
  PLGIStructArgInfo *struct_arg_info0;
  PLGIStructInfo *cached_struct_info;
  gchar buf[1024];
  atom_t full_name;

  if ( g_registered_type_info_get_type_name(struct_info) )
  { full_name = PL_new_atom(g_registered_type_info_get_type_name(struct_info));
  }
  else
  { g_snprintf(buf, sizeof(buf), "%s%s",
               g_irepository_get_c_prefix(NULL, PL_atom_chars(namespace)),
               PL_atom_chars(name));
    full_name = PL_new_atom(buf);
  }

  struct_arg_info0 = g_malloc0(sizeof(*struct_arg_info0));

  PLGI_debug("    cacheing struct arg metadata: (%s) %p",
             PL_atom_chars(full_name), struct_arg_info0);

  plgi_get_struct_info(full_name, &cached_struct_info);
  struct_arg_info0->struct_info = cached_struct_info;

  *struct_arg_info = struct_arg_info0;
}


void
cache_union_arg_metadata(GIUnionInfo       *union_info,
                         atom_t             namespace,
                         atom_t             name,
                         PLGIUnionArgInfo **union_arg_info)
{
  PLGIUnionArgInfo *union_arg_info0;
  PLGIUnionInfo *cached_union_info;
  gchar buf[1024];
  atom_t full_name;

  if ( g_registered_type_info_get_type_name(union_info) )
  { full_name = PL_new_atom(g_registered_type_info_get_type_name(union_info));
  }
  else
  { g_snprintf(buf, sizeof(buf), "%s%s",
               g_irepository_get_c_prefix(NULL, PL_atom_chars(namespace)),
               PL_atom_chars(name));
    full_name = PL_new_atom(buf);
  }

  union_arg_info0 = g_malloc0(sizeof(*union_arg_info0));

  PLGI_debug("    cacheing union arg metadata: (%s) %p",
             PL_atom_chars(full_name), union_arg_info0);

  plgi_get_union_info(full_name, &cached_union_info);
  union_arg_info0->union_info = cached_union_info;

  *union_arg_info = union_arg_info0;
}


void
cache_enum_arg_metadata(GIEnumInfo       *enum_info,
                        atom_t            namespace,
                        atom_t            name,
                        PLGIEnumArgInfo **enum_arg_info)
{
  PLGIEnumArgInfo *enum_arg_info0;
  PLGIEnumInfo *cached_enum_info;
  gchar buf[1024];
  atom_t full_name;

  if ( g_registered_type_info_get_type_name(enum_info) )
  { full_name = PL_new_atom(g_registered_type_info_get_type_name(enum_info));
  }
  else
  { g_snprintf(buf, sizeof(buf), "%s%s",
               g_irepository_get_c_prefix(NULL, PL_atom_chars(namespace)),
               PL_atom_chars(name));
    full_name = PL_new_atom(buf);
  }

  enum_arg_info0 = g_malloc0(sizeof(*enum_arg_info0));

  PLGI_debug("    cacheing enum arg metadata: (%s) %p",
             PL_atom_chars(full_name), enum_arg_info0);

  plgi_get_enum_info(full_name, &cached_enum_info);
  enum_arg_info0->enum_info = cached_enum_info;

  *enum_arg_info = enum_arg_info0;
}


void
cache_callback_arg_metadata(GICallbackInfo       *callback_info,
                            GIScopeType           scope,
                            gint                  arg_pos,
                            gint                  closure_pos,
                            gint                  destroy_pos,
                            atom_t                namespace,
                            atom_t                name,
                            PLGICallbackArgInfo **callback_arg_info)
{
  PLGICallbackArgInfo *callback_arg_info0;
  PLGICallableInfo *cached_callable_info;
  gchar buf[1024];
  atom_t full_name;

  g_snprintf(buf, sizeof(buf), "%s%s",
             g_irepository_get_c_prefix(NULL, PL_atom_chars(namespace)),
             PL_atom_chars(name));
  full_name = PL_new_atom(buf);

  callback_arg_info0 = g_malloc0(sizeof(*callback_arg_info0));

  PLGI_debug("    cacheing callback arg metadata: (%s) %p",
             PL_atom_chars(name), callback_arg_info0);

  callback_arg_info0->scope = scope;
  if ( closure_pos != -1 )
  { callback_arg_info0->closure_offset = closure_pos - arg_pos;
  }
  if ( destroy_pos != -1 )
  { callback_arg_info0->destroy_offset = destroy_pos - arg_pos;
  }

  plgi_get_callable_info(full_name, &cached_callable_info);
  callback_arg_info0->callback_info = cached_callable_info;

  *callback_arg_info = callback_arg_info0;
}


void
cache_abstract_arg_metadata(GIBaseInfo           *base_info,
                            GIDirection           direction,
                            GITransfer            transfer,
                            GIScopeType           scope,
                            gint                  arg_pos,
                            gint                  closure_pos,
                            gint                  destroy_pos,
                            atom_t                namespace,
                            PLGIAbstractArgInfo **abstract_arg_info)
{
  PLGIAbstractArgInfo *abstract_arg_info0;
  atom_t abstract_arg_namespace, name;

  //PLGI_debug("    cacheing interface arg metadata: %p", abstract_arg_info0);

  GIInfoType info_type = g_base_info_get_type(base_info);

  name = PL_new_atom(g_base_info_get_name(base_info));
  abstract_arg_namespace = PL_new_atom(g_base_info_get_namespace(base_info));

  switch ( info_type )
  {
    case GI_INFO_TYPE_INTERFACE:
    { cache_interface_arg_metadata(base_info, abstract_arg_namespace, name,
                                   (PLGIInterfaceArgInfo**)&abstract_arg_info0);
      abstract_arg_info0->abstract_arg_type = PLGI_ABSTRACT_ARG_INTERFACE;
      break;
    }

    case GI_INFO_TYPE_OBJECT:
    { cache_object_arg_metadata(base_info, abstract_arg_namespace, name,
                                (PLGIObjectArgInfo**)&abstract_arg_info0);
      abstract_arg_info0->abstract_arg_type = PLGI_ABSTRACT_ARG_OBJECT;
      break;
    }

    case GI_INFO_TYPE_STRUCT:
    { GType gtype = g_registered_type_info_get_g_type(base_info);

      if ( gtype == G_TYPE_STRV )
      { abstract_arg_info0 = g_malloc0(sizeof(*abstract_arg_info0));
        abstract_arg_info0->abstract_arg_type = PLGI_ABSTRACT_ARG_GSTRV;
        break;
      }

      else if ( gtype == G_TYPE_BYTES )
      { abstract_arg_info0 = g_malloc0(sizeof(*abstract_arg_info0));
        abstract_arg_info0->abstract_arg_type = PLGI_ABSTRACT_ARG_GBYTES;
        break;
      }

      else
      { cache_struct_arg_metadata(base_info, abstract_arg_namespace, name,
                                  (PLGIStructArgInfo**)&abstract_arg_info0);
        abstract_arg_info0->abstract_arg_type = PLGI_ABSTRACT_ARG_STRUCT;
        break;
      }
    }

    case GI_INFO_TYPE_UNION:
    { cache_union_arg_metadata(base_info, abstract_arg_namespace, name,
                               (PLGIUnionArgInfo**)&abstract_arg_info0);
      abstract_arg_info0->abstract_arg_type = PLGI_ABSTRACT_ARG_UNION;
      break;
    }

    case GI_INFO_TYPE_ENUM:
    { cache_enum_arg_metadata(base_info, abstract_arg_namespace, name,
                              (PLGIEnumArgInfo**)&abstract_arg_info0);
      abstract_arg_info0->abstract_arg_type = PLGI_ABSTRACT_ARG_ENUM;
      break;
    }

    case GI_INFO_TYPE_FLAGS:
    { cache_enum_arg_metadata(base_info, abstract_arg_namespace, name,
                              (PLGIEnumArgInfo**)&abstract_arg_info0);
      abstract_arg_info0->abstract_arg_type = PLGI_ABSTRACT_ARG_FLAG;
      break;
    }

    case GI_INFO_TYPE_CALLBACK:
    { cache_callback_arg_metadata(base_info, scope, arg_pos, closure_pos,
                                  destroy_pos, abstract_arg_namespace, name,
                                  (PLGICallbackArgInfo**)&abstract_arg_info0);
      abstract_arg_info0->abstract_arg_type = PLGI_ABSTRACT_ARG_CALLBACK;
      break;
    }

    default:
    { g_assert_not_reached();
    }
  }

  *abstract_arg_info = abstract_arg_info0;
}


void
cache_list_arg_metadata(GITypeInfo       *type_info,
                        GIDirection       direction,
                        GITransfer        transfer,
                        gint              arg_pos,
                        atom_t            namespace,
                        PLGIListArgInfo **list_arg_info)
{
  PLGIListArgInfo *list_arg_info0;
  PLGIArgInfo *element_arg_info;
  GITypeInfo *element_type_info;
  GITransfer element_transfer;
  atom_t element_namespace;

  list_arg_info0 = g_malloc0(sizeof(*list_arg_info0));

  PLGI_debug("    cacheing list arg metadata: %p", list_arg_info0);

  element_type_info = g_type_info_get_param_type(type_info, 0);
  element_namespace = PL_new_atom(g_base_info_get_namespace(element_type_info));

  if ( transfer == GI_TRANSFER_CONTAINER )
  { element_transfer = GI_TRANSFER_NOTHING;
  }
  else
  { element_transfer = transfer;
  }

  cache_args_metadata(element_type_info, direction, element_transfer,
                      GI_SCOPE_TYPE_INVALID, arg_pos, 0, 0,
                      element_namespace, &element_arg_info);

  element_arg_info->type_tag = g_type_info_get_tag(element_type_info);
  element_arg_info->flags |= PLGI_ARG_IS_POINTER;

  g_base_info_unref(element_type_info);

  list_arg_info0->element_info = element_arg_info;
  *list_arg_info = list_arg_info0;
}


void
cache_hashtable_arg_metadata(GITypeInfo            *type_info,
                             GIDirection            direction,
                             GITransfer             transfer,
                             gint                   arg_pos,
                             atom_t                 namespace,
                             PLGIHashTableArgInfo **hash_table_arg_info)
{
  PLGIHashTableArgInfo *hash_table_arg_info0;
  PLGIArgInfo *key_arg_info;
  PLGIArgInfo *value_arg_info;
  GITypeInfo *key_type_info;
  GITypeInfo *value_type_info;
  GITransfer key_value_transfer;
  atom_t key_namespace, value_namespace;

  hash_table_arg_info0 = g_malloc0(sizeof(*hash_table_arg_info0));

  PLGI_debug("    cacheing hash table arg metadata: %p", hash_table_arg_info0);

  key_type_info = g_type_info_get_param_type(type_info, 0);
  value_type_info = g_type_info_get_param_type(type_info, 1);

  key_namespace = PL_new_atom(g_base_info_get_namespace(key_type_info));
  value_namespace = PL_new_atom(g_base_info_get_namespace(value_type_info));

  if ( transfer == GI_TRANSFER_CONTAINER )
  { key_value_transfer = GI_TRANSFER_NOTHING;
  }
  else
  { key_value_transfer = transfer;
  }

  cache_args_metadata(key_type_info, direction, key_value_transfer,
                      GI_SCOPE_TYPE_INVALID, arg_pos, 0, 0,
                      key_namespace, &key_arg_info);
  key_arg_info->type_tag = g_type_info_get_tag(key_type_info);

  cache_args_metadata(value_type_info, direction, key_value_transfer,
                      GI_SCOPE_TYPE_INVALID, arg_pos, 0, 0,
                      value_namespace, &value_arg_info);
  value_arg_info->type_tag = g_type_info_get_tag(value_type_info);
  value_arg_info->flags |= PLGI_ARG_IS_POINTER;

  g_base_info_unref(key_type_info);
  g_base_info_unref(value_type_info);

  hash_table_arg_info0->key_info = key_arg_info;
  hash_table_arg_info0->value_info = value_arg_info;
  *hash_table_arg_info = hash_table_arg_info0;
}


void
cache_args_metadata(GITypeInfo   *type_info,
                    GIDirection   direction,
                    GITransfer    transfer,
                    GIScopeType   scope,
                    gint          arg_pos,
                    gint          closure_pos,
                    gint          destroy_pos,
                    atom_t        namespace,
                    PLGIArgInfo **arg_info)
{
  PLGIArgInfo *arg_info0;
  GITypeTag type_tag = g_type_info_get_tag(type_info);

  PLGI_debug("    cacheing arg type metadata: (%s) %p",
             g_type_tag_to_string(type_tag), arg_info0);

  switch ( type_tag )
  {
    case GI_TYPE_TAG_VOID:
    case GI_TYPE_TAG_BOOLEAN:
    case GI_TYPE_TAG_INT8:
    case GI_TYPE_TAG_UINT8:
    case GI_TYPE_TAG_INT16:
    case GI_TYPE_TAG_UINT16:
    case GI_TYPE_TAG_INT32:
    case GI_TYPE_TAG_UINT32:
    case GI_TYPE_TAG_INT64:
    case GI_TYPE_TAG_UINT64:
    case GI_TYPE_TAG_FLOAT:
    case GI_TYPE_TAG_DOUBLE:
    case GI_TYPE_TAG_GTYPE:
    case GI_TYPE_TAG_UTF8:
    case GI_TYPE_TAG_FILENAME:
    { arg_info0 = g_malloc0(sizeof(*arg_info0));
      break;
    }

    case GI_TYPE_TAG_ARRAY:
    { cache_array_arg_metadata(type_info, direction, transfer, arg_pos,
                               namespace, (PLGIArrayArgInfo**)&arg_info0);
      break;
    }

    case GI_TYPE_TAG_INTERFACE:
    { GIBaseInfo *base_info = g_type_info_get_interface(type_info);
      cache_abstract_arg_metadata(base_info, direction, transfer, scope,
                                  arg_pos, closure_pos, destroy_pos,
                                  namespace, (PLGIAbstractArgInfo**)&arg_info0);
      g_base_info_unref(base_info);
      break;
    }

    case GI_TYPE_TAG_GLIST:
    case GI_TYPE_TAG_GSLIST:
    { cache_list_arg_metadata(type_info, direction, transfer, arg_pos,
                              namespace, (PLGIListArgInfo**)&arg_info0);
      break;
    }

    case GI_TYPE_TAG_GHASH:
    { cache_hashtable_arg_metadata(type_info, direction, transfer, arg_pos,
                                   namespace, (PLGIHashTableArgInfo**)&arg_info0);
      break;
    }

    case GI_TYPE_TAG_ERROR:
    { arg_info0 = g_malloc0(sizeof(*arg_info0));
      break;
    }

    case GI_TYPE_TAG_UNICHAR:
    { arg_info0 = g_malloc0(sizeof(*arg_info0));
      break;
    }

    default:
    { g_assert_not_reached();
    }
  }

  arg_info0->type_tag = type_tag;
  arg_info0->direction = direction;
  arg_info0->transfer = transfer;

  if ( g_type_info_is_pointer(type_info) )
  { arg_info0->flags |= PLGI_ARG_IS_POINTER;
  }

  *arg_info =  arg_info0;
}


void
cache_callable_args_metadata(PLGICallableInfo *func_info,
                             atom_t            namespace)
{
  PLGIBaseArgInfo *base_args_info;
  PLGIBaseArgInfo *base_arg_info;
  PLGIArgInfo *arg_info;
  GICallableInfo *function_info;
  GITypeInfo *type_info;
  GITypeTag type_tag;
  gint n_args, in_pos, out_pos;
  gint offset, i;

  PLGI_debug("  cacheing callable: (%s) %p",
             PL_atom_chars(func_info->name), func_info);

  function_info = func_info->info;
  n_args = func_info->n_args;

  base_args_info = g_malloc0_n(n_args+2, sizeof(*base_args_info));

  in_pos = 0;
  out_pos = 0;
  offset = 0;

  /* constuctor */
  if ( func_info->flags & PLGI_FUNC_IS_METHOD )
  { GIBaseInfo *container;
    atom_t name;

    container = g_base_info_get_container(function_info);
    name = PL_new_atom(g_base_info_get_name(container));

    PLGI_debug("  cacheing arg 0: instance arg (%s)", PL_atom_chars(name));

    base_arg_info = base_args_info;
    base_arg_info->in_pos = in_pos++;
    base_arg_info->out_pos = -1;
    base_arg_info->direction = GI_DIRECTION_IN;
    base_arg_info->transfer = GI_TRANSFER_NOTHING;

    if ( GI_IS_INTERFACE_INFO(container) ||
         GI_IS_OBJECT_INFO(container) ||
         GI_IS_STRUCT_INFO(container) ||
         GI_IS_UNION_INFO(container) )
    { cache_abstract_arg_metadata(container, GI_DIRECTION_IN, GI_TRANSFER_NOTHING,
                                  GI_SCOPE_TYPE_INVALID, 0, 0, 0, namespace,
                                  (PLGIAbstractArgInfo**)&base_arg_info->arg_info);
      arg_info = base_arg_info->arg_info;
      arg_info->type_tag = GI_TYPE_TAG_INTERFACE;
      arg_info->direction = GI_DIRECTION_IN;
      arg_info->transfer = GI_TRANSFER_NOTHING;
      arg_info->flags |= PLGI_ARG_IS_TOPLEVEL;
      arg_info->flags |= PLGI_ARG_IS_POINTER;
    }

    else
    { g_assert_not_reached();
    }

    offset = 1;

    g_base_info_unref(container);
  }

  /* args */
  for ( i = 0; i < n_args-offset; i++ )
  { GIArgInfo *gi_arg_info;
    GIScopeType scope;
    gint closure_pos, destroy_pos;
    gint arg_pos = i;

    gi_arg_info = g_callable_info_get_arg(function_info, arg_pos);
    type_info = g_arg_info_get_type(gi_arg_info);
    type_tag = g_type_info_get_tag(type_info);
    scope = g_arg_info_get_scope(gi_arg_info);
    closure_pos = g_arg_info_get_closure(gi_arg_info);
    destroy_pos = g_arg_info_get_destroy(gi_arg_info);

    base_arg_info = base_args_info + arg_pos + offset;

    PLGI_debug("  cacheing arg %d: \'%s\' %p",
               i+offset, g_base_info_get_name(gi_arg_info), base_arg_info);

    base_arg_info->in_pos = -1;
    base_arg_info->out_pos = -1;
    base_arg_info->direction = g_arg_info_get_direction(gi_arg_info);
    base_arg_info->transfer = g_arg_info_get_ownership_transfer(gi_arg_info);

    if ( base_arg_info->direction == GI_DIRECTION_IN ||
         base_arg_info->direction == GI_DIRECTION_INOUT )
    { base_arg_info->in_pos = in_pos++;
    }
    if ( base_arg_info->direction == GI_DIRECTION_OUT ||
         base_arg_info->direction == GI_DIRECTION_INOUT )
    { base_arg_info->out_pos = out_pos++;
    }

    cache_args_metadata(type_info, base_arg_info->direction,
                        base_arg_info->transfer, scope, arg_pos, closure_pos,
                        destroy_pos, namespace, &base_arg_info->arg_info);

    arg_info = base_arg_info->arg_info;
    arg_info->flags |= PLGI_ARG_IS_TOPLEVEL;

    if ( g_arg_info_may_be_null(gi_arg_info) )
    { arg_info->flags |= PLGI_ARG_MAY_BE_NULL;
    }

    if ( g_arg_info_is_caller_allocates(gi_arg_info) )
    { arg_info->flags |= PLGI_ARG_IS_CALLER_ALLOCATES;
    }

    g_base_info_unref(gi_arg_info);
    g_base_info_unref(type_info);
  }

  for ( i = 0; i < n_args-offset; i++ )
  { GIArgInfo *gi_arg_info;
    gint closure_pos;
    gint arg_pos = i;

    gi_arg_info = g_callable_info_get_arg(function_info, arg_pos);
    closure_pos = g_arg_info_get_closure(gi_arg_info);

    if ( closure_pos != -1 )
    { PLGIBaseArgInfo *closure_arg_info;
      closure_arg_info = base_args_info + closure_pos + offset;
      closure_arg_info->arg_info->flags |= PLGI_ARG_IS_CLOSURE;
    }

    g_base_info_unref(gi_arg_info);
  }

  /* return arg */
  type_info = g_callable_info_get_return_type(function_info);
  type_tag = g_type_info_get_tag(type_info);

  PLGI_debug("  cacheing return arg (%s)", g_type_tag_to_string(type_tag));

  base_arg_info = base_args_info + n_args;
  base_arg_info->in_pos = -1;
  base_arg_info->out_pos = out_pos;
  base_arg_info->direction = GI_DIRECTION_OUT;
  base_arg_info->transfer = g_callable_info_get_caller_owns(function_info);

  cache_args_metadata(type_info, base_arg_info->direction,
                      base_arg_info->transfer, GI_SCOPE_TYPE_INVALID,
                      n_args-offset, 0, 0, namespace, &base_arg_info->arg_info);

  arg_info = base_arg_info->arg_info;
  arg_info->flags |= PLGI_ARG_IS_TOPLEVEL;
  if ( g_callable_info_may_return_null(function_info) )
  { arg_info->flags |= PLGI_ARG_MAY_BE_NULL;
  }

  g_base_info_unref(type_info);

  func_info->args_info = base_args_info;
}
