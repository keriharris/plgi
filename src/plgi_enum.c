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
                 *           Enum Arg           *
                 *******************************/

gboolean
plgi_term_to_enum(term_t           t,
                  PLGIEnumArgInfo *enum_arg_info,
                  gint64          *enum_)
{
  PLGIEnumInfo *enum_info = enum_arg_info->enum_info;
  atom_t name;
  gint i;

  PLGI_debug("    term: 0x%lx  --->  enum: (%s) %p",
             t, PL_atom_chars(enum_info->name), enum_);

  if ( !PL_get_atom(t, &name) )
  { return PL_type_error(PL_atom_chars(enum_info->name), t);
  }

  for ( i = 0; i < enum_info->n_values; i++ )
  {
    PLGIValueInfo *value_info;
    value_info = enum_info->values_info + i;

    if ( value_info->name == name )
    { *enum_ = value_info->value;
      return TRUE;
    }
  }

  return PL_domain_error(PL_atom_chars(enum_info->name), t);
}


gboolean
plgi_enum_to_term(gint64           enum_,
                  PLGIEnumArgInfo *enum_arg_info,
                  term_t           t)
{
  PLGIEnumInfo *enum_info = enum_arg_info->enum_info;
  GITypeTag type_tag = g_enum_info_get_storage_type(enum_info->info);
  gint64 masked_enum;
  gint i;

  PLGI_debug("    enum: (%s) 0x%lx  --->  term: 0x%lx",
             PL_atom_chars(enum_info->name), enum_, t);

  switch ( type_tag )
  {
    case GI_TYPE_TAG_BOOLEAN:
    { masked_enum = (gboolean)enum_;
      break;
    }
    case GI_TYPE_TAG_INT8:
    { masked_enum = (gint8)enum_;
      break;
    }
    case GI_TYPE_TAG_UINT8:
    { masked_enum = (guint8)enum_;
      break;
    }
    case GI_TYPE_TAG_INT16:
    { masked_enum = (gint16)enum_;
      break;
    }
    case GI_TYPE_TAG_UINT16:
    { masked_enum = (guint16)enum_;
      break;
    }
    case GI_TYPE_TAG_INT32:
    { masked_enum = (gint32)enum_;
      break;
    }
    case GI_TYPE_TAG_UINT32:
    { masked_enum = (guint32)enum_;
      break;
    }
    case GI_TYPE_TAG_INT64:
    { masked_enum = (gint64)enum_;
      break;
    }
    case GI_TYPE_TAG_UINT64:
    { masked_enum = (guint64)enum_;
      break;
    }
    default:
    { g_assert_not_reached();
    }
  }

  for ( i = 0; i < enum_info->n_values; i++ )
  {
    PLGIValueInfo *value_info;
    value_info = enum_info->values_info + i;

    if ( value_info->value == masked_enum )
    { PL_put_atom(t, value_info->name);
      return TRUE;
    }
  }

  return FALSE;
}


gsize
plgi_enum_size(PLGIEnumArgInfo *enum_arg_info)
{
  PLGIEnumInfo *enum_info = enum_arg_info->enum_info;
  GITypeTag type_tag = g_enum_info_get_storage_type(enum_info->info);

  switch ( type_tag )
  {
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

    default:
    { g_assert_not_reached();
    }
  }
}



                 /*******************************
                 *      Foreign Predicates      *
                 *******************************/

PLGI_PRED_IMPL(plgi_enum_value)
{
  term_t enum_ = FA0;
  term_t value = FA1;

  atom_t name;
  gint64 i;
  term_t value0 = PL_new_term_ref();

  if ( !PL_get_atom(enum_, &name) )
  { return PL_type_error("enum", enum_);
  }

  PLGI_debug("  enum name: %s", PL_atom_chars(name));

  if ( !plgi_get_enum_value(name, &i) )
  { return PL_domain_error("enum", enum_);
  }

  if ( !plgi_gint64_to_term(i, value0) )
  { return FALSE;
  }

  return PL_unify(value, value0);
}
