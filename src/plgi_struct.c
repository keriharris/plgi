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
plgi_struct_get_blob(term_t     struct_,
                     PLGIBlob **blob) PLGI_WARN_UNUSED;

gboolean
plgi_struct_get_field_info(term_t          struct_,
                           term_t          field_name,
                           PLGIFieldInfo **field_info) PLGI_WARN_UNUSED;



                /*******************************
                 *     Internal Functions      *
                 *******************************/

gboolean
plgi_struct_get_blob(term_t     t,
                     PLGIBlob **blob)
{
  PLGIBlob *blob0;

  if ( !plgi_get_blob(t, &blob0) )
  { return PL_type_error("struct", t);
  }

  if ( blob0->blob_type != PLGI_BLOB_GVARIANT &&
       blob0->blob_type != PLGI_BLOB_SIMPLE &&
       blob0->blob_type != PLGI_BLOB_BOXED &&
       blob0->blob_type != PLGI_BLOB_TRANSIENT &&
       blob0->blob_type != PLGI_BLOB_FOREIGN &&
       blob0->blob_type != PLGI_BLOB_OPAQUE )
  { return PL_type_error("struct", t);
  }

  *blob = blob0;

  return TRUE;
}


gboolean
plgi_struct_get_field_info(term_t          struct_,
                           term_t          field_name,
                           PLGIFieldInfo **field_info)
{
  PLGIBlob *blob;
  PLGIStructInfo *struct_info;
  PLGIFieldInfo *field_info0;
  atom_t name;
  gint i;

  if ( !plgi_struct_get_blob(struct_, &blob) )
  { return FALSE;
  }

  if ( !plgi_get_struct_info(blob->name, &struct_info) )
  { plgi_raise_error__va("unregistered struct %s",
                         PL_atom_chars(blob->name));
    return FALSE;
  }

  if ( struct_info->n_fields == 0 )
  { return PL_type_error("non-opaque struct", struct_);
  }

  if ( !PL_get_atom_ex(field_name, &name) )
  { return FALSE;
  }

  field_info0 = NULL;
  for ( i = 0; i < struct_info->n_fields; i++ )
  { field_info0 = struct_info->fields_info + i;
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
                 *          Struct Arg          *
                 *******************************/

gboolean
plgi_term_to_struct(term_t             t,
                    PLGIStructArgInfo *struct_arg_info,
                    gpointer          *struct_)
{
  PLGIBlob *blob;
  PLGIStructInfo *struct_info = struct_arg_info->struct_info;
  PLGIArgInfo *arg_info = (PLGIArgInfo*)struct_arg_info;

  PLGI_debug("    term: 0x%lx  --->  struct: (%s) %p",
             t, PL_atom_chars(struct_info->name), *struct_);

  if ( !plgi_get_blob(t, &blob) )
  { return PL_type_error(PL_atom_chars(struct_info->name), t);
  }

  if ( blob->gtype != G_TYPE_NONE &&
       !g_type_is_a( blob->gtype, struct_info->gtype ) )
  { return PL_type_error(PL_atom_chars(struct_info->name), t);
  }

  if ( arg_info->flags & PLGI_ARG_IS_POINTER )
  { *struct_ = blob->data;
  }
  else if ( struct_info->size > 0 )
  { memcpy(*struct_, blob->data, struct_info->size);
  }
  else
  { plgi_raise_error("cannot pass-by-value opaque struct");
    return FALSE;
  }

  if ( arg_info->transfer != GI_TRANSFER_NOTHING )
  { blob->magic = 0x0;
  }

  return TRUE;
}


gboolean
plgi_struct_to_term(gpointer           struct_,
                    PLGIStructArgInfo *struct_arg_info,
                    term_t             t)
{
  PLGIStructInfo *struct_info = struct_arg_info->struct_info;
  PLGIArgInfo *arg_info = (PLGIArgInfo*)struct_arg_info;
  PLGIBlobType blob_type;
  gpointer data;

  PLGI_debug("    struct: (%s) %p  --->  term: 0x%lx",
             PL_atom_chars(struct_info->name), struct_, t);

  if ( !struct_ )
  { return plgi_put_null(t);
  }

  data = struct_;

  if ( g_type_is_a(struct_info->gtype, G_TYPE_VARIANT ) )
  { blob_type = PLGI_BLOB_GVARIANT;
  }

  else if ( g_type_is_a(struct_info->gtype, G_TYPE_BOXED ) )
  { if ( arg_info->transfer == GI_TRANSFER_EVERYTHING )
    { blob_type = PLGI_BLOB_BOXED;
      if ( ~arg_info->flags & PLGI_ARG_IS_POINTER )
      { data = g_boxed_copy(struct_info->gtype, struct_);
      }
    }
    else
    { blob_type = PLGI_BLOB_TRANSIENT;
    }
  }

  else if ( struct_info->n_fields > 0 )
  { if ( arg_info->transfer == GI_TRANSFER_EVERYTHING )
    { blob_type = PLGI_BLOB_SIMPLE;
      if ( ~arg_info->flags & PLGI_ARG_IS_POINTER )
      { data = g_malloc0(struct_info->size);
        memcpy(data, struct_, struct_info->size);
      }
    }
    else
    { blob_type = PLGI_BLOB_TRANSIENT;
    }
  }

  /* FIXME: handle foreign structs */

  else
  { blob_type = PLGI_BLOB_OPAQUE;
  }

  if ( !plgi_put_blob(blob_type, struct_info->gtype, struct_info->name,
                      data, t) )
  { return FALSE;
  }

  if ( arg_info->transfer == GI_TRANSFER_NOTHING )
  { if ( blob_type == PLGI_BLOB_GVARIANT )
    { g_variant_ref_sink(data);
    }
  }

  return TRUE;
}


gboolean
plgi_alloc_struct(gpointer          *struct_,
                  PLGIStructArgInfo *struct_arg_info)
{
  PLGIStructInfo *struct_info = struct_arg_info->struct_info;
  gpointer struct0;

  if ( struct_info->size == 0 )
  { plgi_raise_error("unknown struct size, cannot allocate");
    return FALSE;
  }

  struct0  = g_malloc0(struct_info->size);

  if ( G_TYPE_IS_BOXED(struct_info->gtype) )
  { *struct_ = g_boxed_copy(struct_info->gtype, struct0);
    g_free(struct0);
  }
  else
  { *struct_ = struct0;
  }

  return TRUE;
}


gsize
plgi_struct_size(PLGIStructArgInfo *struct_arg_info)
{
  PLGIStructInfo *struct_info = struct_arg_info->struct_info;

  return struct_info->size;
}



                 /*******************************
                 *      Foreign Predicates      *
                 *******************************/

PLGI_PRED_IMPL(plgi_struct_new)
{
  term_t t       = FA0;
  term_t struct_ = FA1;

  PLGIStructInfo *struct_info;
  PLGIArgCache *arg_cache = NULL;
  atom_t name;
  gsize arity;
  gint i;
  term_t struct_blob = PL_new_term_ref();
  PLGIBlobType blob_type;
  gpointer struct0, data;
  gboolean ret = TRUE;

  atom_t ATOM_equals = PL_new_atom("=");

  if ( !PL_get_name_arity(t, &name, &arity) )
  { return PL_type_error("struct", t);
  }

  if ( !plgi_get_struct_info(name, &struct_info) )
  { plgi_raise_error__va("unregistered struct %s", PL_atom_chars(name));
    return FALSE;
  }

  if ( arity > struct_info->n_fields )
  { plgi_raise_error__va("struct %s cannot contain more than %d fields",
                         PL_atom_chars(name), struct_info->n_fields);
    return FALSE;
  }

  if ( struct_info->n_fields == 0 )
  { plgi_raise_error("cannot create opaque struct");
    return FALSE;
  }

  struct0 = g_malloc0(struct_info->size);
  arg_cache = g_malloc0(sizeof(*arg_cache));
  arg_cache->id = plgi_cache_id();

  for ( i = 0; i < arity; i++ )
  { PLGIFieldInfo *field_info = struct_info->fields_info + i;
    term_t field = PL_new_term_ref();
    term_t t_name = PL_new_term_ref();
    term_t t_value = PL_new_term_ref();
    atom_t a_name;
    gpointer field_data;
    gsize field_arity;

    _PL_get_arg(i+1, t, field);
    if ( !( PL_get_name_arity(field, &name, &field_arity) &&
            name == ATOM_equals && field_arity == 2 ) )
    { g_free(struct0);
      ret = PL_type_error("struct field", t);
      goto cleanup;
    }

    _PL_get_arg(1, field, t_name);
    if ( !PL_get_atom_ex(t_name, &a_name) )
    { g_free(struct0);
      ret = FALSE;
      goto cleanup;
    }

    if ( a_name != field_info->name )
    { g_free(struct0);
      ret = PL_domain_error("struct field name", t_name);
      goto cleanup;
    }

    _PL_get_arg(2, field, t_value);
    field_data = struct0 + field_info->offset;
    if ( !plgi_term_to_arg(t_value, field_info->arg_info, arg_cache, field_data) )
    { g_free(struct0);
      ret = FALSE;
      goto cleanup;
    }
  }

  if ( g_type_is_a(struct_info->gtype, G_TYPE_BOXED ) )
  { blob_type = PLGI_BLOB_BOXED;
    data = g_boxed_copy(struct_info->gtype, struct0);
    g_free(struct0);
  }

  else if ( struct_info->n_fields > 0 )
  { blob_type = PLGI_BLOB_SIMPLE;
    data = struct0;
  }

  else
  { blob_type = PLGI_BLOB_OPAQUE;
    data = struct0;
  }

  if ( !plgi_put_blob(blob_type, struct_info->gtype, struct_info->name,
                      data, struct_blob) )
  { ret = FALSE;
    goto cleanup;
  }

  PLGI_debug("  struct: %p (%s)", data, PL_atom_chars(struct_info->name));

  ret = PL_unify(struct_, struct_blob);

 cleanup:

  if ( arg_cache ) plgi_dealloc_arg_cache(arg_cache, !ret);

  return ret;
}


PLGI_PRED_IMPL(plgi_struct_get_field)
{
  term_t struct_     = FA0;
  term_t field_name  = FA1;
  term_t field_value = FA2;

  PLGIBlob *blob;
  PLGIFieldInfo *field_info;
  gpointer field_arg;
  term_t value = PL_new_term_ref();

  if ( !plgi_struct_get_blob(struct_, &blob) )
  { return FALSE;
  }

  if ( !plgi_struct_get_field_info(struct_, field_name, &field_info) )
  { return FALSE;
  }

  if ( ~field_info->flags & GI_FIELD_IS_READABLE )
  { plgi_raise_error__va("field %s is not readable",
                         PL_atom_chars(field_info->name));
    return FALSE;
  }

  PLGI_debug("  struct: %p (%s), field name: %s", blob->data,
             PL_atom_chars(blob->name), PL_atom_chars(field_info->name));

  field_arg = blob->data + field_info->offset;

  if ( !plgi_arg_to_term(field_arg, field_info->arg_info, value) )
  { return FALSE;
  }

  return PL_unify(field_value, value);
}


PLGI_PRED_IMPL(plgi_struct_set_field)
{
  term_t struct_     = FA0;
  term_t field_name  = FA1;
  term_t field_value = FA2;

  PLGIBlob *blob;
  PLGIFieldInfo *field_info;
  gpointer field_arg;

  if ( !plgi_struct_get_blob(struct_, &blob) )
  { return FALSE;
  }

  if ( !plgi_struct_get_field_info(struct_, field_name, &field_info) )
  { return FALSE;
  }

  if ( ~field_info->flags & GI_FIELD_IS_WRITABLE )
  { plgi_raise_error__va("field %s is not writable",
                         PL_atom_chars(field_info->name));
    return FALSE;
  }

  PLGI_debug("  struct: %p (%s), field name: %s", blob->data,
             PL_atom_chars(blob->name), PL_atom_chars(field_info->name));

  field_arg = blob->data + field_info->offset;

  if ( !plgi_term_to_arg(field_value, field_info->arg_info, NULL, field_arg) )
  { return FALSE;
  }

  return TRUE;
}


PLGI_PRED_IMPL(plgi_struct_term)
{
  term_t struct_ = FA0;
  term_t fields  = FA1;

  PLGIBlob *blob;
  PLGIStructInfo *struct_info;
  gint i;

  if ( !plgi_struct_get_blob(struct_, &blob) )
  { return FALSE;
  }

  if ( !plgi_get_struct_info(blob->name, &struct_info) )
  { plgi_raise_error__va("unregistered struct %s",
                         PL_atom_chars(blob->name));
    return FALSE;
  }

  if ( struct_info->n_fields == 0 )
  { return PL_type_error("non-opaque struct", struct_);
  }

  functor_t f_equals = PL_new_functor(PL_new_atom("="), 2);
  term_t fields0 = PL_new_term_ref();
  term_t a0 = PL_new_term_refs(struct_info->n_fields);

  atom_t ATOM_hidden = PL_new_atom("<hidden>");

  for ( i = 0; i < struct_info->n_fields; i++ )
  { PLGIFieldInfo *field_info;
    term_t field = a0 + i;
    term_t name = PL_new_term_ref();
    term_t value = PL_new_term_ref();
    gpointer field_arg;

    field_info = struct_info->fields_info + i;
    PL_put_atom(name, field_info->name);

    if ( field_info->flags & GI_FIELD_IS_READABLE )
    { field_arg = blob->data + field_info->offset;

      if ( !plgi_arg_to_term(field_arg, field_info->arg_info, value) )
      { return FALSE;
      }
    }
    else
    { PL_put_atom(value, ATOM_hidden);
    }

    if ( !PL_cons_functor(field, f_equals, name, value) )
    { return FALSE;
    }
  }

  functor_t f = PL_new_functor(blob->name, struct_info->n_fields);
  if ( !PL_cons_functor_v(fields0, f, a0) )
  { return FALSE;
  }

  return PL_unify(fields, fields0);
}
