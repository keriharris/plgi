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
                 *     Internal Prototypes     *
                 *******************************/

/* C Array */
gboolean term_to_c_array(term_t t, gsize len, PLGIArrayArgInfo *array_info, PLGIArgCache *arg_cache, GIArgument *arg) PLGI_WARN_UNUSED;
gboolean c_array_to_term(GIArgument *arg, PLGIArrayArgInfo *array_info, term_t t) PLGI_WARN_UNUSED;
gboolean plgi_alloc_c_array(GIArgument *arg, PLGIArrayArgInfo *array_info) PLGI_WARN_UNUSED;

/* GArray */
gboolean plgi_term_to_garray(term_t t, PLGIArrayArgInfo *array_info, PLGIArgCache *arg_cache, GIArgument *arg) PLGI_WARN_UNUSED;
gboolean plgi_garray_to_term(GIArgument *arg, PLGIArrayArgInfo *array_info, term_t t) PLGI_WARN_UNUSED;
gboolean plgi_alloc_garray(GIArgument *arg, PLGIArrayArgInfo *array_info) PLGI_WARN_UNUSED;

/* GPtrArray */
gboolean plgi_term_to_gptrarray(term_t t, PLGIArrayArgInfo *array_info, PLGIArgCache *arg_cache, GIArgument *arg) PLGI_WARN_UNUSED;
gboolean plgi_gptrarray_to_term(GIArgument *arg, PLGIArrayArgInfo *array_info, term_t t) PLGI_WARN_UNUSED;
gboolean plgi_alloc_gptrarray(GIArgument *arg, PLGIArrayArgInfo *array_info) PLGI_WARN_UNUSED;

/* GByteArray */
gboolean plgi_term_to_gbytearray(term_t t, PLGIArrayArgInfo *array_info, PLGIArgCache *arg_cache, GIArgument *arg) PLGI_WARN_UNUSED;
gboolean plgi_gbytearray_to_term(GIArgument *arg, PLGIArrayArgInfo *array_info, term_t t) PLGI_WARN_UNUSED;
gboolean plgi_alloc_gbytearray(GIArgument *arg, PLGIArrayArgInfo *array_info) PLGI_WARN_UNUSED;



                 /*******************************
                 *           C Array            *
                 *******************************/

gboolean
plgi_c_value_mask(gsize element_size, guint64 *mask)
{
  switch ( element_size )
  {
    case sizeof(guint8):
    { *mask = 0xFF;
      return TRUE;
    }
    case sizeof(guint16):
    { *mask = 0xFFFF;
      return TRUE;
    }
    case sizeof(guint32):
    { *mask = 0xFFFFFFFF;
      return TRUE;
    }
    case sizeof(guint64):
    { *mask = 0xFFFFFFFFFFFFFFFF;
      return TRUE;
    }

    default:
    { plgi_raise_error__va("Arrays are only supported for element sizes of "
                           "%ld,%ld,%ld,%ld bytes. Received array with element "
                           " size of %d bytes.",
                           sizeof(guint8), sizeof(guint16), sizeof(guint32),
                           sizeof(guint64), element_size);
      return FALSE;
    }
  }
}

gboolean
term_to_c_array(term_t            t,
                gsize             len,
                PLGIArrayArgInfo *array_arg_info,
                PLGIArgCache     *arg_cache,
                GIArgument       *arg)
{
  term_t list = PL_copy_term_ref(t);
  term_t head = PL_new_term_ref();
  gpointer l;
  gsize element_size;
  gint i = 0;

  if ( array_arg_info->flags & PLGI_ARRAY_IS_FIXED_SIZED &&
       len != array_arg_info->fixed_size )
  { return PL_type_error("fixed-size list", t);
  }

  if ( array_arg_info->flags & PLGI_ARRAY_HAS_LENGTH_ARG )
  { GIArgument *length_arg;

    length_arg = arg + array_arg_info->length_arg_offset;
    length_arg->v_size = len;
  }

  if ( array_arg_info->flags & PLGI_ARRAY_IS_ZERO_TERMINATED )
  { len++;
  }

  element_size = plgi_arg_size(array_arg_info->element_info);
  l = g_malloc0_n(len, element_size);

  PLGI_debug("    term: 0x%lx  --->  array[0x%lx*%ld]: %p",
             t, element_size, len, l);

  while ( PL_get_list(list, head, list) )
  { if ( !plgi_term_to_arg(head, array_arg_info->element_info, arg_cache, l + i*element_size) )
    { g_free(l);
      return FALSE;
    }
    i++;
  }

  arg->v_pointer = l;

  return TRUE;
}


gboolean
plgi_c_array_to_term(GIArgument       *arg,
                     PLGIArrayArgInfo *array_arg_info,
                     term_t            t)
{
  PLGIArgInfo *arg_info = (PLGIArgInfo*)array_arg_info;
  term_t list = PL_copy_term_ref(t);
  term_t head = PL_new_term_ref();
  gsize len, element_size;
  gpointer v;

  element_size = plgi_arg_size(array_arg_info->element_info);

  if ( array_arg_info->flags & PLGI_ARRAY_IS_FIXED_SIZED )
  { len = array_arg_info->fixed_size;
  }

  else if ( array_arg_info->flags & PLGI_ARRAY_HAS_LENGTH_ARG )
  { GIArgument *length_arg;
    length_arg = arg + array_arg_info->length_arg_offset;
    len = (gint)length_arg->v_size;
  }

  else if ( array_arg_info->flags & PLGI_ARRAY_IS_ZERO_TERMINATED )
  { len = -1;
  }

  else
  { plgi_raise_error("Array received without length information. Cannot decode.");
    return FALSE;
  }

  if ( arg_info->flags & PLGI_ARG_IS_POINTER )
  { v = arg->v_pointer;
  }
  else
  { v = arg;
  }

  PLGI_debug("    array[0x%lx*%ld]: %p  --->  term: 0x%lx",
             element_size, len, v, t);

  if ( len != -1 )
  { gint i;

    for ( i = 0; i < len; i++ )
    { term_t a = PL_new_term_ref();

      if ( !plgi_arg_to_term(v + i*element_size, array_arg_info->element_info, a) )
      { return FALSE;
      }

      if ( !(PL_unify_list(list, head, list) &&
             PL_unify(head, a)) )
      { return FALSE;
      }
    }
  }

  else /* zero-terminated array */
  { guint64 mask;
    gint i = 0;

    if ( !plgi_c_value_mask(element_size, &mask) )
    { return FALSE;
    }

    while ( v && (*(guint64*)v & mask) )
    { term_t a = PL_new_term_ref();

      if ( !plgi_arg_to_term((GIArgument*)v, array_arg_info->element_info, a) )
      { return FALSE;
      }

      if ( !(PL_unify_list(list, head, list) &&
             PL_unify(head, a)) )
      { return FALSE;
      }

      i++;
      v = arg->v_pointer + i*element_size;
    }
  }

  if ( !PL_unify_nil(list) )
  { return FALSE;
  }

  return TRUE;
}


gboolean
plgi_alloc_c_array(GIArgument       *arg,
                   PLGIArrayArgInfo *array_arg_info)
{
  gsize len, element_size;
  gpointer array;

  element_size = plgi_arg_size(array_arg_info->element_info);

  if ( array_arg_info->flags & PLGI_ARRAY_IS_FIXED_SIZED )
  { len = array_arg_info->fixed_size;
  }

  else if ( array_arg_info->flags & PLGI_ARRAY_HAS_LENGTH_ARG )
  { GIArgument *length_arg;

    length_arg = arg + array_arg_info->length_arg_offset;
    len = length_arg->v_size;
  }

  else
  { g_assert_not_reached();
  }

  array = g_malloc0_n(len, element_size);
  arg->v_pointer = array;

  return TRUE;
}


void
plgi_dealloc_c_array_full(GIArgument       *arg,
                          PLGIArrayArgInfo *array_arg_info)
{
  gpointer array = arg->v_pointer;
  gsize len, element_size;

  if ( array_arg_info->flags & PLGI_ARRAY_IS_FIXED_SIZED )
  { len = array_arg_info->fixed_size;
  }

  else if ( array_arg_info->flags & PLGI_ARRAY_HAS_LENGTH_ARG )
  { GIArgument *length_arg;

    length_arg = arg + array_arg_info->length_arg_offset;
    len = length_arg->v_size;
  }

  else if ( array_arg_info->flags & PLGI_ARRAY_IS_ZERO_TERMINATED )
  { len = -1;
  }

  else
  { return;
  }

  element_size = plgi_arg_size(array_arg_info->element_info);

  PLGI_debug("    dealloc array[0x%lx*%ld]: %p",
             element_size, len, array);

  if ( len != -1 )
  { gpointer v = array;
    gint i;

    for ( i = 0; i < len; i++ )
    { plgi_dealloc_arg_full(v + i*element_size, array_arg_info->element_info);
    }
  }

  else /* zero-terminated array */
  { guint64* v = array;
    guint64 mask;
    gint i = 0;

    if ( !plgi_c_value_mask(element_size, &mask) )
    { return;
    }

    while ( v && (*v & mask) )
    { plgi_dealloc_arg_full((gpointer)v, array_arg_info->element_info);
      i++;
      v = array + i*element_size;
    }
  }

  g_free(array);
}


void
plgi_dealloc_c_array_container(GIArgument       *arg,
                               PLGIArrayArgInfo *array_arg_info)
{
  gpointer array = arg->v_pointer;

  PLGI_debug("    dealloc array[]: %p", array);

  g_free(array);
}



                 /*******************************
                 *            GArray            *
                 *******************************/

int plgi_garray_element(GArray *array, gint i, void **element)
{
  guint element_size = g_array_get_element_size(array);
  void *v;

  switch ( element_size )
  {
    case sizeof(guint8):
    { v = (guint8*)(uintptr_t)g_array_index(array, guint8, i);
      break;
    }
    case sizeof(guint16):
    { v = (guint16*)(uintptr_t)g_array_index(array, guint16, i);
      break;
    }
    case sizeof(guint32):
    { v = (guint32*)(uintptr_t)g_array_index(array, guint32, i);
      break;
    }
    case sizeof(guint64):
    { v = (guint64*)(uintptr_t)g_array_index(array, guint64, i);
      break;
    }
    default:
    { plgi_raise_error__va("GArray only supported for element sizes of "
                           "%ld,%ld,%ld,%ld bytes. Received GArray with "
                           "element size of %d bytes.",
                           sizeof(guint8), sizeof(guint16), sizeof(guint32),
                           sizeof(guint64), element_size);
      return FALSE;
    }
  }

  *element = v;

  return TRUE;
}


gboolean
term_to_garray(term_t            t,
               gsize             len,
               PLGIArrayArgInfo *array_arg_info,
               PLGIArgCache     *arg_cache,
               GIArgument       *arg)
{
  GArray *array;
  term_t list = PL_copy_term_ref(t);
  term_t head = PL_new_term_ref();
  gpointer l;
  gsize element_size;
  gint i = 0;

  element_size = plgi_arg_size(array_arg_info->element_info);

  array = g_array_sized_new(TRUE, TRUE, element_size, len);
  array = g_array_set_size(array, len);
  l = array->data;

  PLGI_debug("    term: 0x%lx  --->  GArray: %p", t, array);

  while ( PL_get_list(list, head, list) )
  {
    if ( !plgi_term_to_arg(head, array_arg_info->element_info, arg_cache, l + i*element_size) )
    { g_array_free(array, TRUE);
      return FALSE;
    }
    i++;
  }

  arg->v_pointer = array;

  return TRUE;
}


gboolean
plgi_garray_to_term(GIArgument       *arg,
                    PLGIArrayArgInfo *array_arg_info,
                    term_t            t)
{
  GArray *array = arg->v_pointer;
  term_t list = PL_copy_term_ref(t);
  term_t head = PL_new_term_ref();
  guint element_size;
  gint i;

  PLGI_debug("    GArray: %p  --->  term: 0x%lx", array, t);

  element_size = g_array_get_element_size(array);

  for ( i = 0; i < array->len; i++ )
  { term_t a = PL_new_term_ref();
    gpointer v;

    v = array->data + i*element_size;

    if ( !plgi_arg_to_term(v, array_arg_info->element_info, a) )
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


gboolean
plgi_alloc_garray(GIArgument       *arg,
                  PLGIArrayArgInfo *array_arg_info)
{
  GArray *array;
  gsize element_size;

  element_size = plgi_arg_size(array_arg_info->element_info);
  array = g_array_new(FALSE, TRUE, element_size);
  arg->v_pointer = array;

  PLGI_debug("    alloc GArray: %p", array);

  return TRUE;
}


void
plgi_dealloc_garray_full(GArray           *array,
                         PLGIArrayArgInfo *array_arg_info)
{
  gpointer element;
  gint i;

  PLGI_debug("    dealloc GArray: %p", array);

  for ( i = 0 ; i < array->len ; i++ )
  { if ( plgi_garray_element(array, i, &element) )
    { plgi_dealloc_arg_full((gpointer)&element, array_arg_info->element_info);
    }
  }
  g_array_unref(array);
}


void
plgi_dealloc_garray_container(GArray           *array,
                              PLGIArrayArgInfo *array_arg_info)
{
  PLGI_debug("    dealloc GArray: %p", array);

  g_array_unref(array);
}



                 /*******************************
                 *          GPtrArray           *
                 *******************************/

gboolean
term_to_gptrarray(term_t            t,
                  gsize             len,
                  PLGIArrayArgInfo *array_arg_info,
                  PLGIArgCache     *arg_cache,
                  GIArgument       *arg)
{
  GPtrArray *array;
  term_t list = PL_copy_term_ref(t);
  term_t head = PL_new_term_ref();

  array = g_ptr_array_sized_new(len);

  PLGI_debug("    term: 0x%lx  --->  GPtrArray: %p", t, array);

  while ( PL_get_list(list, head, list) )
  { gpointer element;
    if ( !plgi_term_to_arg(head, array_arg_info->element_info, arg_cache, (GIArgument*)&element) )
    { g_ptr_array_free(array, TRUE);
      return FALSE;
    }
    g_ptr_array_add(array, element);
  }

  arg->v_pointer = array;

  return TRUE;
}


gboolean
plgi_gptrarray_to_term(GIArgument       *arg,
                       PLGIArrayArgInfo *array_arg_info,
                       term_t            t)
{
  GPtrArray *array = arg->v_pointer;
  term_t list = PL_copy_term_ref(t);
  term_t head = PL_new_term_ref();
  gint i;

  PLGI_debug("    GPtrArray: %p  --->  term: 0x%lx", array, t);

  for ( i = 0; i < array->len; i++ )
  { term_t a = PL_new_term_ref();
    gpointer v = g_ptr_array_index(array, i);

    if ( !plgi_arg_to_term((GIArgument*)&v, array_arg_info->element_info, a) )
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


gboolean
plgi_alloc_gptrarray(GIArgument       *arg,
                     PLGIArrayArgInfo *array_arg_info)
{

  GPtrArray *array;

  array = g_ptr_array_new();
  arg->v_pointer = array;

  PLGI_debug("    alloc GPtrArray: %p", array);

  return TRUE;
}


void
plgi_dealloc_gptrarray_full(GPtrArray        *array,
                            PLGIArrayArgInfo *array_arg_info)
{
  gpointer element;
  gint i;

  PLGI_debug("    dealloc GPtrArray: %p", array);

  for ( i = 0 ; i < array->len ; i++ )
  { element = g_ptr_array_index(array, i);
    if ( element )
    { plgi_dealloc_arg_full((gpointer)&element, array_arg_info->element_info);
    }
  }

  g_ptr_array_unref(array);
}


void
plgi_dealloc_gptrarray_container(GPtrArray        *array,
                                 PLGIArrayArgInfo *array_arg_info)
{
  PLGI_debug("    dealloc GPtrArray: %p", array);

  g_ptr_array_unref(array);
}



                 /*******************************
                 *          GByteArray          *
                 *******************************/

gboolean
term_to_gbytearray(term_t            t,
                   gsize             len,
                   PLGIArrayArgInfo *array_arg_info,
                   PLGIArgCache     *arg_cache,
                   GIArgument       *arg)
{
  GByteArray *array;
  term_t list = PL_copy_term_ref(t);
  term_t head = PL_new_term_ref();

  array = g_byte_array_sized_new(len);

  PLGI_debug("    term: 0x%lx  --->  GByteArray: %p", t, array);

  while ( PL_get_list(list, head, list) )
  { guint8 element;
    if ( !plgi_term_to_arg(head, array_arg_info->element_info, arg_cache, (GIArgument*)&element) )
    { g_byte_array_free(array, TRUE);
      return FALSE;
    }
    g_byte_array_append(array, &element, 1);
  }

  arg->v_pointer = array;

  return TRUE;
}


gboolean
plgi_gbytearray_to_term(GIArgument       *arg,
                        PLGIArrayArgInfo *array_arg_info,
                        term_t            t)
{
  GByteArray *array = arg->v_pointer;
  term_t list = PL_copy_term_ref(t);
  term_t head = PL_new_term_ref();
  gint i;

  PLGI_debug("    GByteArray: %p  --->  term: 0x%lx", array, t);

  for ( i = 0; i < array->len; i++ )
  { term_t a = PL_new_term_ref();
    guint8 v = array->data[i];

    if ( !plgi_arg_to_term((GIArgument*)&v, array_arg_info->element_info, a) )
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


gboolean
plgi_alloc_gbytearray(GIArgument       *arg,
                      PLGIArrayArgInfo *array_arg_info)
{

  GByteArray *array;

  array = g_byte_array_new();
  arg->v_pointer = array;

  PLGI_debug("    alloc GByteArray: %p", array);

  return TRUE;
}


void
plgi_dealloc_gbytearray_full(GByteArray       *array,
                             PLGIArrayArgInfo *array_arg_info)
{
  PLGI_debug("    dealloc GByteArray: %p", array);

  g_byte_array_unref(array);
}


void
plgi_dealloc_gbytearray_container(GByteArray       *array,
                                  PLGIArrayArgInfo *array_arg_info)
{
  PLGI_debug("    dealloc GByteArray: %p", array);

  g_byte_array_unref(array);
}



                 /*******************************
                 *          Array Arg           *
                 *******************************/

gboolean
plgi_term_to_array(term_t            t,
                   PLGIArrayArgInfo *array_arg_info,
                   PLGIArgCache     *arg_cache,
                   GIArgument       *arg)
{
  term_t list = PL_copy_term_ref(t);
  gsize len;

  if ( PL_skip_list(list, 0, &len) != PL_LIST )
  { return PL_type_error("list", t);
  }

  switch ( array_arg_info->array_type )
  {
    case GI_ARRAY_TYPE_C:
    { return term_to_c_array(t, len, array_arg_info, arg_cache, arg);
    }
    case GI_ARRAY_TYPE_ARRAY:
    { return term_to_garray(t, len, array_arg_info, arg_cache, arg);
    }
    case GI_ARRAY_TYPE_PTR_ARRAY:
    { return term_to_gptrarray(t, len, array_arg_info, arg_cache, arg);
    }
    case GI_ARRAY_TYPE_BYTE_ARRAY:
    { return term_to_gbytearray(t, len, array_arg_info, arg_cache, arg);
    }
    default:
    { g_assert_not_reached();
    }
  }

  return TRUE;
}


gboolean
plgi_array_to_term(GIArgument       *arg,
                   PLGIArrayArgInfo *array_arg_info,
                   term_t            t)
{
  switch ( array_arg_info->array_type )
  {
    case GI_ARRAY_TYPE_C:
    { return plgi_c_array_to_term(arg, array_arg_info, t);
    }
    case GI_ARRAY_TYPE_ARRAY:
    { return plgi_garray_to_term(arg, array_arg_info, t);
    }
    case GI_ARRAY_TYPE_PTR_ARRAY:
    { return plgi_gptrarray_to_term(arg, array_arg_info, t);
    }
    case GI_ARRAY_TYPE_BYTE_ARRAY:
    { return plgi_gbytearray_to_term(arg, array_arg_info, t);
    }
    default:
    { g_assert_not_reached();
    }
  }

  return TRUE;
}


gboolean
plgi_alloc_array(GIArgument       *arg,
                 PLGIArrayArgInfo *array_arg_info)
{
  switch ( array_arg_info->array_type )
  {
    case GI_ARRAY_TYPE_C:
    { return plgi_alloc_c_array(arg, array_arg_info);
    }
    case GI_ARRAY_TYPE_ARRAY:
    { return plgi_alloc_garray(arg, array_arg_info);
    }
    case GI_ARRAY_TYPE_PTR_ARRAY:
    { return plgi_alloc_gptrarray(arg, array_arg_info);
    }
    case GI_ARRAY_TYPE_BYTE_ARRAY:
    { return plgi_alloc_gbytearray(arg, array_arg_info);
    }
    default:
    { g_assert_not_reached();
    }
  }
}


void
plgi_dealloc_array_full(GIArgument       *arg,
                        PLGIArrayArgInfo *array_arg_info)
{
  switch ( array_arg_info->array_type )
  {
    case GI_ARRAY_TYPE_C:
    { plgi_dealloc_c_array_full(arg, array_arg_info);
      break;
    }
    case GI_ARRAY_TYPE_ARRAY:
    { plgi_dealloc_garray_full(arg->v_pointer, array_arg_info);
      break;
    }
    case GI_ARRAY_TYPE_PTR_ARRAY:
    { plgi_dealloc_gptrarray_full(arg->v_pointer, array_arg_info);
      break;
    }
    case GI_ARRAY_TYPE_BYTE_ARRAY:
    { plgi_dealloc_gbytearray_full(arg->v_pointer, array_arg_info);
      break;
    }
    default:
    { g_assert_not_reached();
    }
  }
}


void
plgi_dealloc_array_container(GIArgument       *arg,
                             PLGIArrayArgInfo *array_arg_info)
{
  switch ( array_arg_info->array_type )
  {
    case GI_ARRAY_TYPE_C:
    { plgi_dealloc_c_array_container(arg, array_arg_info);
      break;
    }
    case GI_ARRAY_TYPE_ARRAY:
    { plgi_dealloc_garray_container(arg->v_pointer, array_arg_info);
      break;
    }
    case GI_ARRAY_TYPE_PTR_ARRAY:
    { plgi_dealloc_gptrarray_container(arg->v_pointer, array_arg_info);
      break;
    }
    case GI_ARRAY_TYPE_BYTE_ARRAY:
    { plgi_dealloc_gbytearray_container(arg->v_pointer, array_arg_info);
      break;
    }
    default:
    { g_assert_not_reached();
    }
  }
}
