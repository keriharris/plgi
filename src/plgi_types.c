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

#include <string.h>



                 /*******************************
                 *             NULL             *
                 *******************************/

gboolean
plgi_get_null(term_t t, gpointer *v)
{ atom_t name;
  gint arity;

  if ( PL_get_name_arity(t, &name, &arity) )
  { const gchar* s;
    s = PL_atom_chars(name);
    if ( strcmp(s, "{}") == 0 && arity == 1 )
    { term_t a = PL_new_term_ref();
      _PL_get_arg(1, t, a);
      if ( PL_get_atom_chars(a, (gchar**)&s) && strcmp(s, "null") == 0 )
      { *v = NULL;
        return TRUE;
      }
    }
  }

  return FALSE;
}

gboolean
plgi_put_null(term_t t)
{ term_t a = PL_new_term_ref();
  functor_t f = PL_new_functor(PL_new_atom("{}"), 1);

  if ( PL_put_atom_chars(a, "null") && PL_cons_functor(t, f, a) )
  { return TRUE;
  }

  return FALSE;
}



                 /*******************************
                 *           gboolean           *
                 *******************************/

gboolean
plgi_term_to_gboolean(term_t t, gboolean *v)
{ gint i;

  if ( PL_get_bool(t, &i) )
  { *v = i;
    PLGI_debug("    term: 0x%lx -->  gboolean: %d", t, *v);
    return TRUE;
  }

  return PL_type_error("boolean", t);
}

gboolean
plgi_gboolean_to_term(gboolean v, term_t t)
{
  PLGI_debug("    gboolean: %d -->  term: 0x%lx", v, t);

  return PL_unify_bool(t, v);
}



                 /*******************************
                 *            gint8             *
                 *******************************/

gboolean
plgi_term_to_gint8(term_t t, gint8 *v)
{ gint i;

  if ( PL_get_integer(t, &i) )
  { if ( i >= G_MININT8 && i <= G_MAXINT8 )
    { *v = i;
      PLGI_debug("    term: 0x%lx -->  gint8: %hhd", t, *v);
      return TRUE;
    }
  }

  return PL_type_error("8 bit integer", t);
}

gboolean
plgi_gint8_to_term(gint8 v, term_t t)
{
  PLGI_debug("    gint8: %hhd -->  term: 0x%lx", v, t);

  return PL_unify_integer(t, v);
}



                 /*******************************
                 *            guint8            *
                 *******************************/

gboolean
plgi_term_to_guint8(term_t t, guint8 *v)
{ gint i;

  if ( PL_get_integer(t, &i) )
  { if ( i >= 0 && i <= G_MAXUINT8 )
    { *v = i;
      PLGI_debug("    term: 0x%lx -->  guint8: %hhu", t, *v);
      return TRUE;
    }
  }

  return PL_type_error("8 bit unsigned integer", t);
}

gboolean
plgi_guint8_to_term(guint8 v, term_t t)
{
  PLGI_debug("    guint8: %hhu -->  term: 0x%lx", v, t);

  return PL_unify_integer(t, v);
}



                 /*******************************
                 *            gint16            *
                 *******************************/

gboolean
plgi_term_to_gint16(term_t t, gint16 *v)
{ gint i;

  if ( PL_get_integer(t, &i) )
  { if ( i >= G_MININT16 && i <= G_MAXINT16 )
    { *v = i;
      PLGI_debug("    term: 0x%lx -->  gint16: %hd", t, *v);
      return TRUE;
    }
  }

  return PL_type_error("16 bit integer", t);
}

gboolean
plgi_gint16_to_term(gint16 v, term_t t)
{
  PLGI_debug("    gint16: %hd -->  term: 0x%lx", v, t);

  return PL_unify_integer(t, v);
}



                 /*******************************
                 *           guint16            *
                 *******************************/

gboolean
plgi_term_to_guint16(term_t t, guint16 *v)
{ gint i;

  if ( PL_get_integer(t, &i) )
  { if ( i >= 0 && i <= G_MAXUINT16 )
    { *v = i;
      PLGI_debug("    term: 0x%lx -->  guint16: %hu", t, *v);
      return TRUE;
    }
  }

  return PL_type_error("16 bit unsigned integer", t);
}

gboolean
plgi_guint16_to_term(guint16 v, term_t t)
{
  PLGI_debug("    guint16: %hu -->  term: 0x%lx", v, t);

  return PL_unify_integer(t, v);
}



                 /*******************************
                 *            gint32            *
                 *******************************/

gboolean
plgi_term_to_gint32(term_t t, gint32 *v)
{ gint64 i;

  if ( PL_get_int64(t, &i) )
  { if ( i >= G_MININT32 && i <= G_MAXINT32 )
    { *v = i;
      PLGI_debug("    term: 0x%lx -->  gint32: %d", t, *v);
      return TRUE;
    }
  }
  else if ( PL_is_atom(t) )
  { atom_t enum_name;
    if ( PL_get_atom(t, &enum_name) &&
         plgi_get_enum_value(enum_name, &i) )
    { *v = i;
      PLGI_debug("    term: 0x%lx -->  gint32: %d (%s)",
                 t, *v, PL_atom_chars(enum_name));
      return TRUE;
    }
  }
  else if ( PL_is_list(t) )
  { if ( plgi_get_flags_value(t, &i) )
    { *v = i;
      PLGI_debug("    term: 0x%lx -->  gint32: %u", t, *v);
      return TRUE;
    }
  }

  return PL_type_error("32 bit integer", t);
}

gboolean
plgi_gint32_to_term(gint32 v, term_t t)
{
  PLGI_debug("    gint32: %d -->  term: 0x%lx", v, t);

  return PL_unify_integer(t, v);
}



                 /*******************************
                 *           guint32            *
                 *******************************/

gboolean
plgi_term_to_guint32(term_t t, guint32 *v)
{ gint64 i;

  if ( PL_get_int64(t, &i) )
  { if ( i >= 0 && i <= G_MAXUINT32 )
    { *v = i;
      PLGI_debug("    term: 0x%lx -->  guint32: %u", t, *v);
      return TRUE;
    }
  }
  else if ( PL_is_atom(t) )
  { atom_t enum_name;
    if ( PL_get_atom(t, &enum_name) &&
         plgi_get_enum_value(enum_name, &i) )
    { *v = i;
      PLGI_debug("    term: 0x%lx -->  guint32: %u (%s)",
                 t, *v, PL_atom_chars(enum_name));
      return TRUE;
    }
  }
  else if ( PL_is_list(t) )
  { if ( plgi_get_flags_value(t, &i) )
    { *v = i;
      PLGI_debug("    term: 0x%lx -->  guint32: %u", t, *v);
      return TRUE;
    }
  }

  return PL_type_error("32 bit unsigned integer", t);
}

gboolean
plgi_guint32_to_term(guint32 v, term_t t)
{
  PLGI_debug("    guint32: %u -->  term: 0x%lx", v, t);

  return PL_unify_int64(t, v);
}



                 /*******************************
                 *            gint64            *
                 *******************************/

gboolean
plgi_term_to_gint64(term_t t, gint64 *v)
{ gint64 i;

  if ( PL_get_int64(t, &i) )
  { *v = i;
    PLGI_debug("    term: 0x%lx -->  gint64: %ld", t, *v);
    return TRUE;
  }

  return PL_type_error("64 bit integer", t);
}

gboolean
plgi_gint64_to_term(gint64 v, term_t t)
{
  PLGI_debug("    gint64: %ld -->  term: 0x%lx", v, t);

  return PL_unify_int64(t, v);
}



                 /*******************************
                 *           guint64            *
                 *******************************/

gboolean
plgi_term_to_guint64(term_t t, guint64 *v)
{ gint64 i;

  if ( PL_get_int64(t, &i) )
  { if ( i >= 0 )
    { *v = i;
      PLGI_debug("    term: 0x%lx -->  guint64: %lu", t, *v);
      return TRUE;
    }
  }
  else
  { mpz_t mpz;
    mpz_init(mpz);
    if ( PL_get_mpz(t, mpz) )
    { if ( mpz_cmp_ui(mpz, 0) >= 0 && mpz_cmp_ui(mpz, G_MAXUINT64) <= 0 )
      { *v = mpz_get_ui(mpz);
        mpz_clear(mpz);
        PLGI_debug("    term: 0x%lx -->  guint64: %lu", t, *v);
        return TRUE;
      }
    }
    mpz_clear(mpz);
  }

  return PL_type_error("64 bit unsigned integer", t);
}

gboolean
plgi_guint64_to_term(guint64 v, term_t t)
{
  PLGI_debug("    guint64: %lu -->  term: 0x%lx", v, t);

  if ( v > G_MAXINT64 )
  { mpz_t mpz;
    gint ret;
    mpz_init(mpz);
    mpz_set_ui(mpz, v);
    ret = PL_unify_mpz(t, mpz);
    mpz_clear(mpz);
    return ret;
  }

  return PL_unify_int64(t, v);
}



                 /*******************************
                 *            gshort            *
                 *******************************/

gboolean
plgi_term_to_gshort(term_t t, gshort *v)
{
  return plgi_term_to_gint16(t, v);
}

gboolean
plgi_gshort_to_term(gshort v, term_t t)
{
  return plgi_gint16_to_term(v, t);
}



                 /*******************************
                 *           gushort            *
                 *******************************/

gboolean
plgi_term_to_gushort(term_t t, gushort *v)
{
  return plgi_term_to_guint16(t, v);
}

gboolean
plgi_gushort_to_term(gushort v, term_t t)
{
  return plgi_guint16_to_term(v, t);
}



                 /*******************************
                 *             gint             *
                 *******************************/

gboolean
plgi_term_to_gint(term_t t, gint *v)
{
  return plgi_term_to_gint32(t, v);
}

gboolean
plgi_gint_to_term(gint v, term_t t)
{
  return plgi_gint32_to_term(v, t);
}



                 /*******************************
                 *            guint             *
                 *******************************/

gboolean
plgi_term_to_guint(term_t t, guint *v)
{
  return plgi_term_to_guint32(t, v);
}

gboolean
plgi_guint_to_term(guint v, term_t t)
{
  return plgi_guint32_to_term(v, t);
}



                 /*******************************
                 *            glong             *
                 *******************************/

gboolean
plgi_term_to_glong(term_t t, glong *v)
{
#if SIZEOF_LONG == 8
  return plgi_term_to_gint64(t, v);
#else
  return plgi_term_to_gint32(t, v);
#endif
}

gboolean
plgi_glong_to_term(glong v, term_t t)
{
#if SIZEOF_LONG == 8
  return plgi_gint64_to_term(v, t);
#else
  return plgi_gint32_to_term(v, t);
#endif
}



                 /*******************************
                 *            gulong            *
                 *******************************/

gboolean
plgi_term_to_gulong(term_t t, gulong *v)
{
#if SIZEOF_LONG == 8
  return plgi_term_to_guint64(t, v);
#else
  return plgi_term_to_guint32(t, v);
#endif
}

gboolean
plgi_gulong_to_term(gulong v, term_t t)
{
#if SIZEOF_LONG == 8
  return plgi_guint64_to_term(v, t);
#else
  return plgi_guint32_to_term(v, t);
#endif
}



                 /*******************************
                 *            gfloat            *
                 *******************************/

gboolean
plgi_term_to_gfloat(term_t t, gfloat *v)
{ gdouble f;

  if ( PL_get_float(t, &f) )
  { if ( f >= -G_MAXFLOAT && f <= G_MAXFLOAT )
    { *v = f;
      PLGI_debug("    term: 0x%lx -->  gfloat: %f", t, *v);
      return TRUE;
    }
  }

  return PL_type_error("float", t);
}

gboolean
plgi_gfloat_to_term(gfloat v, term_t t)
{
  PLGI_debug("    gfloat: %f -->  term: 0x%lx", v, t);

  return PL_unify_float(t, v);
}



                 /*******************************
                 *           gdouble            *
                 *******************************/

gboolean
plgi_term_to_gdouble(term_t t, gdouble *v)
{ gdouble f;

  if ( PL_get_float(t, &f) )
  { *v = f;
    PLGI_debug("    term: 0x%lx -->  gdouble: %lf", t, *v);
    return TRUE;
  }

  return PL_type_error("double", t);
}

gboolean
plgi_gdouble_to_term(gdouble v, term_t t)
{
  PLGI_debug("    gdouble: %lf -->  term: 0x%lx", v, t);

  return PL_unify_float(t, v);
}



                 /*******************************
                 *           gunichar           *
                 *******************************/

gboolean
plgi_term_to_gunichar(term_t t, gunichar *v)
{ gint64 i;

  if ( PL_get_int64(t, &i) )
  { gunichar v0;
    if ( i < 0 || i > G_MAXUINT32 )
    { return PL_type_error("unicode character code", t);
    }
    v0 = i;
    if ( !g_unichar_validate(v0) )
    { return PL_domain_error("unicode character code", t);
    }
    *v = v0;
    PLGI_debug("    term: 0x%lx -->  gunichar: %d", t, *v);
    return TRUE;
  }

  return PL_type_error("unicode character code", t);
}

gboolean
plgi_gunichar_to_term(gunichar v, term_t t)
{
  PLGI_debug("    gunichar: %d -->  term: 0x%lx", v, t);

  return PL_unify_integer(t, v);
}



                 /*******************************
                 *            GType             *
                 *******************************/

gboolean
plgi_term_to_gtype(term_t t, GType *v)
{ gchar *s;

  if ( PL_get_atom_chars(t, &s) )
  { GType y = g_type_from_name(s);
    if ( !y )
    { atom_t a;
      PL_get_atom_ex(t, &a);
      { PLGIObjectInfo *object_info;
        if ( plgi_get_object_info(a, &object_info) && object_info->gtype )
        { *v = object_info->gtype;
          PLGI_debug("    term: 0x%lx -->  GType: %ld (%s)",
                     t, *v, g_type_name(*v));
          return TRUE;
        }
      }
      { PLGIInterfaceInfo *interface_info;
        if ( plgi_get_interface_info(a, &interface_info) && interface_info->gtype )
        { *v = interface_info->gtype;
          PLGI_debug("    term: 0x%lx -->  GType: %ld (%s)",
                     t, *v, g_type_name(*v));
          return TRUE;
        }
      }
      { PLGIStructInfo *struct_info;
        if ( plgi_get_struct_info(a, &struct_info) && struct_info->gtype )
        { *v = struct_info->gtype;
          PLGI_debug("    term: 0x%lx -->  GType: %ld (%s)",
                     t, *v, g_type_name(*v));
          return TRUE;
        }
      }
      { PLGIUnionInfo *union_info;
        if ( plgi_get_union_info(a, &union_info) && union_info->gtype )
        { *v = union_info->gtype;
          PLGI_debug("    term: 0x%lx -->  GType: %ld (%s)",
                     t, *v, g_type_name(*v));
          return TRUE;
        }
      }
      { PLGIEnumInfo *enum_info;
        if ( plgi_get_enum_info(a, &enum_info) && enum_info->gtype )
        { *v = enum_info->gtype;
          PLGI_debug("    term: 0x%lx -->  GType: %ld (%s)",
                     t, *v, g_type_name(*v));
          return TRUE;
        }
      }
      return PL_domain_error("GType", t);
    }
    *v = y;
    PLGI_debug("    term: 0x%lx -->  GType: %ld (%s)",
               t, *v, g_type_name(*v));
    return TRUE;
  }

  return PL_type_error("atom", t);
}

gboolean
plgi_gtype_to_term(GType v, term_t t)
{ const gchar *s;

  s = g_type_name(v);

  PLGI_debug("    GType: %ld (%s) -->  term: 0x%lx", v, s, t);

  if ( !s )
  { return plgi_put_null(t);
  }

  return PL_put_atom_chars(t, s);
}



                 /*******************************
                 *             utf8             *
                 *******************************/

gboolean
plgi_term_to_utf8(term_t t, gchar **v)
{ gchar *s;

  if ( PL_get_chars(t, &s, CVT_ATOM|REP_UTF8) )
  { *v = strdup(s);
    PLGI_debug("    term: 0x%lx -->  utf8: %s", t, *v);
    return TRUE;
  }

  return PL_type_error("atom", t);
}

gboolean
plgi_utf8_to_term(gchar *v, term_t t)
{
  PLGI_debug("    utf8: %s -->  term: 0x%lx", v, t);

  if ( !v )
  { return plgi_put_null(t);
  }
  if ( !*v )
  { PL_put_atom_chars(t, v);
    return TRUE;
  }

  return PL_unify_chars(t, PL_ATOM|REP_UTF8, -1, v);
}



                 /*******************************
                 *           filename           *
                 *******************************/

gboolean
plgi_term_to_filename(term_t t, gchar **v)
{ gchar *s;

  if ( PL_get_chars(t, &s, CVT_ATOM|REP_UTF8) )
  { GError *error = NULL;
    *v = g_filename_from_utf8(s, -1, NULL, NULL, &error);
    if ( !*v )
    { plgi_raise_gerror(error);
      g_error_free(error);
      return FALSE;
    }
    PLGI_debug("    term: 0x%lx -->  filename: %s", t, *v);
    return TRUE;
  }

  return PL_type_error("atom", t);
}

gboolean
plgi_filename_to_term(gchar *v, term_t t)
{ gchar *s;

  PLGI_debug("    filename: %s -->  term: 0x%lx", v, t);

  if ( !v )
  { return plgi_put_null(t);
  }
  if ( !*v )
  { GError *error = NULL;
    s = g_filename_to_utf8(v, -1, NULL, NULL, &error);
    if ( !*s )
    { plgi_raise_gerror(error);
      g_error_free(error);
      return FALSE;
    }
    PL_put_atom_chars(t, s);
    return TRUE;
  }

  return PL_unify_chars(t, PL_ATOM|REP_UTF8, -1, v);
}
