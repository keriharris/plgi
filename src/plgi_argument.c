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



                /*******************************
                 *    GIArgument allocation    *
                 *******************************/

gboolean
plgi_alloc_arg(GIArgument *arg, PLGIArgInfo *arg_info)
{
  GIArgument *arg0 = (GIArgument*)arg;

  PLGI_debug("    alloc %s: %p",
             g_type_tag_to_string(arg_info->type_tag), arg);

  switch ( arg_info->type_tag )
  {
    case GI_TYPE_TAG_VOID:
    { g_assert_not_reached();
    }

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
    { return TRUE;
    }

    case GI_TYPE_TAG_UTF8:
    case GI_TYPE_TAG_FILENAME:
    { g_assert_not_reached();
    }

    case GI_TYPE_TAG_ARRAY:
    { return plgi_alloc_array(arg, (PLGIArrayArgInfo*)arg_info);
    }

    case GI_TYPE_TAG_INTERFACE:
    { PLGIAbstractArgInfo* abstract_arg_info;
      abstract_arg_info = (PLGIAbstractArgInfo*)arg_info;

      switch ( abstract_arg_info->abstract_arg_type )
      {
        case PLGI_ABSTRACT_ARG_INTERFACE:
        case PLGI_ABSTRACT_ARG_OBJECT:
        { return TRUE;
        }

        case PLGI_ABSTRACT_ARG_STRUCT:
        { return plgi_alloc_struct(&arg->v_pointer,
                                   (PLGIStructArgInfo*)abstract_arg_info);
        }

        case PLGI_ABSTRACT_ARG_UNION:
        { return plgi_alloc_union(&arg->v_pointer,
                                  (PLGIUnionArgInfo*)abstract_arg_info);
        }

        case PLGI_ABSTRACT_ARG_GSTRV:
        case PLGI_ABSTRACT_ARG_GBYTES:
        case PLGI_ABSTRACT_ARG_ENUM:
        case PLGI_ABSTRACT_ARG_FLAG:
        case PLGI_ABSTRACT_ARG_CALLBACK:
        { return TRUE;
        }

        default:
        { g_assert_not_reached();
        }
      }
    }

    case GI_TYPE_TAG_GLIST:
    { return plgi_alloc_glist((GList**)&arg0->v_pointer,
                              (PLGIListArgInfo*)arg_info);
    }

    case GI_TYPE_TAG_GSLIST:
    { return plgi_alloc_gslist((GSList**)&arg0->v_pointer,
                               (PLGIListArgInfo*)arg_info);
    }

    case GI_TYPE_TAG_GHASH:
    { return plgi_alloc_ghashtable((GHashTable**)&arg0->v_pointer,
                                   (PLGIHashTableArgInfo*)arg_info);
    }

    case GI_TYPE_TAG_ERROR:
    { g_assert_not_reached();
    }

    case GI_TYPE_TAG_UNICHAR:
    { return TRUE;
    }

    default:
    { g_assert_not_reached();
    }
  }
}


void
plgi_dealloc_arg(GIArgument *arg, PLGIArgInfo *arg_info)
{
  if ( !( arg_info->flags & PLGI_ARG_IS_POINTER ) )
  { return;
  }

  if ( !arg->v_pointer )
  { return;
  }

  PLGI_debug("    dealloc container: (%s) %p [%p]",
             g_type_tag_to_string(arg_info->type_tag), arg, arg->v_pointer);

  switch ( arg_info->type_tag )
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
    { break;
    }

    case GI_TYPE_TAG_UTF8:
    case GI_TYPE_TAG_FILENAME:
    { g_free(arg->v_string);
      break;
    }

    case GI_TYPE_TAG_ARRAY:
    { plgi_dealloc_array_container(arg, (PLGIArrayArgInfo*)arg_info);
      break;
    }

    case GI_TYPE_TAG_INTERFACE:
    { PLGIAbstractArgInfo* abstract_arg_info;
      abstract_arg_info = (PLGIAbstractArgInfo*)arg_info;

      switch ( abstract_arg_info->abstract_arg_type )
      {
        case PLGI_ABSTRACT_ARG_INTERFACE:
        case PLGI_ABSTRACT_ARG_OBJECT:
        case PLGI_ABSTRACT_ARG_STRUCT:
        case PLGI_ABSTRACT_ARG_UNION:
        { break;
        }

        case PLGI_ABSTRACT_ARG_GSTRV:
        { plgi_dealloc_gstrv(arg->v_pointer);
          break;
        }

        case PLGI_ABSTRACT_ARG_GBYTES:
        { plgi_dealloc_gbytes_container(arg->v_pointer);
          break;
        }

        case PLGI_ABSTRACT_ARG_ENUM:
        case PLGI_ABSTRACT_ARG_FLAG:
        case PLGI_ABSTRACT_ARG_CALLBACK:
        { break;
        }

        default:
        { g_assert_not_reached();
        }
      }
      break;
    }

    case GI_TYPE_TAG_GLIST:
    { plgi_dealloc_glist_container(arg->v_pointer,
                                   (PLGIListArgInfo*)arg_info);
      break;
    }

    case GI_TYPE_TAG_GSLIST:
    { plgi_dealloc_gslist_container(arg->v_pointer,
                                    (PLGIListArgInfo*)arg_info);
      break;
    }

    case GI_TYPE_TAG_GHASH:
    { plgi_dealloc_ghashtable(arg->v_pointer,
                              (PLGIHashTableArgInfo*)arg_info);
      break;
    }

    case GI_TYPE_TAG_ERROR:
    { g_error_free(arg->v_pointer);
      break;
    }

    case GI_TYPE_TAG_UNICHAR:
    { break;
    }

    default:
    { g_assert_not_reached();
    }
  }
}


void
plgi_dealloc_arg_full(GIArgument *arg, PLGIArgInfo *arg_info)
{
  if ( !( arg_info->flags & PLGI_ARG_IS_POINTER ) )
  { return;
  }

  if ( !( arg && arg->v_pointer ) )
  { return;
  }

  PLGI_debug("    dealloc arg: (%s) %p [%p]",
             g_type_tag_to_string(arg_info->type_tag), arg, arg->v_pointer);

  switch ( arg_info->type_tag )
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
    { break;
    }

    case GI_TYPE_TAG_UTF8:
    case GI_TYPE_TAG_FILENAME:
    { g_free(arg->v_string);
      break;
    }

    case GI_TYPE_TAG_ARRAY:
    { plgi_dealloc_array_full(arg, (PLGIArrayArgInfo*)arg_info);
      break;
    }

    case GI_TYPE_TAG_INTERFACE:
    { PLGIAbstractArgInfo* abstract_arg_info;
      abstract_arg_info = (PLGIAbstractArgInfo*)arg_info;

      switch ( abstract_arg_info->abstract_arg_type )
      {
        case PLGI_ABSTRACT_ARG_INTERFACE:
        case PLGI_ABSTRACT_ARG_OBJECT:
        case PLGI_ABSTRACT_ARG_STRUCT:
        case PLGI_ABSTRACT_ARG_UNION:
        { break;
        }

        case PLGI_ABSTRACT_ARG_GSTRV:
        { plgi_dealloc_gstrv(arg->v_pointer);
          break;
        }

        case PLGI_ABSTRACT_ARG_GBYTES:
        { plgi_dealloc_gbytes_full(arg->v_pointer);
          break;
        }

        case PLGI_ABSTRACT_ARG_ENUM:
        case PLGI_ABSTRACT_ARG_FLAG:
        case PLGI_ABSTRACT_ARG_CALLBACK:
        { break;
        }

        default:
        { g_assert_not_reached();
        }
      }
      break;
    }

    case GI_TYPE_TAG_GLIST:
    { plgi_dealloc_glist_full((GList*)arg->v_pointer,
                              (PLGIListArgInfo*)arg_info);
      break;
    }

    case GI_TYPE_TAG_GSLIST:
    { plgi_dealloc_gslist_full((GSList*)arg->v_pointer,
                               (PLGIListArgInfo*)arg_info);
      break;
    }

    case GI_TYPE_TAG_GHASH:
    { plgi_dealloc_ghashtable((GHashTable*)arg->v_pointer,
                              (PLGIHashTableArgInfo*)arg_info);
      break;
    }

    case GI_TYPE_TAG_ERROR:
    { g_error_free(arg->v_pointer);
      break;
    }

    case GI_TYPE_TAG_UNICHAR:
    { break;
    }

    default:
    { g_assert_not_reached();
    }
  }
}



                /*******************************
                 *    term Args <-> GI Args    *
                 *******************************/

gboolean
plgi_term_to_arg(term_t       t,
                 PLGIArgInfo  *arg_info,
                 PLGIArgCache *arg_cache,
                 GIArgument   *arg)
{
  PLGI_debug("    term: 0x%lx  --->  arg: %p (%s)   [xfer: %d, flags: 0x%x]",
             t, arg, g_type_tag_to_string(arg_info->type_tag),
             arg_info->transfer, arg_info->flags);

  if ( arg_info->flags & PLGI_ARG_MAY_BE_NULL &&
       plgi_get_null(t, &arg->v_pointer) )
  { return TRUE;
  }

  switch ( arg_info->type_tag )
  {
    case GI_TYPE_TAG_VOID:
    { if ( arg_info->flags & PLGI_ARG_IS_CLOSURE )
      { if ( !plgi_term_to_closure_data(t, &arg->v_pointer) )
        { return FALSE;
        }
      }
      else
      { if ( !plgi_term_to_gpointer(t, arg_info, &arg->v_pointer) )
        { return FALSE;
        }
      }
      break;
    }

    case GI_TYPE_TAG_BOOLEAN:
    { if ( !plgi_term_to_gboolean(t, &arg->v_boolean) )
      { return FALSE;
      }
      break;
    }

    case GI_TYPE_TAG_INT8:
    { if ( !plgi_term_to_gint8(t, &arg->v_int8) )
      { return FALSE;
      }
      break;
    }

    case GI_TYPE_TAG_UINT8:
    { if ( !plgi_term_to_guint8(t, &arg->v_uint8) )
      { return FALSE;
      }
      break;
    }

    case GI_TYPE_TAG_INT16:
    { if ( !plgi_term_to_gint16(t, &arg->v_int16) )
      { return FALSE;
      }
      break;
    }

    case GI_TYPE_TAG_UINT16:
    { if ( !plgi_term_to_guint16(t, &arg->v_uint16) )
      { return FALSE;
      }
      break;
    }

    case GI_TYPE_TAG_INT32:
    { if ( !plgi_term_to_gint32(t, &arg->v_int32) )
      { return FALSE;
      }
      break;
    }

    case GI_TYPE_TAG_UINT32:
    { if ( !plgi_term_to_guint32(t, &arg->v_uint32) )
      { return FALSE;
      }
      break;
    }

    case GI_TYPE_TAG_INT64:
    { if ( !plgi_term_to_gint64(t, &arg->v_int64) )
      { return FALSE;
      }
      break;
    }

    case GI_TYPE_TAG_UINT64:
    { if ( !plgi_term_to_guint64(t, &arg->v_uint64) )
      { return FALSE;
      }
      break;
    }

    case GI_TYPE_TAG_FLOAT:
    { if ( !plgi_term_to_gfloat(t, &arg->v_float) )
      { return FALSE;
      }
      break;
    }

    case GI_TYPE_TAG_DOUBLE:
    { if ( !plgi_term_to_gdouble(t, &arg->v_double) )
      { return FALSE;
      }
      break;
    }

    case GI_TYPE_TAG_GTYPE:
    { if ( !plgi_term_to_gtype(t, &arg->v_size) )
      { return FALSE;
      }
      break;
    }

    case GI_TYPE_TAG_UTF8:
    { if ( !plgi_term_to_utf8(t, &arg->v_string) )
      { return FALSE;
      }
      break;
    }

    case GI_TYPE_TAG_FILENAME:
    { if ( !plgi_term_to_filename(t, &arg->v_string) )
      { return FALSE;
      }
      break;
    }

    case GI_TYPE_TAG_ARRAY:
    { if ( !plgi_term_to_array(t,
                               (PLGIArrayArgInfo*)arg_info,
                               arg_cache,
                               arg) )
      { return FALSE;
      }
      break;
    }

    case GI_TYPE_TAG_INTERFACE:
    { PLGIAbstractArgInfo* abstract_arg_info;
      abstract_arg_info = (PLGIAbstractArgInfo*)arg_info;

      switch ( abstract_arg_info->abstract_arg_type )
      {
        case PLGI_ABSTRACT_ARG_INTERFACE:
        { return plgi_term_to_interface(t,
                                        (PLGIInterfaceArgInfo*)abstract_arg_info,
                                        &arg->v_pointer);
        }

        case PLGI_ABSTRACT_ARG_OBJECT:
        { return plgi_term_to_object(t,
                                     (PLGIObjectArgInfo*)abstract_arg_info,
                                     &arg->v_pointer);
        }

        case PLGI_ABSTRACT_ARG_STRUCT:
        { gpointer *struct_;
          if ( arg_info->flags & PLGI_ARG_IS_POINTER )
          { struct_ = &arg->v_pointer;
          }
          else
          { struct_ = (gpointer*)&arg;
          }
          return plgi_term_to_struct(t,
                                     (PLGIStructArgInfo*)abstract_arg_info,
                                     struct_);
        }

        case PLGI_ABSTRACT_ARG_UNION:
        { gpointer *union_;
          if ( arg_info->flags & PLGI_ARG_IS_POINTER )
          { union_ = &arg->v_pointer;
          }
          else
          { union_ = (gpointer*)&arg;
          }
          return plgi_term_to_union(t,
                                    (PLGIUnionArgInfo*)abstract_arg_info,
                                    union_);
        }

        case PLGI_ABSTRACT_ARG_GSTRV:
        { return plgi_term_to_gstrv(t, (GStrv*)&arg->v_pointer);
        }

        case PLGI_ABSTRACT_ARG_GBYTES:
        { return plgi_term_to_gbytes(t, (GBytes**)&arg->v_pointer);
        }

        case PLGI_ABSTRACT_ARG_ENUM:
        { return plgi_term_to_enum(t,
                                   (PLGIEnumArgInfo*)abstract_arg_info,
                                   &arg->v_int64);
        }

        case PLGI_ABSTRACT_ARG_FLAG:
        { return plgi_term_to_flag(t,
                                   (PLGIEnumArgInfo*)abstract_arg_info,
                                   &arg->v_int64);
        }

        case PLGI_ABSTRACT_ARG_CALLBACK:
        { return plgi_term_to_callback(t,
                                       (PLGICallbackArgInfo*)abstract_arg_info,
                                       arg);
        }

        default:
        { g_assert_not_reached();
        }
      }
      break;
    }

    case GI_TYPE_TAG_GLIST:
    { if ( !plgi_term_to_glist(t,
                               (PLGIListArgInfo*)arg_info,
                               arg_cache,
                               (GList**)&arg->v_pointer) )
      { return FALSE;
      }
      break;
    }

    case GI_TYPE_TAG_GSLIST:
    { if ( !plgi_term_to_gslist(t,
                                (PLGIListArgInfo*)arg_info,
                                arg_cache,
                                (GSList**)&arg->v_pointer) )
      { return FALSE;
      }
      break;
    }

    case GI_TYPE_TAG_GHASH:
    { if ( !plgi_term_to_ghashtable(t,
                                    (PLGIHashTableArgInfo*)arg_info,
                                    arg_cache,
                                    (GHashTable**)&arg->v_pointer) )
      { return FALSE;
      }
      break;
    }

    case GI_TYPE_TAG_ERROR:
    { /* GError types cannot be constructed from terms */
      g_assert_not_reached();
    }

    case GI_TYPE_TAG_UNICHAR:
    { if ( !plgi_term_to_gunichar(t, &arg->v_uint32) )
      { return FALSE;
      }
      break;
    }

    default:
    { g_assert_not_reached();
    }
  }

  if ( arg_cache && arg_info->flags & PLGI_ARG_IS_POINTER )
  { plgi_cache_arg(arg, arg_info, arg_cache);
  }

  return TRUE;
}


gboolean
plgi_arg_to_term(GIArgument  *arg,
                 PLGIArgInfo *arg_info,
                 term_t      t)
{
  PLGI_debug("    arg: %p (%s)  --->  term: 0x%lx   [xfer: %d, flags: 0x%x]",
             arg, g_type_tag_to_string(arg_info->type_tag), t,
             arg_info->transfer, arg_info->flags);

  switch ( arg_info->type_tag )
  {
    case GI_TYPE_TAG_VOID:
    { if ( arg_info->flags & PLGI_ARG_IS_CLOSURE )
      { return plgi_closure_data_to_term(arg->v_pointer, t);
      }
      else
      { return plgi_gpointer_to_term(arg->v_pointer, arg_info, t);
      }
    }

    case GI_TYPE_TAG_BOOLEAN:
    { return plgi_gboolean_to_term(arg->v_boolean, t);
    }

    case GI_TYPE_TAG_INT8:
    { return plgi_gint8_to_term(arg->v_int8, t);
    }

    case GI_TYPE_TAG_UINT8:
    { return plgi_guint8_to_term(arg->v_uint8, t);
    }

    case GI_TYPE_TAG_INT16:
    { return plgi_gint16_to_term(arg->v_int16, t);
    }

    case GI_TYPE_TAG_UINT16:
    { return plgi_guint16_to_term(arg->v_uint16, t);
    }

    case GI_TYPE_TAG_INT32:
    { return plgi_gint32_to_term(arg->v_int32, t);
    }

    case GI_TYPE_TAG_UINT32:
    { return plgi_guint32_to_term(arg->v_uint32, t);
    }

    case GI_TYPE_TAG_INT64:
    { return plgi_gint64_to_term(arg->v_int64, t);
    }

    case GI_TYPE_TAG_UINT64:
    { return plgi_guint64_to_term(arg->v_uint64, t);
    }

    case GI_TYPE_TAG_FLOAT:
    { return plgi_gfloat_to_term(arg->v_float, t);
    }

    case GI_TYPE_TAG_DOUBLE:
    { return plgi_gdouble_to_term(arg->v_double, t);
    }

    case GI_TYPE_TAG_GTYPE:
    { return plgi_gtype_to_term(arg->v_size, t);
    }

    case GI_TYPE_TAG_UTF8:
    { return plgi_utf8_to_term(arg->v_string, t);
    }

    case GI_TYPE_TAG_FILENAME:
    { return plgi_filename_to_term(arg->v_string, t);
    }

    case GI_TYPE_TAG_ARRAY:
    { return plgi_array_to_term(arg,
                                (PLGIArrayArgInfo*)arg_info,
                                t);
    }

    case GI_TYPE_TAG_INTERFACE:
    { PLGIAbstractArgInfo* abstract_arg_info;
      abstract_arg_info = (PLGIAbstractArgInfo*)arg_info;

      switch ( abstract_arg_info->abstract_arg_type )
      {
        case PLGI_ABSTRACT_ARG_INTERFACE:
        { return plgi_interface_to_term(arg->v_pointer,
                                        (PLGIInterfaceArgInfo*)abstract_arg_info,
                                        t);
        }

        case PLGI_ABSTRACT_ARG_OBJECT:
        { return plgi_object_to_term(arg->v_pointer,
                                     (PLGIObjectArgInfo*)abstract_arg_info,
                                     t);
        }

        case PLGI_ABSTRACT_ARG_STRUCT:
        { gpointer struct_;
          if ( arg_info->direction == GI_DIRECTION_IN ||
               arg_info->flags & PLGI_ARG_IS_POINTER ||
               arg_info->flags & PLGI_ARG_IS_CALLER_ALLOCATES )
          { struct_ = arg->v_pointer;
          }
          else
          { struct_ = &arg->v_pointer;
          }
          return plgi_struct_to_term(struct_,
                                     (PLGIStructArgInfo*)abstract_arg_info,
                                     t);
        }

        case PLGI_ABSTRACT_ARG_UNION:
        { gpointer union_;
          if ( arg_info->direction == GI_DIRECTION_IN ||
               arg_info->flags & PLGI_ARG_IS_POINTER ||
               arg_info->flags & PLGI_ARG_IS_CALLER_ALLOCATES )
          { union_ = arg->v_pointer;
          }
          else
          { union_ = &arg->v_pointer;
          }
          return plgi_union_to_term(union_,
                                    (PLGIUnionArgInfo*)abstract_arg_info,
                                    t);
        }

        case PLGI_ABSTRACT_ARG_GSTRV:
        { return plgi_gstrv_to_term(arg->v_pointer, t);
        }

        case PLGI_ABSTRACT_ARG_GBYTES:
        { return plgi_gbytes_to_term(arg->v_pointer, t);
        }

        case PLGI_ABSTRACT_ARG_ENUM:
        { return plgi_enum_to_term(arg->v_int64,
                                   (PLGIEnumArgInfo*)abstract_arg_info,
                                   t);
        }

        case PLGI_ABSTRACT_ARG_FLAG:
        { return plgi_flag_to_term(arg->v_int64,
                                   (PLGIEnumArgInfo*)abstract_arg_info,
                                   t);
        }

        case PLGI_ABSTRACT_ARG_CALLBACK:
        { plgi_raise_error("cannot convert GCallback to Prolog term");
          return FALSE;
        }

        default:
        { g_assert_not_reached();
        }
      }
    }

    case GI_TYPE_TAG_GLIST:
    { return plgi_glist_to_term(arg->v_pointer,
                                (PLGIListArgInfo*)arg_info,
                                t);
    }

    case GI_TYPE_TAG_GSLIST:
    { return plgi_gslist_to_term(arg->v_pointer,
                                 (PLGIListArgInfo*)arg_info,
                                 t);
    }

    case GI_TYPE_TAG_GHASH:
    { return plgi_ghashtable_to_term(arg->v_pointer,
                                     (PLGIHashTableArgInfo*)arg_info,
                                     t);
    }

    case GI_TYPE_TAG_ERROR:
    { return plgi_gerror_to_term(arg->v_pointer, t);
    }

    case GI_TYPE_TAG_UNICHAR:
    { return plgi_gunichar_to_term(arg->v_uint32, t);
    }

    default:
    { g_assert_not_reached();
    }
  }
}


                /*******************************
                 *    FFI Args <-> GI Args     *
                 *******************************/

void
plgi_ffi_arg_to_gi_arg(gpointer    ffiarg,
                       PLGIArgInfo *arg_info,
                       GIArgument  *gi_arg)
{
  PLGI_debug("    FFI arg %p  --->  GIArgument: %p (%s)",
             ffiarg, gi_arg, g_type_tag_to_string(arg_info->type_tag));

  switch ( arg_info->type_tag )
  {
    case GI_TYPE_TAG_VOID:
    { gi_arg->v_pointer = *(gpointer*)ffiarg;
      break;
    }

    case GI_TYPE_TAG_BOOLEAN:
    { gi_arg->v_boolean = *(gboolean*)ffiarg;
      break;
    }

    case GI_TYPE_TAG_INT8:
    { gi_arg->v_int8 = *(gint8*)ffiarg;
      break;
    }

    case GI_TYPE_TAG_UINT8:
    { gi_arg->v_uint8 = *(guint8*)ffiarg;
      break;
    }

    case GI_TYPE_TAG_INT16:
    { gi_arg->v_int16 = *(gint16*)ffiarg;
      break;
    }

    case GI_TYPE_TAG_UINT16:
    { gi_arg->v_uint16 = *(guint16*)ffiarg;
      break;
    }

    case GI_TYPE_TAG_INT32:
    { gi_arg->v_int32 = *(gint32*)ffiarg;
      break;
    }

    case GI_TYPE_TAG_UINT32:
    { gi_arg->v_uint32 = *(guint32*)ffiarg;
      break;
    }

    case GI_TYPE_TAG_INT64:
    { gi_arg->v_int64 = *(gint64*)ffiarg;
      break;
    }

    case GI_TYPE_TAG_UINT64:
    { gi_arg->v_uint64 = *(guint64*)ffiarg;
      break;
    }

    case GI_TYPE_TAG_FLOAT:
    { gi_arg->v_float = *(gfloat*)ffiarg;
      break;
    }

    case GI_TYPE_TAG_DOUBLE:
    { gi_arg->v_double = *(gdouble*)ffiarg;
      break;
    }

    case GI_TYPE_TAG_GTYPE:
    { gi_arg->v_size = *(GType*)ffiarg;
      break;
    }

    case GI_TYPE_TAG_UTF8:
    case GI_TYPE_TAG_FILENAME:
    { gi_arg->v_string = *(gchar**)ffiarg;
      break;
    }

    case GI_TYPE_TAG_ARRAY:
    { gi_arg->v_pointer = *(gpointer*)ffiarg;
      break;
    }

    case GI_TYPE_TAG_INTERFACE:
    { PLGIAbstractArgInfo *abstract_arg_info;
      abstract_arg_info = (PLGIAbstractArgInfo*)arg_info;

      switch ( abstract_arg_info->abstract_arg_type )
      {
        case PLGI_ABSTRACT_ARG_INTERFACE:
        case PLGI_ABSTRACT_ARG_OBJECT:
        case PLGI_ABSTRACT_ARG_STRUCT:
        case PLGI_ABSTRACT_ARG_UNION:
        case PLGI_ABSTRACT_ARG_GBYTES:
        { gi_arg->v_pointer = *(gpointer*)ffiarg;
          break;
        }

        case PLGI_ABSTRACT_ARG_ENUM:
        case PLGI_ABSTRACT_ARG_FLAG:
        { gi_arg->v_int64 = *(gint64*)ffiarg;
          break;
        }

        case PLGI_ABSTRACT_ARG_CALLBACK:
        { gi_arg->v_pointer = *(gpointer*)ffiarg;
          break;
        }

        default:
       { g_assert_not_reached();
       }
      }
      break;
    }

    case GI_TYPE_TAG_GLIST:
    case GI_TYPE_TAG_GSLIST:
    case GI_TYPE_TAG_GHASH:
    case GI_TYPE_TAG_ERROR:
    { gi_arg->v_pointer = *(gpointer*)ffiarg;
      break;
    }

    case GI_TYPE_TAG_UNICHAR:
    { gi_arg->v_uint32 = *(guint32*)ffiarg;
      break;
    }

    default:
    { g_assert_not_reached();
    }
  }
}


void
plgi_gi_arg_to_ffi_arg(GIArgument  *gi_arg,
                       PLGIArgInfo *arg_info,
                       gpointer    ffiarg)
{
  PLGI_debug("    GIArgument %p (%s)  --->  FFI arg: %p",
             gi_arg, g_type_tag_to_string(arg_info->type_tag), ffiarg);

  switch ( arg_info->type_tag )
  {
    case GI_TYPE_TAG_VOID:
    { *(intptr_t*)*(ffi_arg*)ffiarg = (ffi_arg)gi_arg->v_pointer;
      break;
    }

    case GI_TYPE_TAG_BOOLEAN:
    { *(gboolean*)*(ffi_sarg*)ffiarg = gi_arg->v_boolean;
      break;
    }

    case GI_TYPE_TAG_INT8:
    { *(gint8*)*(ffi_sarg*)ffiarg = gi_arg->v_int8;
      break;
    }

    case GI_TYPE_TAG_UINT8:
    { *(guint8*)*(ffi_arg*)ffiarg = gi_arg->v_uint8;
      break;
    }

    case GI_TYPE_TAG_INT16:
    { *(gint16*)*(ffi_sarg*)ffiarg = gi_arg->v_int16;
      break;
    }

    case GI_TYPE_TAG_UINT16:
    { *(guint16*)*(ffi_arg*)ffiarg = gi_arg->v_uint16;
      break;
    }

    case GI_TYPE_TAG_INT32:
    { *(gint32*)*(ffi_sarg*)ffiarg = gi_arg->v_int32;
      break;
    }

    case GI_TYPE_TAG_UINT32:
    { *(guint32*)*(ffi_arg*)ffiarg = gi_arg->v_uint32;
      break;
    }

    case GI_TYPE_TAG_INT64:
    { *(gint64*)*(ffi_sarg*)ffiarg = gi_arg->v_int64;
      break;
    }

    case GI_TYPE_TAG_UINT64:
    { *(guint64*)*(ffi_arg*)ffiarg = gi_arg->v_uint64;
      break;
    }

    case GI_TYPE_TAG_FLOAT:
    { *(gfloat*)*(ffi_arg*)ffiarg = gi_arg->v_float;
      break;
    }

    case GI_TYPE_TAG_DOUBLE:
    { *(gdouble*)*(ffi_arg*)ffiarg = gi_arg->v_double;
      break;
    }

    case GI_TYPE_TAG_GTYPE:
    { *(gsize*)*(ffi_sarg*)ffiarg = gi_arg->v_size;
      break;
    }

    case GI_TYPE_TAG_UTF8:
    case GI_TYPE_TAG_FILENAME:
    { *(gchar**)*(ffi_arg*)ffiarg = gi_arg->v_string;
      break;
    }

    case GI_TYPE_TAG_ARRAY:
    { *(intptr_t*)*(ffi_arg*)ffiarg = (ffi_arg)gi_arg->v_pointer;
      break;
    }

    case GI_TYPE_TAG_INTERFACE:
    { PLGIAbstractArgInfo *abstract_arg_info;
      abstract_arg_info = (PLGIAbstractArgInfo*)arg_info;

      switch ( abstract_arg_info->abstract_arg_type )
      {
        case PLGI_ABSTRACT_ARG_INTERFACE:
        case PLGI_ABSTRACT_ARG_OBJECT:
        case PLGI_ABSTRACT_ARG_STRUCT:
        case PLGI_ABSTRACT_ARG_UNION:
        case PLGI_ABSTRACT_ARG_GBYTES:
        { *(intptr_t*)*(ffi_arg*)ffiarg = (ffi_arg)gi_arg->v_pointer;
          break;
        }

        case PLGI_ABSTRACT_ARG_ENUM:
        case PLGI_ABSTRACT_ARG_FLAG:
        { *(gint64*)*(ffi_sarg*)ffiarg = gi_arg->v_int64;
          break;
        }

        case PLGI_ABSTRACT_ARG_CALLBACK:
        { *(intptr_t*)*(ffi_arg*)ffiarg = (ffi_arg)gi_arg->v_pointer;
          break;
        }

        default:
        { g_assert_not_reached();
        }
      }
      break;
    }

    case GI_TYPE_TAG_GLIST:
    case GI_TYPE_TAG_GSLIST:
    case GI_TYPE_TAG_GHASH:
    case GI_TYPE_TAG_ERROR:
    { *(intptr_t*)*(ffi_arg*)ffiarg = (ffi_arg)gi_arg->v_pointer;
      break;
    }

    case GI_TYPE_TAG_UNICHAR:
    { *(guint32*)*(ffi_arg*)ffiarg = gi_arg->v_uint32;
      break;
    }

    default:
    { g_assert_not_reached();
    }
  }
}


                /*******************************
                 *   GValue Args <-> GI Args   *
                 *******************************/

void
plgi_gvalue_to_arg(GValue      *gvalue,
                   PLGIArgInfo *arg_info,
                   GIArgument  *arg)
{
  PLGI_debug("    GValue %p (%s)  --->  GIArgument: %p (%s)",
             gvalue, G_VALUE_TYPE_NAME(gvalue),
             arg, g_type_tag_to_string(arg_info->type_tag));

  if ( G_VALUE_HOLDS_BOOLEAN(gvalue) )
  { arg->v_boolean = g_value_get_boolean(gvalue);
  }

  else if ( G_VALUE_HOLDS_CHAR(gvalue) )
  { arg->v_int8 = g_value_get_schar(gvalue);
  }

  else if ( G_VALUE_HOLDS_UCHAR(gvalue) )
  { arg->v_uint8 = g_value_get_uchar(gvalue);
  }

  else if ( G_VALUE_HOLDS_INT(gvalue) )
  { arg->v_int32 = g_value_get_int(gvalue);
  }

  else if ( G_VALUE_HOLDS_UINT(gvalue) )
  { arg->v_uint32 = g_value_get_uint(gvalue);
  }

  else if ( G_VALUE_HOLDS_LONG(gvalue) )
  {
#if SIZEOF_LONG == 8
    arg->v_int64 = g_value_get_long(gvalue);
#else
    arg->v_int32 = g_value_get_long(gvalue);
#endif
  }

  else if ( G_VALUE_HOLDS_ULONG(gvalue) )
  {
#if SIZEOF_LONG == 8
    arg->v_uint64 = g_value_get_ulong(gvalue);
#else
    arg->v_uint32 = g_value_get_ulong(gvalue);
#endif
  }

  else if ( G_VALUE_HOLDS_INT64(gvalue) )
  { arg->v_int64 = g_value_get_int64(gvalue);
  }

  else if ( G_VALUE_HOLDS_UINT64(gvalue) )
  { arg->v_uint64 = g_value_get_uint64(gvalue);
  }

  else if ( G_VALUE_HOLDS_FLOAT(gvalue) )
  { arg->v_float = g_value_get_float(gvalue);
  }

  else if ( G_VALUE_HOLDS_DOUBLE(gvalue) )
  { arg->v_double = g_value_get_double(gvalue);
  }

  else if ( G_VALUE_HOLDS_ENUM(gvalue) )
  { arg->v_int64 = g_value_get_enum(gvalue);
  }

  else if ( G_VALUE_HOLDS_FLAGS(gvalue) )
  { arg->v_int64 = g_value_get_flags(gvalue);
  }

  else if ( G_VALUE_HOLDS_STRING(gvalue) )
  { arg->v_string = (gchar*)g_value_get_string(gvalue);
  }

  else if ( G_VALUE_HOLDS_PARAM(gvalue) )
  { arg->v_pointer = g_value_get_param(gvalue);
  }

  else if ( G_VALUE_HOLDS_BOXED(gvalue) )
  { arg->v_pointer = g_value_get_boxed(gvalue);
  }

  else if ( G_VALUE_HOLDS_POINTER(gvalue) )
  { arg->v_pointer = g_value_get_pointer(gvalue);
  }

  else if ( G_VALUE_HOLDS_OBJECT(gvalue) )
  { arg->v_pointer = g_value_get_object(gvalue);
  }

  else if ( G_VALUE_HOLDS_GTYPE(gvalue) )
  { arg->v_size = g_value_get_gtype(gvalue);
  }

  else if ( G_VALUE_HOLDS_VARIANT(gvalue) )
  { arg->v_pointer = g_value_get_variant(gvalue);
  }

  else
  { g_assert_not_reached();
  }
}


void
plgi_arg_to_gvalue(GIArgument  *arg,
                   PLGIArgInfo *arg_info,
                   GValue      *gvalue)
{
  PLGI_debug("    GIArgument %p (%s)  --->  GValue: %p (%s)",
             arg, g_type_tag_to_string(arg_info->type_tag),
             gvalue, G_VALUE_TYPE_NAME(gvalue));

  if ( G_VALUE_HOLDS_BOOLEAN(gvalue) )
  { g_value_set_boolean(gvalue, arg->v_boolean);
  }

  else if ( G_VALUE_HOLDS_CHAR(gvalue) )
  { g_value_set_schar(gvalue, arg->v_int8);
  }

  else if ( G_VALUE_HOLDS_UCHAR(gvalue) )
  { g_value_set_uchar(gvalue, arg->v_uint8);
  }

  else if ( G_VALUE_HOLDS_INT(gvalue) )
  { g_value_set_int(gvalue, arg->v_int32);
  }

  else if ( G_VALUE_HOLDS_UINT(gvalue) )
  { g_value_set_uint(gvalue, arg->v_uint32);
  }

  else if ( G_VALUE_HOLDS_LONG(gvalue) )
  {
#if SIZEOF_LONG == 8
    g_value_set_long(gvalue, arg->v_int64);
#else
    g_value_set_long(gvalue, arg->v_int32);
#endif
  }

  else if ( G_VALUE_HOLDS_ULONG(gvalue) )
  {
#if SIZEOF_LONG == 8
    g_value_set_ulong(gvalue, arg->v_uint64);
#else
    g_value_set_ulong(gvalue, arg->v_uint32);
#endif
  }

  else if ( G_VALUE_HOLDS_INT64(gvalue) )
  { g_value_set_int64(gvalue, arg->v_int64);
  }

  else if ( G_VALUE_HOLDS_UINT64(gvalue) )
  { g_value_set_uint64(gvalue, arg->v_uint64);
  }

  else if ( G_VALUE_HOLDS_FLOAT(gvalue) )
  { g_value_set_float(gvalue, arg->v_float);
  }

  else if ( G_VALUE_HOLDS_DOUBLE(gvalue) )
  { g_value_set_double(gvalue, arg->v_double);
  }

  else if ( G_VALUE_HOLDS_ENUM(gvalue) )
  { g_value_set_enum(gvalue, arg->v_int64);
  }

  else if ( G_VALUE_HOLDS_FLAGS(gvalue) )
  { g_value_set_flags(gvalue, arg->v_int64);
  }

  else if ( G_VALUE_HOLDS_STRING(gvalue) )
  { g_value_set_string(gvalue, arg->v_string);
  }

  else if ( G_VALUE_HOLDS_PARAM(gvalue) )
  { g_value_set_param(gvalue, arg->v_pointer);
  }

  else if ( G_VALUE_HOLDS_BOXED(gvalue) )
  { g_value_set_boxed(gvalue, arg->v_pointer);
  }

  else if ( G_VALUE_HOLDS_POINTER(gvalue) )
  { g_value_set_pointer(gvalue, arg->v_pointer);
  }

  else if ( G_VALUE_HOLDS_OBJECT(gvalue) )
  { g_value_set_object(gvalue, arg->v_pointer);
  }

  else if ( G_VALUE_HOLDS_GTYPE(gvalue) )
  { g_value_set_gtype(gvalue, arg->v_size);
  }

  else if ( G_VALUE_HOLDS_VARIANT(gvalue) )
  { g_value_set_variant(gvalue, arg->v_pointer);
  }

  else
  { g_assert_not_reached();
  }
}



                /*******************************
                 *       GIArgument Size       *
                 *******************************/

gsize
plgi_arg_size(PLGIArgInfo *arg_info)
{
  if ( arg_info->flags & PLGI_ARG_IS_POINTER )
  { return sizeof(gpointer);
  }

  switch ( arg_info->type_tag )
  {
    case GI_TYPE_TAG_VOID:
    { g_assert_not_reached();
    }

    case GI_TYPE_TAG_BOOLEAN:
    { return sizeof(gboolean);
    }

    case GI_TYPE_TAG_INT8:
    { return sizeof(gint8);
    }

    case GI_TYPE_TAG_UINT8:
    { return sizeof(guint8);
    }

    case GI_TYPE_TAG_INT16:
    { return sizeof(gint16);
    }

    case GI_TYPE_TAG_UINT16:
    { return sizeof(guint16);
    }

    case GI_TYPE_TAG_INT32:
    { return sizeof(gint32);
    }

    case GI_TYPE_TAG_UINT32:
    { return sizeof(guint32);
    }

    case GI_TYPE_TAG_INT64:
    { return sizeof(gint64);
    }

    case GI_TYPE_TAG_UINT64:
    { return sizeof(guint64);
    }

    case GI_TYPE_TAG_FLOAT:
    { return sizeof(gfloat);
    }

    case GI_TYPE_TAG_DOUBLE:
    { return sizeof(gdouble);
    }

    case GI_TYPE_TAG_GTYPE:
    { return sizeof(GType);
    }

    case GI_TYPE_TAG_UTF8:
    case GI_TYPE_TAG_FILENAME:
    { return sizeof(gchar*);
    }

    case GI_TYPE_TAG_ARRAY:
    { plgi_raise_error("cannot determine size in bytes of array type");
      return FALSE;
    }

    case GI_TYPE_TAG_INTERFACE:
    { PLGIAbstractArgInfo* abstract_arg_info;
      abstract_arg_info = (PLGIAbstractArgInfo*)arg_info;

      switch ( abstract_arg_info->abstract_arg_type )
      {
        case PLGI_ABSTRACT_ARG_OBJECT:
        { plgi_raise_error("cannot determine size in bytes of GObject type");
          return FALSE;
        }

        case PLGI_ABSTRACT_ARG_INTERFACE:
        { plgi_raise_error("cannot determine size in bytes of GInterface type");
          return FALSE;
        }

        case PLGI_ABSTRACT_ARG_STRUCT:
        { return plgi_struct_size((PLGIStructArgInfo*)abstract_arg_info);
        }

        case PLGI_ABSTRACT_ARG_UNION:
        { return plgi_union_size((PLGIUnionArgInfo*)abstract_arg_info);
        }

        case PLGI_ABSTRACT_ARG_GBYTES:
        { plgi_raise_error("cannot determine size in bytes of GBytes type");
          return FALSE;
        }

        case PLGI_ABSTRACT_ARG_ENUM:
        { return plgi_enum_size((PLGIEnumArgInfo*)abstract_arg_info);
        }

        case PLGI_ABSTRACT_ARG_FLAG:
        { return plgi_enum_size((PLGIEnumArgInfo*)abstract_arg_info);
        }

        case PLGI_ABSTRACT_ARG_CALLBACK:
        { plgi_raise_error("cannot determine size in bytes of GCallback type");
          return FALSE;
        }

        default:
        { g_assert_not_reached();
        }
      }
    }

    case GI_TYPE_TAG_GLIST:
    { plgi_raise_error("cannot determine size in bytes of GList type");
      return FALSE;
    }

    case GI_TYPE_TAG_GSLIST:
    { plgi_raise_error("cannot determine size in bytes of GSList type");
      return FALSE;
    }

    case GI_TYPE_TAG_GHASH:
    { plgi_raise_error("cannot determine size in bytes of GHashTable type");
      return FALSE;
    }

    case GI_TYPE_TAG_ERROR:
    { return sizeof(GError);
    }

    case GI_TYPE_TAG_UNICHAR:
    { return sizeof(gunichar);
    }

    default:
    { g_assert_not_reached();
    }
  }
}
