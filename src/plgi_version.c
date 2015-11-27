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
                 *      Foreign Predicates      *
                 *******************************/

PLGI_PRED_IMPL(plgi_version)
{
  term_t version = FA0;

  term_t ver = PL_new_term_ref();

  if ( !plgi_gint_to_term(PLGI_VERSION, ver) ) return FALSE;

  return PL_unify(version, ver);
}
