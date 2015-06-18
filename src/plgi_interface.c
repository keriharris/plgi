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
                 *        Interface Arg         *
                 *******************************/

gboolean
plgi_term_to_interface(term_t                t,
                       PLGIInterfaceArgInfo *interface_arg_info,
                       gpointer              *interface)
{
  PLGIInterfaceInfo *interface_info = interface_arg_info->interface_info;
  PLGIArgInfo *arg_info = (PLGIArgInfo*)interface_arg_info;
  PLGIBlob *blob;

  PLGI_debug("    term: 0x%lx  --->  GInterface: (%s) %p",
             t, PL_atom_chars(interface_info->name), *interface);

  if ( !plgi_get_blob(t, &blob) )
  { return PL_type_error(PL_atom_chars(interface_info->name), t);
  }

  if ( !g_type_is_a( blob->gtype, interface_info->gtype ) )
  { return PL_type_error(PL_atom_chars(interface_info->name), t);
  }

  *interface = blob->data;

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
plgi_interface_to_term(gpointer              interface,
                       PLGIInterfaceArgInfo *interface_arg_info,
                       term_t                t)
{
  PLGIInterfaceInfo *interface_info = interface_arg_info->interface_info;
  PLGIArgInfo *arg_info = (PLGIArgInfo*)interface_arg_info;
  PLGIBlobType blob_type;
  GType gtype;
  atom_t name;

  PLGI_debug("    GInterface: (%s) %p  --->  term: 0x%lx",
             PL_atom_chars(interface_info->name), interface, t);

  if ( !interface )
  { return plgi_put_null(t);
  }

  gtype = G_TYPE_FROM_INSTANCE(interface);

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

  if ( !plgi_put_blob(blob_type, gtype, name, FALSE, interface, t) )
  { return FALSE;
  }

  if ( arg_info->direction == GI_DIRECTION_OUT &&
       arg_info->transfer == GI_TRANSFER_NOTHING )
  { if ( blob_type == PLGI_BLOB_GOBJECT )
    { g_object_ref_sink(interface);
    }
    else if ( blob_type == PLGI_BLOB_GPARAMSPEC )
    { g_param_spec_ref_sink(interface);
    }
    else
    { g_assert_not_reached();
    }
  }

  return TRUE;
}
