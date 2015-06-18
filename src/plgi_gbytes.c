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
                 *          GBytes Arg          *
                 *******************************/

gboolean
plgi_term_to_gbytes(term_t   t,
                    GBytes **bytes)
{
  GBytes *bytes0;
  term_t list = PL_copy_term_ref(t);
  term_t head = PL_new_term_ref();
  guint8 *data;
  gsize len;
  gint i = 0;

  if ( PL_skip_list(list, 0, &len) != PL_LIST )
  { return PL_type_error("list", t);
  }

  data = g_malloc0(len);

  while ( PL_get_list(list, head, list) )
  { guint8 byte;
    if ( !plgi_term_to_guint8(head, &byte) )
    { g_free(data);
      return FALSE;
    }
    data[i++] = byte;
  }

  bytes0 = g_bytes_new_take(data, len);

  PLGI_debug("    term: 0x%lx  --->  GBytes: %p", t, bytes0);

  *bytes = bytes0;

  return TRUE;
}


gboolean
plgi_gbytes_to_term(GBytes *bytes,
                    term_t  t)
{
  term_t list = PL_copy_term_ref(t);
  term_t head = PL_new_term_ref();
  const guint8 *data;
  gsize size;
  gint i;

  PLGI_debug("    GBytes: %p  --->  term: 0x%lx", bytes, t);

  data = g_bytes_get_data(bytes, &size);

  for ( i = 0; i < size; i++ )
  { term_t a = PL_new_term_ref();
    guint8 v = data[i];

    if ( !plgi_guint8_to_term(v, a) )
    { return FALSE;
    }

    if ( !(PL_unify_list(list, head, list) &&
           PL_unify(head, a)) )
    { return FALSE;
    }
  }

  if ( !PL_unify_nil(list) )
  { return FALSE;
  }

  return TRUE;
}


void
plgi_dealloc_gbytes_full(GBytes *bytes)
{
  PLGI_debug("    dealloc GBytes: %p", bytes);

  g_bytes_unref(bytes);
}


void
plgi_dealloc_gbytes_container(GBytes *bytes)
{
  PLGI_debug("    dealloc GBytes: %p", bytes);

  g_bytes_unref(bytes);
}
