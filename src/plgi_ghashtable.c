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
                 *     Internal Functions      *
                 *******************************/

gboolean
plgi_ghashtable_key(GIArgument  *key_arg,
                    PLGIArgInfo *arg_info,
                    gpointer    *key)
{
  if ( arg_info->flags & PLGI_ARG_IS_POINTER )
  { *key = key_arg->v_pointer;
    return TRUE;
  }

  switch ( arg_info->type_tag )
  {
    case GI_TYPE_TAG_VOID:
    { *key = key_arg->v_pointer;
    }

    case GI_TYPE_TAG_BOOLEAN:
    { *key = (gpointer)(uintptr_t)key_arg->v_boolean;
      break;
    }

    case GI_TYPE_TAG_INT8:
    { *key = (gpointer)(uintptr_t)key_arg->v_int8;
      break;
    }

    case GI_TYPE_TAG_UINT8:
    { *key = (gpointer)(uintptr_t)key_arg->v_uint8;
      break;
    }

    case GI_TYPE_TAG_INT16:
    { *key = (gpointer)(uintptr_t)key_arg->v_int16;
      break;
    }

    case GI_TYPE_TAG_UINT16:
    { *key = (gpointer)(uintptr_t)key_arg->v_uint16;
      break;
    }

    case GI_TYPE_TAG_INT32:
    { *key = (gpointer)(uintptr_t)key_arg->v_int32;
      break;
    }

    case GI_TYPE_TAG_UINT32:
    { *key = (gpointer)(uintptr_t)key_arg->v_uint32;
      break;
    }

    case GI_TYPE_TAG_INT64:
    { *key = (gpointer)(uintptr_t)key_arg->v_int64;
      break;
    }

    case GI_TYPE_TAG_UINT64:
    { *key = (gpointer)(uintptr_t)key_arg->v_uint64;
      break;
    }

    case GI_TYPE_TAG_FLOAT:
    { *key = (gpointer)(uintptr_t)key_arg->v_float;
      break;
    }

    case GI_TYPE_TAG_DOUBLE:
    { *key = (gpointer)(uintptr_t)key_arg->v_double;
      break;
    }

    case GI_TYPE_TAG_GTYPE:
    { *key = (gpointer)(uintptr_t)key_arg->v_size;
      break;
    }

    case GI_TYPE_TAG_UTF8:
    case GI_TYPE_TAG_FILENAME:
    { *key = (gpointer)(gchar*)key_arg->v_string;
      break;
    }

    case GI_TYPE_TAG_ARRAY:
    case GI_TYPE_TAG_INTERFACE:
    case GI_TYPE_TAG_GLIST:
    case GI_TYPE_TAG_GSLIST:
    case GI_TYPE_TAG_GHASH:
    case GI_TYPE_TAG_ERROR:
    { plgi_raise_error__va("GHashTable key type %s not supported",
                           g_type_tag_to_string(arg_info->type_tag));
      return FALSE;
    }

    case GI_TYPE_TAG_UNICHAR:
    { *key = (gpointer)(uintptr_t)key_arg->v_uint32;
      break;
    }

    default:
    { g_assert_not_reached();
    }
  }

  return TRUE;
}



                 /*******************************
                 *        GHashTable Arg        *
                 *******************************/

gboolean
plgi_term_to_ghashtable(term_t                 t,
                        PLGIHashTableArgInfo  *hash_table_arg_info,
                        PLGIArgCache          *arg_cache,
                        GHashTable           **hash_table)
{
  GHashTable *hash_table0 = NULL;
  term_t list = PL_copy_term_ref(t);
  term_t head = PL_new_term_ref();

  if ( PL_skip_list(list, 0, NULL) != PL_LIST )
  { return PL_type_error("list", t);
  }

  if ( !plgi_alloc_ghashtable(&hash_table0, hash_table_arg_info) )
  { return FALSE;
  }

  while ( PL_get_list(list, head, list) )
  { term_t t_key = PL_new_term_ref();
    term_t t_value = PL_new_term_ref();
    atom_t name;
    gsize arity;
    GIArgument key_arg;
    gpointer key = NULL;
    gpointer value = NULL;

    atom_t ATOM_dash = PL_new_atom("-");

    if ( !( PL_get_name_arity(head, &name, &arity) &&
            name == ATOM_dash && arity == 2 ) )
    { g_hash_table_destroy(hash_table0);
      return PL_type_error("key-value pair", head);
    }

    _PL_get_arg(1, head, t_key);

    if ( !plgi_term_to_arg(t_key, hash_table_arg_info->key_info, arg_cache, (GIArgument*)&key_arg) )
    { g_hash_table_destroy(hash_table0);
      return FALSE;
    }

    if ( !plgi_ghashtable_key(&key_arg, hash_table_arg_info->key_info, &key) )
    { g_hash_table_destroy(hash_table0);
      return FALSE;
    }

    _PL_get_arg(2, head, t_value);

    if ( !plgi_term_to_arg(t_value, hash_table_arg_info->value_info, arg_cache, (GIArgument*)&value) )
    { g_hash_table_destroy(hash_table0);
      return FALSE;
    }

    g_hash_table_insert(hash_table0, key, value);
  }

  if ( !PL_get_nil(list) )
  { g_hash_table_destroy(hash_table0);
    return FALSE;
  }

  *hash_table = hash_table0;

  return TRUE;
}


gboolean
plgi_ghashtable_to_term(GHashTable           *hash_table,
                        PLGIHashTableArgInfo *hash_table_arg_info,
                        term_t                t)
{
  term_t list = PL_copy_term_ref(t);
  term_t head = PL_new_term_ref();
  GHashTableIter iter;
  gpointer key;
  gpointer value;

  if ( !hash_table )
  { return PL_put_nil(t);
  }

  g_hash_table_iter_init(&iter, hash_table);

  functor_t f_dash = PL_new_functor(PL_new_atom("-"), 2);

  while ( g_hash_table_iter_next(&iter, &key, &value) )
  {
    term_t key_value_pair = PL_new_term_ref();
    term_t t_key = PL_new_term_ref();
    term_t t_value = PL_new_term_ref();

    if ( !plgi_arg_to_term((GIArgument*)&key, hash_table_arg_info->key_info, t_key) )
    { return FALSE;
    }
    if ( !plgi_arg_to_term((GIArgument*)&value, hash_table_arg_info->value_info, t_value) )
    { return FALSE;
    }

    if ( !PL_cons_functor(key_value_pair, f_dash, t_key, t_value) )
    { return FALSE;
    }

    if ( !(PL_unify_list(list, head, list) &&
           PL_unify(head, key_value_pair)) )
    { return FALSE;
    }
  }

  return PL_unify_nil(list);
}


gboolean
plgi_alloc_ghashtable(GHashTable           **hash_table,
                      PLGIHashTableArgInfo  *hash_table_arg_info)
{
  switch ( hash_table_arg_info->key_info->type_tag )
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
    { *hash_table = g_hash_table_new(NULL, NULL);
      break;
    }

    case GI_TYPE_TAG_UTF8:
    case GI_TYPE_TAG_FILENAME:
    { *hash_table = g_hash_table_new(g_str_hash, g_str_equal);
      break;
    }

    case GI_TYPE_TAG_ARRAY:
    case GI_TYPE_TAG_INTERFACE:
    case GI_TYPE_TAG_GLIST:
    case GI_TYPE_TAG_GSLIST:
    case GI_TYPE_TAG_GHASH:
    case GI_TYPE_TAG_ERROR:
    case GI_TYPE_TAG_UNICHAR:
    { *hash_table = g_hash_table_new(NULL, NULL);
      break;
    }

    default:
    { g_assert_not_reached();
    }
  }

  return TRUE;
}


void
plgi_dealloc_ghashtable(GHashTable           *hash_table,
                        PLGIHashTableArgInfo *hashtable_arg_info)
{
  g_hash_table_unref(hash_table);
}
