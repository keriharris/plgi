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

#include <SWI-Stream.h>
#include "plgi.h"

#include <string.h>



                /*******************************
                 *     Internal Prototypes     *
                 *******************************/

gboolean
plgi_union_get_blob(term_t     union_,
                    PLGIBlob **blob) PLGI_WARN_UNUSED;

gboolean
plgi_union_get_field_info(term_t          union_,
                          term_t          field_name,
                          PLGIFieldInfo **field_info) PLGI_WARN_UNUSED;



                /*******************************
                 *     Internal Functions      *
                 *******************************/

gboolean
plgi_union_get_blob(term_t     t,
                    PLGIBlob **blob)
{
  PLGIBlob *blob0;

  if ( !plgi_get_blob(t, &blob0) )
  { return PL_type_error("union", t);
  }

  if ( blob0->blob_type != PLGI_BLOB_SIMPLE &&
       blob0->blob_type != PLGI_BLOB_BOXED &&
       blob0->blob_type != PLGI_BLOB_OPAQUE )
  { return PL_type_error("union", t);
  }

  *blob = blob0;

  return TRUE;
}


gboolean
plgi_union_get_field_info(term_t          union_,
                          term_t          field_name,
                          PLGIFieldInfo **field_info)
{
  PLGIBlob *blob;
  PLGIUnionInfo *union_info;
  PLGIFieldInfo *field_info0;
  atom_t name;
  gint i;

  if ( !plgi_union_get_blob(union_, &blob) )
  { return FALSE;
  }

  if ( !plgi_get_union_info(blob->name, &union_info) )
  { plgi_raise_error__va("unregistered union %s", PL_atom_chars(blob->name));
    return FALSE;
  }

  if ( union_info->n_fields == 0 )
  { return PL_type_error("non-opaque union", union_);
  }

  if ( !PL_get_atom_ex(field_name, &name) )
  { return FALSE;
  }

  field_info0 = NULL;
  for ( i = 0; i < union_info->n_fields; i++ )
  { field_info0 = union_info->fields_info + i;
    if ( field_info0->name == name )
    { break;
    }
  }
  if ( field_info0->name != name )
  { return PL_domain_error("union field name", field_name);
  }

  *field_info = field_info0;

  return TRUE;
}



                 /*******************************
                 *          Union Arg           *
                 *******************************/

gboolean
plgi_term_to_union(term_t            t,
                   PLGIUnionArgInfo *union_arg_info,
                   gpointer         *union_)
{
  PLGIBlob *blob;
  PLGIUnionInfo *union_info = union_arg_info->union_info;
  PLGIArgInfo *arg_info = (PLGIArgInfo*)union_arg_info;

  PLGI_debug("    term: 0x%lx  --->  union: (%s) %p",
             t, PL_atom_chars(union_info->name), *union_);

  if ( !plgi_get_blob(t, &blob) )
  { return PL_type_error(PL_atom_chars(union_info->name), t);
  }

  if ( blob->gtype != G_TYPE_NONE &&
       !g_type_is_a( blob->gtype, union_info->gtype ) )
  { return PL_type_error(PL_atom_chars(union_info->name), t);
  }

  if ( arg_info->flags & PLGI_ARG_IS_POINTER )
  { *union_ = blob->data;
  }
  else if ( union_info->size > 0 )
  { memcpy(*union_, blob->data, union_info->size);
  }
  else
  { plgi_raise_error("cannot pass-by-value opaque unions");
    return FALSE;
  }

  if ( arg_info->direction != GI_DIRECTION_OUT &&
       arg_info->transfer != GI_TRANSFER_NOTHING )
  { blob->magic = 0x0;
  }

  return TRUE;
}


gboolean
plgi_union_to_term(gpointer          union_,
                   PLGIUnionArgInfo *union_arg_info,
                   term_t            t)
{
  PLGIUnionInfo *union_info = union_arg_info->union_info;
  PLGIArgInfo *arg_info = (PLGIArgInfo*)union_arg_info;
  PLGIBlobType blob_type;
  gpointer data;

  PLGI_debug("    union: (%s) %p  --->  term: 0x%lx",
             PL_atom_chars(union_info->name), union_, t);

  if ( !union_ )
  { return plgi_put_null(t);
  }

  data = union_;

  if ( g_type_is_a(union_info->gtype, G_TYPE_BOXED ) )
  { blob_type = PLGI_BLOB_BOXED;
    if ( (  arg_info->transfer == GI_TRANSFER_NOTHING &&
           ~arg_info->flags & PLGI_ARG_IS_CALLER_ALLOCATES ) ||
         ( ~arg_info->flags & PLGI_ARG_IS_POINTER ) )
    { data = g_boxed_copy(union_info->gtype, union_);
    }
  }

  else if ( union_info->n_fields > 0 )
  { blob_type = PLGI_BLOB_SIMPLE;
    if ( (  arg_info->transfer == GI_TRANSFER_NOTHING &&
           ~arg_info->flags & PLGI_ARG_IS_CALLER_ALLOCATES ) ||
         ( ~arg_info->flags & PLGI_ARG_IS_POINTER ) )
    { data = g_malloc0(union_info->size);
      memcpy(data, union_, union_info->size);
    }
  }

  else
  { blob_type = PLGI_BLOB_OPAQUE;
  }

  if ( !plgi_put_blob(blob_type, union_info->gtype, union_info->name,
                      data, t, NULL) )
  { return FALSE;
  }

  return TRUE;
}


gboolean
plgi_alloc_union(gpointer         *union_,
                 PLGIUnionArgInfo *union_arg_info)
{
  PLGIUnionInfo *union_info = union_arg_info->union_info;
  gpointer union0;

  if ( union_info->size == 0 )
  { plgi_raise_error("unknown union size, cannot allocate");
    return FALSE;
  }

  union0  = g_malloc0(union_info->size);

  if ( G_TYPE_IS_BOXED(union_info->gtype) )
  { *union_ = g_boxed_copy(union_info->gtype, union0);
    g_free(union0);
  }
  else
  { *union_ = union0;
  }

  return TRUE;
}


gsize
plgi_union_size(PLGIUnionArgInfo *union_arg_info)
{
  PLGIUnionInfo *union_info = union_arg_info->union_info;

  return union_info->size;
}



                 /*******************************
                 *      Foreign Predicates      *
                 *******************************/

PLGI_PRED_IMPL(plgi_union_new)
{
  term_t t      = FA0;
  term_t union_ = FA1;

  PLGIUnionInfo *union_info;
  PLGIFieldInfo *field_info;
  PLGIArgCache *arg_cache = NULL;
  atom_t name;
  gsize arity;
  gint i;
  term_t field = PL_new_term_ref();
  term_t t_name = PL_new_term_ref();
  term_t t_value = PL_new_term_ref();
  term_t union_blob = PL_new_term_ref();
  PLGIBlobType blob_type;
  gpointer union0, field_data, data;
  gboolean ret = TRUE;

  atom_t ATOM_equals = PL_new_atom("=");

  if ( !( PL_get_name_arity(t, &name, &arity) && arity == 1 ) )
  { return PL_type_error("union", t);
  }

  if ( !plgi_get_union_info(name, &union_info) )
  { plgi_raise_error__va("unregistered union %s", PL_atom_chars(name));
    return FALSE;
  }

  if ( union_info->n_fields == 0 )
  { plgi_raise_error("cannot create opaque union");
    return FALSE;
  }

  _PL_get_arg(1, t, field);
  if ( !( PL_get_name_arity(field, &name, &arity) &&
          name == ATOM_equals && arity == 2 ) )
  { return PL_type_error("union field", field);
  }

  _PL_get_arg(1, field, t_name);
  if ( !PL_get_atom_ex(t_name, &name) )
  { return FALSE;
  }

  union0 = g_malloc0(union_info->size);
  arg_cache = g_malloc0(sizeof(*arg_cache));
  arg_cache->id = plgi_cache_id();

  field_info = NULL;
  for ( i = 0; i < union_info->n_fields; i++ )
  { field_info = union_info->fields_info + i;
    if ( field_info->name == name )
    { break;
    }
  }
  if ( field_info->name != name )
  { g_free(union0);
    ret = PL_domain_error("union field name", t_name);
    goto cleanup;
  }

  _PL_get_arg(2, field, t_value);
  field_data = union0 + field_info->offset;
  if ( !plgi_term_to_arg(t_value, field_info->arg_info, arg_cache, field_data) )
  { g_free(union0);
    ret = FALSE;
    goto cleanup;
  }

  if ( g_type_is_a(union_info->gtype, G_TYPE_BOXED ) )
  { blob_type = PLGI_BLOB_BOXED;
    data = g_boxed_copy(union_info->gtype, union0);
    g_free(union0);
  }

  else if ( union_info->n_fields > 0 )
  { blob_type = PLGI_BLOB_SIMPLE;
    data = union0;
  }

  else
  { blob_type = PLGI_BLOB_OPAQUE;
    data = union0;
  }

  if ( !plgi_put_blob(blob_type, union_info->gtype, union_info->name,
                      data, union_blob, NULL) )
  { ret = FALSE;
    goto cleanup;
  }

  PLGI_debug("  union: %p (%s)", data, PL_atom_chars(union_info->name));

  ret = PL_unify(union_, union_blob);

 cleanup:

  if ( arg_cache ) plgi_dealloc_arg_cache(arg_cache, !ret);

  return ret;
}


PLGI_PRED_IMPL(plgi_union_get_field)
{
  term_t union_      = FA0;
  term_t field_name  = FA1;
  term_t field_value = FA2;

  PLGIBlob *blob;
  PLGIFieldInfo *field_info;
  gpointer field_arg;
  term_t value = PL_new_term_ref();

  if ( !plgi_union_get_blob(union_, &blob) )
  { return FALSE;
  }

  if ( !plgi_union_get_field_info(union_, field_name, &field_info) )
  { return FALSE;
  }

  if ( ~field_info->flags & GI_FIELD_IS_READABLE )
  { plgi_raise_error__va("field %s is not readable",
                         PL_atom_chars(field_info->name));
    return FALSE;
  }

  PLGI_debug("  union: %p (%s), field name: %s", blob->data,
             PL_atom_chars(blob->name), PL_atom_chars(field_info->name));

  field_arg = blob->data + field_info->offset;

  if ( !plgi_arg_to_term(field_arg, field_info->arg_info, value) )
  { return FALSE;
  }

  return PL_unify(field_value, value);
}


PLGI_PRED_IMPL(plgi_union_set_field)
{
  term_t union_      = FA0;
  term_t field_name  = FA1;
  term_t field_value = FA2;

  PLGIBlob *blob;
  PLGIFieldInfo *field_info;
  gpointer field_arg;

  if ( !plgi_union_get_blob(union_, &blob) )
  { return FALSE;
  }

  if ( !plgi_union_get_field_info(union_, field_name, &field_info) )
  { return FALSE;
  }

  if ( ~field_info->flags & GI_FIELD_IS_WRITABLE )
  { plgi_raise_error__va("field %s is not writable",
                         PL_atom_chars(field_info->name));
    return FALSE;
  }

  PLGI_debug("  union: %p (%s), field name: %s", blob->data,
             PL_atom_chars(blob->name), PL_atom_chars(field_info->name));

  field_arg = blob->data + field_info->offset;

  if ( !plgi_term_to_arg(field_value, field_info->arg_info, NULL, field_arg) )
  { return FALSE;
  }

  return TRUE;
}
