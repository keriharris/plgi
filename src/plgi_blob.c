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
                 *     Internal Functions      *
                 *******************************/

#define PLGI_BLOB_MAGIC 0x23f56c77

gint release_plgi_blob(atom_t a)
{
  PLGIBlob *blob = PL_blob_data(a, NULL, NULL);

  PLGI_debug("[GC] releasing: <%s>%p", PL_atom_chars(blob->name), blob->data);

  if ( blob->magic != PLGI_BLOB_MAGIC)
  { return TRUE;
  }

  blob->magic = 0x0;

  switch ( blob->blob_type )
  {
    case PLGI_BLOB_GOBJECT:
    { g_object_unref(blob->data);
      break;
    }

    case PLGI_BLOB_GPARAMSPEC:
    { g_param_spec_unref(blob->data);
      break;
    }

    case PLGI_BLOB_GVARIANT:
    { g_variant_unref(blob->data);
      break;
    }

    case PLGI_BLOB_SIMPLE:
    { g_free(blob->data);
      break;
    }

    case PLGI_BLOB_BOXED:
    { g_boxed_free(blob->gtype, blob->data);
      break;
    }

    case PLGI_BLOB_TRANSIENT:
    { break;
    }

    case PLGI_BLOB_FOREIGN:
    { chokeme(PLGI_BLOB_FOREIGN);
      break;
    }

    case PLGI_BLOB_OPAQUE:
    { break;
    }

    case PLGI_BLOB_UNTYPED:
    { break;
    }

    default:
    { g_assert_not_reached();
    }
  }

  return TRUE;
}

gint compare_plgi_blobs(atom_t a, atom_t b)
{
  PLGIBlob *blob_a = PL_blob_data(a, NULL, NULL);
  PLGIBlob *blob_b = PL_blob_data(b, NULL, NULL);

  return ( blob_a->data > blob_b->data ?  1 :
           blob_a->data < blob_b->data ? -1 : 0
         );
}

gint write_plgi_blob(IOSTREAM *s, atom_t a, gint flags)
{
  PLGIBlob *blob = PL_blob_data(a, NULL, NULL);

  Sfprintf(s, "<%s>(%p)", PL_atom_chars(blob->name), blob->data);

  return TRUE;
}

static PL_blob_t plgi_blob =
{ PL_BLOB_MAGIC,
  PL_BLOB_UNIQUE,
  "plgi_blob",
  release_plgi_blob,  /* release */
  compare_plgi_blobs, /* compare */
  write_plgi_blob,    /* write */
  NULL,               /* acquire */
};



                 /*******************************
                 *           Blob Arg           *
                 *******************************/

gboolean
plgi_get_blob(term_t     t,
              PLGIBlob **blob)
{
  PLGIBlob *blob0;
  PL_blob_t *type;
  gpointer blob_data;

  if ( !( PL_get_blob(t, &blob_data, NULL, &type) &&
          type == &plgi_blob ) )
  { return FALSE;
  }

  blob0 = blob_data;

  if ( blob0->magic != PLGI_BLOB_MAGIC )
  { return FALSE;
  }

  *blob = blob0;

  return TRUE;
}

gboolean
plgi_put_blob(PLGIBlobType blob_type,
              GType        gtype,
              atom_t       name,
              gpointer     data,
              term_t       t,
              int         *is_new)
{
  PLGIBlob blob;
  int is_new_;

  if ( !data )
  { return plgi_put_null(t);
  }

  memset(&blob, 0, sizeof(PLGIBlob));
  blob.data = data;
  blob.name = name;
  blob.gtype = gtype;
  blob.blob_type = blob_type;
  blob.magic = PLGI_BLOB_MAGIC;

  is_new_ = PL_put_blob(t, &blob, sizeof(PLGIBlob), &plgi_blob);

  if ( is_new )
  { *is_new = is_new_;
  }
/*
  if ( is_new && transfer == GI_TRANSFER_NOTHING )
  { if ( blob_type == PLGI_BLOB_GOBJECT )
    { g_object_ref_sink(data);
    }
    else if ( blob_type == PLGI_BLOB_GPARAMSPEC )
    { g_param_spec_ref_sink(data);
    }
    if ( blob_type == PLGI_BLOB_GVARIANT )
    { g_variant_ref_sink(data);
    }
  }
*/
  return TRUE;
}


gboolean
plgi_blob_is_a(term_t t,
               GType gtype)
{
  PL_blob_t *blob_type;
  gpointer data;

  if ( PL_get_blob(t, &data, NULL, &blob_type) && blob_type == &plgi_blob )
  { PLGIBlob *blob = data;
    if ( blob->magic == PLGI_BLOB_MAGIC &&
         g_type_is_a( blob->gtype, gtype ) )
    { return TRUE;
    }
  }

  return FALSE;
}


gboolean
plgi_term_to_gpointer(term_t       t,
                      PLGIArgInfo *arg_info,
                      gpointer    *data)
{
  PLGIBlob *blob;

  PLGI_debug("    term: 0x%lx  --->  gpointer: %p", t, *data);

  if ( !plgi_get_blob(t, &blob) )
  { return PL_type_error("gpointer", t);
  }

  if ( blob->gtype != G_TYPE_NONE )
  { return PL_type_error("gpointer", t);
  }

  if ( arg_info->flags & PLGI_ARG_IS_POINTER )
  { *data = blob->data;
  }
  else
  { plgi_raise_error("cannot pass-by-value untyped gpointer");
    return FALSE;
  }

  if ( arg_info->direction == GI_DIRECTION_IN &&
       arg_info->transfer != GI_TRANSFER_NOTHING )
  { blob->magic = 0x0;
  }

  return TRUE;
}


gboolean
plgi_gpointer_to_term(gpointer     data,
                      PLGIArgInfo *arg_info,
                      term_t       t)
{
  PLGI_debug("    gpointer: %p  --->  term: 0x%lx", data, t);

  if ( !data )
  { return plgi_put_null(t);
  }

  if ( !plgi_put_blob(PLGI_BLOB_UNTYPED, G_TYPE_NONE, PL_new_atom("gpointer"),
                      data, t, NULL) )
  { return FALSE;
  }

  return TRUE;
}
