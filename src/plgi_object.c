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



                /*******************************
                 *     Internal Functions      *
                 *******************************/

gboolean
plgi_object_get_blob(term_t     t,
                     PLGIBlob **blob)
{
  PLGIBlob *blob0;

  if ( !plgi_get_blob(t, &blob0) )
  { return PL_type_error("GObject", t);
  }

  if ( blob0->blob_type != PLGI_BLOB_GOBJECT &&
       blob0->blob_type != PLGI_BLOB_GPARAMSPEC )
  { return PL_type_error("GObject", t);
  }

  *blob = blob0;

  return TRUE;
}


gboolean
plgi_object_property_info(atom_t             object_name,
                          atom_t             property_name,
                          PLGIPropertyInfo **property_info)
{
  PLGIObjectInfo *object_info;
  gint i;

  *property_info = NULL;

  while ( object_name )
  {
    if ( !plgi_get_object_info(object_name, &object_info) )
    { plgi_raise_error__va("unregistered object %s",
                           PL_atom_chars(object_name));
      return FALSE;
    }

    for ( i = 0; i < object_info->n_properties; i++ )
    { PLGIPropertyInfo *property_info0 = object_info->properties_info + i;
      if ( property_info0->name == property_name )
      { *property_info = property_info0;
        break;
      }
    }
    if ( *property_info )
    { break;
    }

    for ( i = 0; i < object_info->n_interfaces; i++ )
    { PLGIInterfaceInfo *interface_info = object_info->interfaces_info[i];
      gint j;

      for ( j = 0; j < interface_info->n_properties; j++ )
      { PLGIPropertyInfo *property_info0 = interface_info->properties_info + j;
        if ( property_info0->name == property_name )
        { *property_info = property_info0;
          break;
        }
      }
      if ( *property_info )
      { break;
      }
    }
    if ( *property_info )
    { break;
    }

    object_name = object_info->parent_name;
  }

  if ( !*property_info )
  { term_t t = PL_new_term_ref();
    PL_put_atom(t, property_name);
    return PL_domain_error("property name", t);
  }

  return TRUE;
}


gboolean
plgi_object_property_gvalue(atom_t  object_name,
                            atom_t  property_name,
                            GValue *gvalue)
{
  GType object_gtype;
  GObjectClass *object_class;
  GParamSpec *param_spec;

  object_gtype = g_type_from_name(PL_atom_chars(object_name));
  object_class = g_type_class_peek(object_gtype);
  if ( !object_class )
  { object_class = g_type_class_ref(object_gtype);
  }

  param_spec = g_object_class_find_property(object_class,
                                            PL_atom_chars(property_name));
  if ( !param_spec )
  { term_t t = PL_new_term_ref();
    PL_put_atom(t, property_name);
    return PL_domain_error("property name", t);
  }

  g_value_init(gvalue, G_PARAM_SPEC_VALUE_TYPE(param_spec));

  return TRUE;
}



                 /*******************************
                 *          Object Arg          *
                 *******************************/



gboolean
plgi_term_to_object(term_t             t,
                    PLGIObjectArgInfo *object_arg_info,
                    gpointer          *object)
{
  PLGIObjectInfo *object_info = object_arg_info->object_info;
  PLGIArgInfo *arg_info = (PLGIArgInfo*)object_arg_info;
  PLGIBlob *blob;

  PLGI_debug("    term: 0x%lx  --->  GObject: (%s) %p",
             t, PL_atom_chars(object_info->name), *object);

  if ( !plgi_get_blob(t, &blob) )
  { return PL_type_error(PL_atom_chars(object_info->name), t);
  }

  if ( !g_type_is_a( blob->gtype, object_info->gtype ) )
  { return PL_type_error(PL_atom_chars(object_info->name), t);
  }

  *object = blob->data;

  if ( arg_info->transfer != GI_TRANSFER_NOTHING )
  { if ( blob->blob_type == PLGI_BLOB_GOBJECT )
    { g_object_ref(blob->data);
    }
    else if ( blob->blob_type == PLGI_BLOB_GPARAMSPEC )
    { g_param_spec_ref(blob->data);
    }
    else
    { g_assert_not_reached();
    }
  }

  return TRUE;
}


gboolean
plgi_object_to_term(gpointer           object,
                    PLGIObjectArgInfo *object_arg_info,
                    term_t             t)
{
  PLGIObjectInfo *object_info = object_arg_info->object_info;
  PLGIArgInfo *arg_info = (PLGIArgInfo*)object_arg_info;
  PLGIBlobType blob_type;
  GType gtype;
  atom_t name;

  PLGI_debug("    GObject: (%s) %p  --->  term: 0x%lx",
             PL_atom_chars(object_info->name), object, t);

  if ( !object )
  { return plgi_put_null(t);
  }

  gtype = G_TYPE_FROM_INSTANCE(object);

  if ( g_type_is_a( gtype, G_TYPE_OBJECT ) )
  { blob_type = PLGI_BLOB_GOBJECT;
  }
  else if ( g_type_is_a( gtype, G_TYPE_PARAM ) )
  { blob_type = PLGI_BLOB_GPARAMSPEC;
  }
  else
  { plgi_raise_error__va("unsupported GType %s", g_type_name(gtype));
    return FALSE;
  }

  name = PL_new_atom(g_type_name(gtype));

  if ( !plgi_put_blob(blob_type, gtype, name, FALSE, object, t) )
  { return FALSE;
  }

  if ( arg_info->transfer == GI_TRANSFER_NOTHING )
  { if ( blob_type == PLGI_BLOB_GOBJECT )
    { g_object_ref_sink(object);
    }
    else if ( blob_type == PLGI_BLOB_GPARAMSPEC )
    { g_param_spec_ref_sink(object);
    }
    else
    { g_assert_not_reached();
    }
  }

  return TRUE;
}



                 /*******************************
                 *      Foreign Predicates      *
                 *******************************/

PLGI_PRED_IMPL(plgi_object_new)
{
  term_t object_type = FA0;
  term_t properties  = FA1;
  term_t object      = FA2;

  PLGIObjectInfo *object_info;
  GObject *gobject = NULL;
  GType object_gtype;
  GParameter *parameters = NULL;
  PLGIArgCache *arg_cache = NULL;
  PLGIBlobType blob_type;
  atom_t object_name, property_name;
  guint n_parameters;
  gint i;
  term_t list = PL_copy_term_ref(properties);
  term_t head = PL_new_term_ref();
  term_t object0 = PL_new_term_ref();
  gsize len;
  gboolean ret = TRUE;

  if ( !PL_get_atom_ex(object_type, &object_name) )
  { return FALSE;
  }

  if ( !plgi_get_object_info(object_name, &object_info) )
  { plgi_raise_error__va("unregistered object %s",
                         PL_atom_chars(object_name));
    return FALSE;
  }

  if ( PL_skip_list(properties, 0, &len) != PL_LIST )
  { return PL_type_error("list", properties);
  }

  n_parameters = len;
  parameters = g_malloc0_n(n_parameters, sizeof(*parameters));
  arg_cache = g_malloc0(sizeof(*arg_cache));
  arg_cache->id = plgi_cache_id();

  atom_t ATOM_equals = PL_new_atom("=");

  i = 0;
  while ( PL_get_list(list, head, list) )
  {
    PLGIPropertyInfo *property_info;
    GIArgument arg;
    GParameter *parameter;
    GValue *gvalue;
    term_t prop_name = PL_new_term_ref();
    term_t prop_value = PL_new_term_ref();
    atom_t name;
    gsize arity;

    parameter = parameters + i;
    gvalue = &parameter->value;

    if ( !( PL_get_name_arity(head, &name, &arity) &&
            name == ATOM_equals && arity == 2 ) )
    { ret = PL_type_error("property field", head);
      goto cleanup;
    }

    _PL_get_arg(1, head, prop_name);
    if ( !PL_get_atom_ex(prop_name, &property_name) )
    { ret = FALSE;
      goto cleanup;
    }

    parameter->name = PL_atom_chars(property_name);

    if ( !plgi_object_property_info(object_name, property_name, &property_info) )
    { ret = FALSE;
      goto cleanup;
    }

    if ( !plgi_object_property_gvalue(object_name, property_name, gvalue) )
    { ret = FALSE;
      goto cleanup;
    }

    _PL_get_arg(2, head, prop_value);
    if ( !plgi_term_to_arg(prop_value, property_info->arg_info, arg_cache, &arg) )
    { ret = FALSE;
      goto cleanup;
    }
    plgi_arg_to_gvalue(&arg, property_info->arg_info, gvalue);

    i++;
  }

  object_gtype = g_type_from_name(PL_atom_chars(object_name));
  gobject = g_object_newv(object_gtype, n_parameters, parameters);

  if ( g_object_is_floating(gobject) )
  { g_object_ref_sink(gobject);
  }

  blob_type = PLGI_BLOB_GOBJECT;
  if ( !plgi_put_blob(blob_type, object_gtype, object_name, FALSE, gobject, object0) )
  { ret = FALSE;
    goto cleanup;
  }

  PLGI_debug("  object: %p (%s)", gobject, PL_atom_chars(object_name));

  ret = PL_unify(object, object0);

 cleanup:

  if ( !ret )
  { if ( gobject ) g_clear_object(&gobject);
  }

  if ( parameters ) g_free(parameters);
  if ( arg_cache ) plgi_dealloc_arg_cache(arg_cache, !ret);

  return ret;
}


PLGI_PRED_IMPL(plgi_object_get_property)
{
  term_t object     = FA0;
  term_t prop_name  = FA1;
  term_t prop_value = FA2;

  PLGIBlob *object_blob;
  GObject *gobject;
  PLGIPropertyInfo *property_info = NULL;
  GValue gvalue = { 0, };
  GIArgument arg;
  atom_t object_name, property_name;
  term_t prop_value0 = PL_new_term_ref();

  if ( !plgi_object_get_blob(object, &object_blob) )
  { return FALSE;
  }

  object_name = object_blob->name;
  gobject = object_blob->data;

  if ( !PL_get_atom_ex(prop_name, &property_name) )
  { return FALSE;
  }

  if ( !plgi_object_property_info(object_name, property_name, &property_info) )
  { return FALSE;
  }

  if ( !plgi_object_property_gvalue(object_name, property_name, &gvalue) )
  { return FALSE;
  }

  PLGI_debug("  object: %p (%s), property name: %s", gobject,
             PL_atom_chars(object_name), PL_atom_chars(property_name));

  g_object_get_property(gobject, PL_atom_chars(property_name), &gvalue);
  plgi_gvalue_to_arg(&gvalue, property_info->arg_info, &arg);

  if ( !plgi_arg_to_term(&arg, property_info->arg_info, prop_value0) )
  { return FALSE;
  }

  return PL_unify(prop_value, prop_value0);
}


PLGI_PRED_IMPL(plgi_object_set_property)
{
  term_t object     = FA0;
  term_t prop_name  = FA1;
  term_t prop_value = FA2;

  PLGIBlob *object_blob;
  GObject *gobject;
  PLGIPropertyInfo *property_info = NULL;
  GValue gvalue = { 0, };
  GIArgument arg;
  atom_t object_name, property_name;

  if ( !plgi_object_get_blob(object, &object_blob) )
  { return FALSE;
  }

  object_name = object_blob->name;
  gobject = object_blob->data;

  if ( !PL_get_atom_ex(prop_name, &property_name) )
  { return FALSE;
  }

  if ( !plgi_object_property_info(object_name, property_name, &property_info) )
  { return FALSE;
  }

  if ( !plgi_object_property_gvalue(object_name, property_name, &gvalue) )
  { return FALSE;
  }

  if ( !plgi_term_to_arg(prop_value, property_info->arg_info, NULL, &arg) )
  { return FALSE;
  }

  PLGI_debug("  object: %p (%s), property name: %s", gobject,
             PL_atom_chars(object_name), PL_atom_chars(property_name));

  plgi_arg_to_gvalue(&arg, property_info->arg_info, &gvalue);
  g_object_set_property(gobject, PL_atom_chars(property_name), &gvalue);

  return TRUE;
}
