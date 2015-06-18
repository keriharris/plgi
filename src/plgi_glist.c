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
                 *          GList Arg           *
                 *******************************/

gboolean
plgi_term_to_glist(term_t            t,
                   PLGIListArgInfo  *list_arg_info,
                   PLGIArgCache     *arg_cache,
                   GList           **glist)
{
  term_t list = PL_copy_term_ref(t);
  term_t head = PL_new_term_ref();
  GList *l = NULL;

  if ( PL_skip_list(list, 0, NULL) != PL_LIST )
  { return PL_type_error("list", t);
  }

  while ( PL_get_list(list, head, list) )
  { GIArgument *element_arg;

    l = g_list_prepend(l, NULL);
    element_arg = (GIArgument*)&l->data;

    if ( !plgi_term_to_arg(head, list_arg_info->element_info, arg_cache, element_arg) )
    { g_list_free(l);
      return FALSE;
    }
  }
  l = g_list_reverse(l);

  if ( !PL_get_nil(list) )
  { g_list_free(l);
    return FALSE;
  }

  *glist = l;

  return TRUE;
}


gboolean
plgi_glist_to_term(GList           *glist,
                   PLGIListArgInfo *list_arg_info,
                   term_t           t)
{
  term_t list = PL_copy_term_ref(t);
  term_t head = PL_new_term_ref();
  GList *l;

  if ( !glist )
  { return PL_put_nil(t);
  }

  for ( l = glist; l; l = g_list_next(l) )
  { GIArgument *element_arg;
    term_t a = PL_new_term_ref();

    element_arg = (GIArgument*)&l->data;

    if ( !plgi_arg_to_term(element_arg, list_arg_info->element_info, a) )
    { return FALSE;
    }

    if ( !(PL_unify_list(list, head, list) &&
           PL_unify(head, a)) )
    { return FALSE;
    }
  }

  return PL_unify_nil(list);
}


gboolean
plgi_alloc_glist(GList           **glist,
                 PLGIListArgInfo  *list_arg_info)
{
  *glist = NULL;

  return TRUE;
}


void
plgi_dealloc_glist_full(GList           *glist,
                        PLGIListArgInfo *list_arg_info)
{
  GList *l;

  for ( l = glist; l; l = g_list_next(l) )
  { plgi_dealloc_arg_full((gpointer)&l->data, list_arg_info->element_info);
  }

  g_list_free(glist);
}


void
plgi_dealloc_glist_container(GList           *glist,
                             PLGIListArgInfo *list_arg_info)
{
  g_list_free(glist);
}



                 /*******************************
                 *          GSList Arg          *
                 *******************************/

gboolean
plgi_term_to_gslist(term_t            t,
                    PLGIListArgInfo  *list_arg_info,
                    PLGIArgCache     *arg_cache,
                    GSList          **gslist)
{
  term_t list = PL_copy_term_ref(t);
  term_t head = PL_new_term_ref();
  GSList *l = NULL;

  if ( PL_skip_list(list, 0, NULL) != PL_LIST )
  { return PL_type_error("list", t);
  }

  while ( PL_get_list(list, head, list) )
  { GIArgument *element_arg;

    l = g_slist_prepend(l, NULL);
    element_arg = (GIArgument*)&l->data;

    if ( !plgi_term_to_arg(head, list_arg_info->element_info, arg_cache, element_arg) )
    { g_slist_free(l);
      return FALSE;
    }
  }
  l = g_slist_reverse(l);

  if ( !PL_get_nil(list) )
  { g_slist_free(l);
    return FALSE;
  }

  *gslist = l;

  return TRUE;
}


gboolean
plgi_gslist_to_term(GSList          *gslist,
                    PLGIListArgInfo *list_arg_info,
                    term_t           t)
{
  term_t list = PL_copy_term_ref(t);
  term_t head = PL_new_term_ref();
  GSList *l;

  if ( !gslist )
  { return PL_put_nil(t);
  }

  for ( l = gslist; l; l = g_slist_next(l) )
  { GIArgument *element_arg;
    term_t a = PL_new_term_ref();

    element_arg = (GIArgument*)&l->data;

    if ( !plgi_arg_to_term(element_arg, list_arg_info->element_info, a) )
    { return FALSE;
    }

    if ( !(PL_unify_list(list, head, list) &&
           PL_unify(head, a)) )
    { return FALSE;
    }
  }

  return PL_unify_nil(list);
}


gboolean
plgi_alloc_gslist(GSList          **gslist,
                  PLGIListArgInfo  *list_arg_info)
{
  *gslist = NULL;

  return TRUE;
}


void
plgi_dealloc_gslist_full(GSList          *gslist,
                         PLGIListArgInfo *list_arg_info)
{
  GSList *l;

  for ( l = gslist; l; l = g_slist_next(l) )
  { plgi_dealloc_arg_full((gpointer)&l->data, list_arg_info->element_info);
  }

  g_slist_free(gslist);
}


void
plgi_dealloc_gslist_container(GSList          *gslist,
                              PLGIListArgInfo *list_arg_info)
{
  g_slist_free(gslist);
}
