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
                 *          GStrv Arg           *
                 *******************************/

gboolean
plgi_term_to_gstrv(term_t  t,
                   GStrv  *gstrv)
{
  term_t list = PL_copy_term_ref(t);
  term_t head = PL_new_term_ref();
  GStrv gstrv0;
  gsize len;
  gint i;

  PLGI_debug("    term: 0x%lx  --->  GStrv: %p", t, *gstrv);

  if ( PL_skip_list(list, 0, &len) != PL_LIST )
  { return PL_type_error("list", t);
  }

  gstrv0 = g_malloc0_n(len + 1, sizeof(gchar*));

  i = 0;
  while ( PL_get_list(list, head, list) )
  {
    if ( !plgi_term_to_utf8(head, gstrv0 + i) )
    { g_strfreev(gstrv0);
      return FALSE;
    }
    i++;
  }

  if ( !PL_get_nil(list) )
  { g_strfreev(gstrv0);
    return FALSE;
  }

  *gstrv = gstrv0;

  return TRUE;
}


gboolean
plgi_gstrv_to_term(GStrv  gstrv,
                   term_t t)
{
  term_t list = PL_copy_term_ref(t);
  term_t head = PL_new_term_ref();
  guint len;
  gint i;

  PLGI_debug("    GStrv: %p  --->  term: 0x%lx", gstrv, t);

  if ( !gstrv )
  { return PL_put_nil(t);
  }

  len = g_strv_length(gstrv);

  for ( i = 0; i < len; i++ )
  {
    term_t a = PL_new_term_ref();

    if ( !plgi_utf8_to_term(gstrv[i], a) )
    { return FALSE;
    }

    if ( !(PL_unify_list(list, head, list) &&
           PL_unify(head, a)) )
    { return FALSE;
    }
  }

  return PL_unify_nil(list);
}


void
plgi_dealloc_gstrv(GStrv gstrv)
{
  PLGI_debug("    dealloc GStrv: %p", gstrv);

  g_strfreev(gstrv);
}
