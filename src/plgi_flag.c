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
                 *           Flag Arg           *
                 *******************************/

gboolean
plgi_term_to_flag(term_t           t,
                  PLGIEnumArgInfo *enum_arg_info,
                  gint64          *flag)
{
  PLGIEnumInfo *enum_info = enum_arg_info->enum_info;

  term_t list = PL_copy_term_ref(t);
  term_t head = PL_new_term_ref();
  atom_t name;
  gint i;

  PLGI_debug("    term: 0x%lx  --->  flag: (%s) %p",
             t, PL_atom_chars(enum_info->name), flag);

  if ( PL_skip_list(list, 0, NULL) != PL_LIST )
  { return PL_type_error("list", t);
  }

  *flag = 0;
  while ( PL_get_list(list, head, list) )
  { gboolean found = FALSE;

    if ( !PL_get_atom(head, &name) )
    { return PL_type_error(PL_atom_chars(enum_info->name), head);
    }

    for ( i = 0; i < enum_info->n_values; i++ )
    {
      PLGIValueInfo *value_info;
      value_info = enum_info->values_info + i;

      if ( value_info->name == name )
      { *flag |= value_info->value;
        found = TRUE;
      }
    }

    if ( !found )
    { return PL_domain_error(PL_atom_chars(enum_info->name), head);
    }
  }

  return TRUE;
}


gboolean
plgi_flag_to_term(gint64           flag,
                  PLGIEnumArgInfo *enum_arg_info,
                  term_t           t)
{
  PLGIEnumInfo *enum_info = enum_arg_info->enum_info;
  term_t t0 = PL_new_term_ref();
  term_t list = PL_copy_term_ref(t0);
  term_t head = PL_new_term_ref();
  gint i;

  PLGI_debug("    flag: (%s) 0x%lx  --->  term: 0x%lx",
             PL_atom_chars(enum_info->name), flag, t);

  for ( i = 0; i < enum_info->n_values; i++ )
  {
    PLGIValueInfo *value_info;
    value_info = enum_info->values_info + i;

    if ( value_info->value == flag )
    { term_t a = PL_new_term_ref();
      PL_put_atom(a, value_info->name);
      PL_put_nil(t);
      if ( !PL_cons_list(t, a, t) )
      { return FALSE;
      }
      return TRUE;
    }

    if ( value_info->value & flag )
    { term_t a = PL_new_term_ref();
      PL_put_atom(a, value_info->name);
      if ( !(PL_unify_list(list, head, list) &&
             PL_unify(head, a)) )
      { return FALSE;
      }
    }
  }

  if ( !PL_unify_nil(list) )
  { return FALSE;
  }

  return PL_unify(t, t0);
}
