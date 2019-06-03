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


gboolean
plgi_gerror_to_term(GError *error, term_t t)
{
  term_t t0 = PL_new_term_ref();

  if ( !error )
  { return plgi_put_null(t);
  }

  if ( !PL_unify_term(t0,
                      PL_FUNCTOR_CHARS, "error", 2,
                        PL_FUNCTOR_CHARS, "glib_error", 3,
                          PL_UTF8_CHARS, g_quark_to_string(error->domain),
                          PL_INT, error->code,
                          PL_UTF8_CHARS, error->message,
                        PL_VARIABLE) )
  { return FALSE;
  }

  return PL_unify(t, t0);
}


gboolean
plgi_raise_error(gchar *message)
{
  PLGI_debug("!!! raising exception: %s", message);

  term_t except = PL_new_term_ref();
  if ( !PL_unify_term(except,
                      PL_FUNCTOR_CHARS, "error", 2,
                        PL_FUNCTOR_CHARS, "plgi_error", 1,
                          PL_UTF8_CHARS, message,
                        PL_VARIABLE) )
  { return FALSE;
  }
  return PL_raise_exception(except);
}


gboolean
plgi_raise_error__va(gchar *fmt, ...)
{
  gchar message[1024];

  va_list args;
  va_start(args, fmt);
  vsnprintf(message, sizeof(message), fmt, args);
  va_end(args);

  return plgi_raise_error(message);
}


gboolean
plgi_raise_gerror(GError *error)
{
  PLGI_debug("!!! raising exception: %s:%d:%s",
             g_quark_to_string(error->domain), error->code, error->message);

  term_t except = PL_new_term_ref();
  if ( !plgi_gerror_to_term(error, except) )
  { return FALSE;
  }
  return PL_raise_exception(except);
}


gboolean
plgi_print_warning(gchar *message)
{
  PLGI_debug("!!! printing warning: %s", message);

  predicate_t print_message = PL_predicate("print_message", 2, "user");
  term_t warning_args = PL_new_term_refs(2);
  term_t warning = PL_new_term_ref();

  if ( !PL_unify_term(warning,
                      PL_FUNCTOR_CHARS, "plgi_warning", 1,
                        PL_UTF8_CHARS, message) )
  { return FALSE;
  }

  PL_put_atom(warning_args+0, PL_new_atom("warning"));
  PL_put_term(warning_args+1, warning);
  PL_call_predicate(NULL, PL_Q_NODEBUG|PL_Q_CATCH_EXCEPTION, print_message, warning_args);

  return TRUE;
}


gboolean
plgi_print_warning__va(gchar *fmt, ...)
{
  gchar message[1024];

  va_list args;
  va_start(args, fmt);
  vsnprintf(message, sizeof(message), fmt, args);
  va_end(args);

  return plgi_print_warning(message);
}
