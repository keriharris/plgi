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

#define PL_ARITY_AS_SIZE 1
#include <gmp.h>
#include <SWI-Prolog.h>
#include <girepository.h>

#include <stdio.h>
#include <string.h>
#include <assert.h>

#include "config.h"



                /*******************************
                 *           Version           *
                 *******************************/

#define PLGI_VERSION_MAJOR 1
#define PLGI_VERSION_MINOR 0
#define PLGI_VERSION_MICRO 6

#define PLGI_VERSION_ENCODE(major, minor, micro) \
          ( (major * 10000) + (minor * 100) + (micro * 1) )

#define PLGI_VERSION PLGI_VERSION_ENCODE(PLGI_VERSION_MAJOR, \
                                         PLGI_VERSION_MINOR, \
                                         PLGI_VERSION_MICRO)



                /*******************************
                 *            Debug            *
                 *******************************/

gboolean plgi_debug_active(void);
int plgi_exit_debug(int status, void *arg);

#define PLGI_debug_helper(fmt, ...) \
        { fprintf(stderr, "[PLGI] " fmt "%s\n", __VA_ARGS__); \
        }

#define PLGI_debug(...) \
        do { if (plgi_debug_active()) \
             { PLGI_debug_helper(__VA_ARGS__, ""); \
             } \
           } while (0)

#define debug_dashes "--------------------------"
#define debug_n_dashes \
        ( (gint)( strlen(debug_dashes) - strlen(__func__) / 2 ) )

#define PLGI_debug_header \
        PLGI_debug("%.*s <begin>  %s  <begin> %.*s", debug_n_dashes, \
                   debug_dashes, __func__, debug_n_dashes, debug_dashes)

#define PLGI_debug_trailer \
        PLGI_debug("%.*s <end>  %s  <end> %.*s", debug_n_dashes+2, \
                   debug_dashes, __func__, debug_n_dashes+2, debug_dashes)

#define chokeme(message) assert(message & 0)

#define PLGI_WARN_UNUSED G_GNUC_WARN_UNUSED_RESULT



                /*******************************
                 *  Foreign Predicate Wrapper  *
                 *******************************/

#define PLGI_PRED_DEF(fname) \
	foreign_t fname(term_t t0, int arity, void *context)

#define PLGI_PRED_IMPL(fname) \
 \
gboolean fname ## __impl(term_t t0, control_t fctxt); \
 \
foreign_t fname(term_t t0, int arity, void *fctxt) \
{ \
  gint ret; \
  PLGI_debug_header; \
  ret = fname ## __impl(t0, (control_t)fctxt); \
  PLGI_debug("%s retval: %d", __func__, ret); \
  PLGI_debug_trailer; \
  return ret; \
} \
 \
gboolean fname ## __impl(term_t t0, control_t fctxt)

#define PLGI_PRED_REG(name, arity, fname) \
	PL_register_foreign(name, arity, fname, PL_FA_VARARGS)

#define PLGI_PRED_NDET_REG(name, arity, fname) \
	PL_register_foreign(name, arity, fname, PL_FA_VARARGS|PL_FA_NONDETERMINISTIC)

#define FA0 t0
#define FA1 t0+1
#define FA2 t0+2
#define FA3 t0+3
#define FA4 t0+4
#define FA5 t0+5
#define FA6 t0+6
#define FA7 t0+7
#define FA8 t0+8
#define FA9 t0+9

#define FCTXT (control_t)fctxt

PLGI_PRED_DEF(plgi_version);
PLGI_PRED_DEF(plgi_debug);



                /*******************************
                 *      PLGINamespaceInfo      *
                 *******************************/

typedef struct PLGINamespaceInfo
{ atom_t namespace;
  gint n_functions;
  gint n_interfaces;
  gint n_objects;
  gint n_structs;
  gint n_unions;
  gint n_enums;
} PLGINamespaceInfo;

void plgi_register_interface(atom_t namespace, GIInterfaceInfo *interface_info);
void plgi_register_object(atom_t namespace, GIObjectInfo *object_info);
void plgi_register_struct(atom_t namespace, GIStructInfo *struct_info);
void plgi_register_union(atom_t namespace, GIUnionInfo *union_info);
void plgi_register_enum(atom_t namespace, GIEnumInfo *enum_info);
void plgi_register_callback(atom_t namespace, GICallbackInfo *callback_info);

PLGI_PRED_DEF(plgi_load_namespace);
PLGI_PRED_DEF(plgi_load_namespace_from_dir);
PLGI_PRED_DEF(plgi_namespace_deps);
PLGI_PRED_DEF(plgi_current_namespace);

PLGI_PRED_DEF(plgi_registered_namespace);
PLGI_PRED_DEF(plgi_registered_object);
PLGI_PRED_DEF(plgi_registered_interface);
PLGI_PRED_DEF(plgi_registered_struct);
PLGI_PRED_DEF(plgi_registered_union);
PLGI_PRED_DEF(plgi_registered_enum);
PLGI_PRED_DEF(plgi_registered_callback);

gboolean plgi_get_namespace_info(atom_t name, PLGINamespaceInfo **info);
gboolean plgi_cache_namespace_info(PLGINamespaceInfo *info);
PLGINamespaceInfo* plgi_namespace_info_iter(int *idx);



                /*******************************
                 *         PLGIArgInfo         *
                 *******************************/

typedef enum
{ PLGI_ARG_MAY_BE_NULL         = 1 << 0,
  PLGI_ARG_IS_POINTER          = 1 << 1,
  PLGI_ARG_IS_CALLER_ALLOCATES = 1 << 2,
  PLGI_ARG_IS_CLOSURE          = 1 << 3,
  PLGI_ARG_IS_TOPLEVEL         = 1 << 4
} PLGIArgFlags;

typedef struct PLGIArgTypeInfo
{ GITypeTag type_tag;
  GIDirection direction;
  GITransfer transfer;
  PLGIArgFlags flags;
} PLGIArgInfo;

typedef struct PLGIArgCache
{ guint id;
  GSList *elements;
} PLGIArgCache;

void cache_args_metadata(GITypeInfo *type_info,
                         GIDirection direction,
                         GITransfer transfer,
                         GIScopeType scope,
                         gint arg_pos,
                         gint closure_pos,
                         gint destroy_pos,
                         atom_t namespace,
                         PLGIArgInfo **arg_info);

gboolean plgi_term_to_arg(term_t t,
                          PLGIArgInfo *arg_info,
                          PLGIArgCache *arg_cache,
                          GIArgument *arg) PLGI_WARN_UNUSED;

gboolean plgi_arg_to_term(GIArgument *arg,
                          PLGIArgInfo *arg_info,
                          term_t t) PLGI_WARN_UNUSED;

void plgi_ffi_arg_to_gi_arg(gpointer ffiarg,
                            PLGIArgInfo *arg_info,
                            GIArgument *gi_arg);

void plgi_gi_arg_to_ffi_arg(GIArgument *gi_arg,
                            PLGIArgInfo *arg_info,
                            gpointer ffiarg);

void plgi_gvalue_to_arg(GValue *gvalue, PLGIArgInfo *arg_info, GIArgument *arg);
void plgi_arg_to_gvalue(GIArgument *arg, PLGIArgInfo *arg_info, GValue *gvalue);

gboolean plgi_alloc_arg(GIArgument *arg, PLGIArgInfo *arg_info) PLGI_WARN_UNUSED;
void plgi_dealloc_arg(GIArgument *arg, PLGIArgInfo *arg_info);
void plgi_dealloc_arg_full(GIArgument *arg, PLGIArgInfo *arg_info);

gsize plgi_arg_size(PLGIArgInfo *type_info);



                /*******************************
                 *        PLGIArgCache         *
                 *******************************/

guint plgi_cache_id(void);

void plgi_cache_arg(GIArgument *arg, PLGIArgInfo *arg_info, PLGIArgCache *arg_cache);
void plgi_dealloc_arg_cache(PLGIArgCache *arg_cache, gboolean free_everything);

void plgi_cache_in_async_store(gpointer data, void (*free_fn));
void plgi_dealloc_async_cache(void);



                /*******************************
                 *       PLGIBaseArgInfo       *
                 *******************************/
/*
typedef enum
{ //PLGI_ARG_MAY_BE_NULL         = 1 << 0,
  //PLGI_ARG_IS_RETURN_VALUE     = 1 << 1
  //PLGI_ARG_IS_CLOSURE_DATA
  //PLGI_ARG_IS_DESTROY_NOTIFY
  //PLGI_ARG_IS_CALLER_ALLOCATES = 1 << 3
  //PLGI_ARG_IS_OPTIONAL
  //PLGI_ARG_IS_RETURN_VALUE
  //PLGI_ARG_IS_SKIP
} PLGIBaseArgFlags;
*/
typedef struct PLGIBaseArgInfo
{ gint         in_pos;
  gint         out_pos;
  GIDirection  direction;
  GITransfer   transfer;
  //PLGIBaseArgFlags flags;
  PLGIArgInfo *arg_info;
} PLGIBaseArgInfo;



                 /*******************************
                 *       PLGICallableInfo       *
                 *******************************/

typedef enum
{ PLGI_FUNC_CAN_THROW_GERROR    = 1 << 0,
  //PLGI_FUNC_CALLER_OWNS
  PLGI_FUNC_IS_METHOD           = 1 << 1
  //PLGI_FUNC_CAN_RETURN_NULL
  //PLGI_SKIP_RETURN
  //PLGI_FUNC_CONTAINER_IS_OBJECT = 1 << 2,
  //PLGI_FUNC_CONTAINER_IS_STRUCT = 1 << 3
} PLGICallableFlags;

typedef struct PLGICallableInfo
{ GICallableInfo   *info;
  atom_t            namespace;
  atom_t            name;
  PLGIBaseArgInfo  *args_info;
  gint              n_args;
  gint              n_in_args;
  gint              n_out_args;
  gint              n_pl_args;
  gint              arg_mask;
  PLGICallableFlags flags;
} PLGICallableInfo;

foreign_t plgi_marshaller__va(term_t t0, int arity, void *context);

gboolean plgi_get_callable_info(atom_t name, PLGICallableInfo **info);
gboolean plgi_cache_callable_info(PLGICallableInfo *info);

void cache_callable_args_metadata(PLGICallableInfo *func_info, atom_t namespace);



                 /*******************************
                 *            Types             *
                 *******************************/

gboolean plgi_get_null(term_t t, gpointer *v) PLGI_WARN_UNUSED;
gboolean plgi_put_null(term_t t) PLGI_WARN_UNUSED;

gboolean plgi_term_to_gboolean(term_t t, gboolean *v) PLGI_WARN_UNUSED;
gboolean plgi_gboolean_to_term(gboolean v, term_t t) PLGI_WARN_UNUSED;

gboolean plgi_term_to_gint8(term_t t, gint8 *v) PLGI_WARN_UNUSED;
gboolean plgi_gint8_to_term(gint8 v, term_t t) PLGI_WARN_UNUSED;

gboolean plgi_term_to_guint8(term_t t, guint8 *v) PLGI_WARN_UNUSED;
gboolean plgi_guint8_to_term(guint8 v, term_t t) PLGI_WARN_UNUSED;

gboolean plgi_term_to_gint16(term_t t, gint16 *v) PLGI_WARN_UNUSED;
gboolean plgi_gint16_to_term(gint16 v, term_t t) PLGI_WARN_UNUSED;

gboolean plgi_term_to_guint16(term_t t, guint16 *v) PLGI_WARN_UNUSED;
gboolean plgi_guint16_to_term(guint16 v, term_t t) PLGI_WARN_UNUSED;

gboolean plgi_term_to_gint32(term_t t, gint32 *v) PLGI_WARN_UNUSED;
gboolean plgi_gint32_to_term(gint32 v, term_t t) PLGI_WARN_UNUSED;

gboolean plgi_term_to_guint32(term_t t, guint32 *v) PLGI_WARN_UNUSED;
gboolean plgi_guint32_to_term(guint32 v, term_t t) PLGI_WARN_UNUSED;

gboolean plgi_term_to_gint64(term_t t, gint64 *v) PLGI_WARN_UNUSED;
gboolean plgi_gint64_to_term(gint64 v, term_t t) PLGI_WARN_UNUSED;

gboolean plgi_term_to_guint64(term_t t, guint64 *v) PLGI_WARN_UNUSED;
gboolean plgi_guint64_to_term(guint64 v, term_t t) PLGI_WARN_UNUSED;

gboolean plgi_term_to_gshort(term_t t, gshort *v) PLGI_WARN_UNUSED;
gboolean plgi_gshort_to_term(gshort v, term_t t) PLGI_WARN_UNUSED;

gboolean plgi_term_to_gushort(term_t t, gushort *v) PLGI_WARN_UNUSED;
gboolean plgi_gushort_to_term(gushort v, term_t t) PLGI_WARN_UNUSED;

gboolean plgi_term_to_gint(term_t t, gint *v) PLGI_WARN_UNUSED;
gboolean plgi_gint_to_term(gint v, term_t t) PLGI_WARN_UNUSED;

gboolean plgi_term_to_guint(term_t t, guint *v) PLGI_WARN_UNUSED;
gboolean plgi_guint_to_term(guint v, term_t t) PLGI_WARN_UNUSED;

gboolean plgi_term_to_glong(term_t t, glong *v) PLGI_WARN_UNUSED;
gboolean plgi_glong_to_term(glong v, term_t t) PLGI_WARN_UNUSED;

gboolean plgi_term_to_gulong(term_t t, gulong *v) PLGI_WARN_UNUSED;
gboolean plgi_gulong_to_term(gulong v, term_t t) PLGI_WARN_UNUSED;

gboolean plgi_term_to_gfloat(term_t t, gfloat *v) PLGI_WARN_UNUSED;
gboolean plgi_gfloat_to_term(gfloat v, term_t t) PLGI_WARN_UNUSED;

gboolean plgi_term_to_gdouble(term_t t, gdouble *v) PLGI_WARN_UNUSED;
gboolean plgi_gdouble_to_term(gdouble v, term_t t) PLGI_WARN_UNUSED;

gboolean plgi_term_to_gunichar(term_t t, gunichar *v) PLGI_WARN_UNUSED;
gboolean plgi_gunichar_to_term(gunichar v, term_t t) PLGI_WARN_UNUSED;

gboolean plgi_term_to_gtype(term_t t, GType *v) PLGI_WARN_UNUSED;
gboolean plgi_gtype_to_term(GType v, term_t t) PLGI_WARN_UNUSED;

gboolean plgi_term_to_utf8(term_t t, gchar **v) PLGI_WARN_UNUSED;
gboolean plgi_utf8_to_term(gchar *v, term_t t) PLGI_WARN_UNUSED;

gboolean plgi_term_to_filename(term_t t, gchar **v) PLGI_WARN_UNUSED;
gboolean plgi_filename_to_term(gchar *v, term_t t) PLGI_WARN_UNUSED;



                 /*******************************
                 *            Arrays            *
                 *******************************/

typedef enum
{ PLGI_ARRAY_IS_FIXED_SIZED     = 1 << 0,
  PLGI_ARRAY_HAS_LENGTH_ARG     = 1 << 1,
  PLGI_ARRAY_IS_ZERO_TERMINATED = 1 << 2
} PLGIArrayFlags;

typedef struct PLGIArrayArgInfo
{ PLGIArgInfo     arg_info;
  GIArrayType     array_type;
  gint            length_arg_offset;
  gint            fixed_size;
  PLGIArrayFlags  flags;
  PLGIArgInfo    *element_info;
} PLGIArrayArgInfo;

gboolean plgi_term_to_array(term_t t,
                            PLGIArrayArgInfo *array_info,
                            PLGIArgCache *arg_cache,
                            GIArgument *arg) PLGI_WARN_UNUSED;

gboolean plgi_array_to_term(GIArgument *arg,
                            PLGIArrayArgInfo *array_info,
                            term_t t) PLGI_WARN_UNUSED;

gboolean plgi_alloc_array(GIArgument *arg,
                          PLGIArrayArgInfo *array_info) PLGI_WARN_UNUSED;

void plgi_dealloc_array_full(GIArgument *arg, PLGIArrayArgInfo *array_info);
void plgi_dealloc_array_container(GIArgument *arg, PLGIArrayArgInfo *array_info);



                 /*******************************
                 *        Abstract Args         *
                 *******************************/

typedef enum
{ PLGI_ABSTRACT_ARG_INTERFACE,
  PLGI_ABSTRACT_ARG_OBJECT,
  PLGI_ABSTRACT_ARG_STRUCT,
  PLGI_ABSTRACT_ARG_UNION,
  PLGI_ABSTRACT_ARG_GSTRV,
  PLGI_ABSTRACT_ARG_GBYTES,
  PLGI_ABSTRACT_ARG_ENUM,
  PLGI_ABSTRACT_ARG_FLAG,
  PLGI_ABSTRACT_ARG_CALLBACK
} PLGIAbstractArgType;

typedef struct PLGIAbstractArgInfo
{ PLGIArgInfo         arg_info;
  PLGIAbstractArgType abstract_arg_type;
} PLGIAbstractArgInfo;

gsize plgi_abstract_arg_size(PLGIAbstractArgInfo* abstract_arg_info);



                 /*******************************
                 *            Blobs             *
                 *******************************/

typedef enum
{ PLGI_BLOB_GOBJECT,
  PLGI_BLOB_GPARAMSPEC,
  PLGI_BLOB_GVARIANT,
  PLGI_BLOB_SIMPLE,
  PLGI_BLOB_BOXED,
  PLGI_BLOB_TRANSIENT,
  PLGI_BLOB_FOREIGN,
  PLGI_BLOB_OPAQUE,
  PLGI_BLOB_UNTYPED
} PLGIBlobType;

typedef struct PLGIBlob
{ gint         magic;
  gpointer     data;
  atom_t       name;
  GType        gtype;
  PLGIBlobType blob_type;
} PLGIBlob;

gboolean plgi_get_blob(term_t t, PLGIBlob **blob) PLGI_WARN_UNUSED;

gboolean plgi_put_blob(PLGIBlobType blob_type,
                       GType        gtype,
                       atom_t       name,
                       gpointer     data,
                       term_t       t,
                       int         *is_new) PLGI_WARN_UNUSED;

gboolean plgi_term_to_gpointer(term_t       t,
                               PLGIArgInfo *arg_info,
                               gpointer    *v) PLGI_WARN_UNUSED;

gboolean plgi_gpointer_to_term(gpointer     v,
                               PLGIArgInfo *arg_info,
                               term_t       t) PLGI_WARN_UNUSED;

gboolean plgi_blob_is_a(term_t object, term_t name);



                 /*******************************
                 *          Interfaces          *
                 *******************************/

typedef struct PLGIPropertyInfo
{ atom_t       name;
  PLGIArgInfo *arg_info;
} PLGIPropertyInfo;

typedef struct PLGIInterfaceInfo
{ GIInterfaceInfo  *info;
  atom_t            namespace;
  atom_t            name;
  GType             gtype;
  gint              n_properties;
  PLGIPropertyInfo *properties_info;
} PLGIInterfaceInfo;

typedef struct PLGIInterfaceArgInfo
{ PLGIAbstractArgInfo  abstract_arg_info;
  PLGIInterfaceInfo   *interface_info;
} PLGIInterfaceArgInfo;

gboolean plgi_get_interface_info(atom_t name, PLGIInterfaceInfo **info);
gboolean plgi_cache_interface_info(PLGIInterfaceInfo *info);

gboolean plgi_term_to_interface(term_t t,
                                PLGIInterfaceArgInfo *interface_info,
                                gpointer *interface)  PLGI_WARN_UNUSED;

gboolean plgi_interface_to_term(gpointer interface,
                                PLGIInterfaceArgInfo *interface_info,
                                term_t t) PLGI_WARN_UNUSED;

gboolean plgi_interface_get_blob(term_t t, PLGIBlob **blob) PLGI_WARN_UNUSED;



                 /*******************************
                 *           Objects            *
                 *******************************/

/* FIXME: add name or PLGIObjectInfo to PLGIObject */

typedef struct PLGIObjectInfo
{ GIObjectInfo       *info;
  atom_t              namespace;
  atom_t              name;
  atom_t              parent_name;
  GType               gtype;
  gint                n_interfaces;
  PLGIInterfaceInfo **interfaces_info;
  gint                n_properties;
  PLGIPropertyInfo   *properties_info;
} PLGIObjectInfo;

typedef struct PLGIObjectArgInfo
{ PLGIAbstractArgInfo  abstract_arg_info;
  PLGIObjectInfo      *object_info;
} PLGIObjectArgInfo;
/*
typedef struct PLGIObject
{ gint magic;
  GObject *gobject;
  GType gtype;
} PLGIObject;
*/
gboolean plgi_get_object_info(atom_t name, PLGIObjectInfo **info);
gboolean plgi_cache_object_info(PLGIObjectInfo *info);

gboolean plgi_term_to_object(term_t t,
                             PLGIObjectArgInfo *object_info,
                             gpointer *object) PLGI_WARN_UNUSED;

gboolean plgi_object_to_term(gpointer object,
                             PLGIObjectArgInfo *object_info,
                             term_t t) PLGI_WARN_UNUSED;

gboolean plgi_object_get_blob(term_t t, PLGIBlob **blob) PLGI_WARN_UNUSED;

PLGI_PRED_DEF(plgi_object_new);
PLGI_PRED_DEF(plgi_object_get_property);
PLGI_PRED_DEF(plgi_object_set_property);



                 /*******************************
                 *           Structs            *
                 *******************************/

typedef struct PLGIFieldInfo
{ atom_t            name;
  gint              size;
  gint              offset;
  GIFieldInfoFlags  flags;
  PLGIArgInfo      *arg_info;
} PLGIFieldInfo;

typedef struct PLGIStructInfo
{ GIStructInfo  *info;
  atom_t         namespace;
  atom_t         name;
  GType          gtype;
  gsize          size;
  gint           n_fields;
  PLGIFieldInfo *fields_info;
} PLGIStructInfo;

typedef struct PLGIStructArgInfo
{ PLGIAbstractArgInfo  abstract_arg_info;
  PLGIStructInfo      *struct_info;
} PLGIStructArgInfo;

gboolean plgi_get_struct_info(atom_t name, PLGIStructInfo **info);
gboolean plgi_cache_struct_info(PLGIStructInfo *info);

gboolean plgi_term_to_struct(term_t t,
                             PLGIStructArgInfo *struct_info,
                             gpointer *struct_) PLGI_WARN_UNUSED;

gboolean plgi_struct_to_term(gpointer struct_,
                             PLGIStructArgInfo *struct_info,
                             term_t t) PLGI_WARN_UNUSED;

gboolean plgi_alloc_struct(gpointer *struct_,
                           PLGIStructArgInfo *struct_info) PLGI_WARN_UNUSED;

gsize plgi_struct_size(PLGIStructArgInfo* struct_info);

PLGI_PRED_DEF(plgi_struct_new);
PLGI_PRED_DEF(plgi_struct_get_field);
PLGI_PRED_DEF(plgi_struct_set_field);
PLGI_PRED_DEF(plgi_struct_term);



                 /*******************************
                 *            Unions            *
                 *******************************/

typedef struct PLGIUnionInfo
{ GIUnionInfo   *info;
  atom_t         namespace;
  atom_t         name;
  GType          gtype;
  gsize          size;
  gint           n_fields;
  PLGIFieldInfo *fields_info;
} PLGIUnionInfo;

typedef struct PLGIUnionArgInfo
{ PLGIAbstractArgInfo  abstract_arg_info;
  PLGIUnionInfo       *union_info;
} PLGIUnionArgInfo;

gboolean plgi_get_union_info(atom_t name, PLGIUnionInfo **info);
gboolean plgi_cache_union_info(PLGIUnionInfo *info);

gboolean plgi_term_to_union(term_t t,
                            PLGIUnionArgInfo *union_info,
                            gpointer *union_) PLGI_WARN_UNUSED;

gboolean plgi_union_to_term(gpointer union_,
                            PLGIUnionArgInfo *union_info,
                            term_t t) PLGI_WARN_UNUSED;

gboolean plgi_alloc_union(gpointer *union_,
                          PLGIUnionArgInfo *union_info) PLGI_WARN_UNUSED;

gsize plgi_union_size(PLGIUnionArgInfo* union_info);

PLGI_PRED_DEF(plgi_union_new);
PLGI_PRED_DEF(plgi_union_get_field);
PLGI_PRED_DEF(plgi_union_set_field);



                 /*******************************
                 *            GStrv             *
                 *******************************/

gboolean plgi_term_to_gstrv(term_t t, GStrv *gstrv) PLGI_WARN_UNUSED;
gboolean plgi_gstrv_to_term(GStrv gstrv, term_t t) PLGI_WARN_UNUSED;

void plgi_dealloc_gstrv(GStrv gstrv);



                 /*******************************
                 *            GBytes            *
                 *******************************/

gboolean plgi_term_to_gbytes(term_t t, GBytes **gbytes) PLGI_WARN_UNUSED;
gboolean plgi_gbytes_to_term(GBytes *gbytes, term_t t) PLGI_WARN_UNUSED;

void plgi_dealloc_gbytes_full(GBytes *gbytes);
void plgi_dealloc_gbytes_container(GBytes *gbytes);



                 /*******************************
                 *         GList/GSList         *
                 *******************************/

typedef struct PLGIListArgInfo
{ PLGIArgInfo  arg_info;
  PLGIArgInfo *element_info;
} PLGIListArgInfo;

gboolean plgi_term_to_glist(term_t t,
                            PLGIListArgInfo *list_info,
                            PLGIArgCache *arg_cache,
                            GList **glist) PLGI_WARN_UNUSED;

gboolean plgi_glist_to_term(GList *glist,
                            PLGIListArgInfo *list_info,
                            term_t t) PLGI_WARN_UNUSED;

gboolean plgi_alloc_glist(GList **glist,
                          PLGIListArgInfo *list_info) PLGI_WARN_UNUSED;

void plgi_dealloc_glist_full(GList *glist, PLGIListArgInfo *list_info);
void plgi_dealloc_glist_container(GList *glist, PLGIListArgInfo *list_info);

gboolean plgi_term_to_gslist(term_t t,
                             PLGIListArgInfo *list_info,
                             PLGIArgCache *arg_cache,
                             GSList **gslist) PLGI_WARN_UNUSED;

gboolean plgi_gslist_to_term(GSList *gslist,
                             PLGIListArgInfo *list_info,
                             term_t t) PLGI_WARN_UNUSED;

gboolean plgi_alloc_gslist(GSList **gslist,
                           PLGIListArgInfo *list_info) PLGI_WARN_UNUSED;

void plgi_dealloc_gslist_full(GSList *gslist, PLGIListArgInfo *list_info);
void plgi_dealloc_gslist_container(GSList *gslist, PLGIListArgInfo *list_info);



                 /*******************************
                 *          GHashTable          *
                 *******************************/

typedef struct PLGIHashTableArgInfo
{ PLGIArgInfo  arg_info;
  PLGIArgInfo *key_info;
  PLGIArgInfo *value_info;
} PLGIHashTableArgInfo;

gboolean plgi_term_to_ghashtable(term_t t,
                                 PLGIHashTableArgInfo *hashtable_info,
                                 PLGIArgCache *arg_cache,
                                 GHashTable **hash_table) PLGI_WARN_UNUSED;

gboolean plgi_ghashtable_to_term(GHashTable *hash_table,
                                 PLGIHashTableArgInfo *hashtable_info,
                                 term_t t) PLGI_WARN_UNUSED;

gboolean plgi_alloc_ghashtable(GHashTable **hash_table,
                               PLGIHashTableArgInfo *hashtable_info) PLGI_WARN_UNUSED;

void plgi_dealloc_ghashtable(GHashTable *hash_table,
                             PLGIHashTableArgInfo *hashtable_info);



                 /*******************************
                 *         Enums/Flags          *
                 *******************************/

typedef struct PLGIValueInfo
{ atom_t name;
  gint64 value;
} PLGIValueInfo;

typedef struct PLGIEnumInfo
{ GIEnumInfo    *info;
  atom_t         namespace;
  atom_t         name;
  GITypeTag      type_tag;
  GType          gtype;
  gint           n_values;
  PLGIValueInfo *values_info;
} PLGIEnumInfo;

typedef struct PLGIEnumArgInfo
{ PLGIAbstractArgInfo  abstract_arg_info;
  PLGIEnumInfo        *enum_info;
} PLGIEnumArgInfo;

gboolean plgi_get_enum_info(atom_t name, PLGIEnumInfo **info);
gboolean plgi_cache_enum_info(PLGIEnumInfo *info);
gboolean plgi_get_enum_value(atom_t name, gint64 *enum_value);
gboolean plgi_get_flags_value(term_t flags, gint64 *flags_value);

gboolean plgi_term_to_enum(term_t t,
                           PLGIEnumArgInfo *enum_info,
                           gint64 *enum_) PLGI_WARN_UNUSED;

gboolean plgi_enum_to_term(gint64 enum_,
                           PLGIEnumArgInfo *enum_info,
                           term_t t) PLGI_WARN_UNUSED;

gboolean plgi_term_to_flag(term_t t,
                           PLGIEnumArgInfo *enum_info,
                           gint64 *flag) PLGI_WARN_UNUSED;

gboolean plgi_flag_to_term(gint64 flag,
                           PLGIEnumArgInfo *enum_info,
                           term_t t) PLGI_WARN_UNUSED;

gsize plgi_enum_size(PLGIEnumArgInfo* enum_info);

PLGI_PRED_DEF(plgi_enum_value);



                 /*******************************
                 *          Callbacks           *
                 *******************************/

typedef struct PLGICallbackArgInfo
{ PLGIAbstractArgInfo  arg_info;
  PLGICallableInfo    *callback_info;
  GIScopeType          scope;
  gint                 closure_offset;
  gint                 destroy_offset;
} PLGICallbackArgInfo;

gboolean plgi_term_to_callback(term_t t,
                               PLGICallbackArgInfo *callback_info,
                               GIArgument *arg) PLGI_WARN_UNUSED;

gboolean plgi_term_to_callback_functor(term_t t,
                                       module_t *module,
                                       functor_t *functor) PLGI_WARN_UNUSED;

gboolean plgi_term_to_closure_data(term_t t, gpointer *v) PLGI_WARN_UNUSED;
gboolean plgi_closure_data_to_term(gpointer v, term_t t) PLGI_WARN_UNUSED;

void     plgi_dealloc_callback(gpointer data);

PLGI_PRED_DEF(plgi_signal_connect_data);
PLGI_PRED_DEF(plgi_signal_emit);



                 /*******************************
                 *            Errors            *
                 *******************************/

gboolean plgi_gerror_to_term(GError *error, term_t t) PLGI_WARN_UNUSED;

gboolean plgi_raise_error(gchar *message);
gboolean plgi_raise_error__va(gchar *fmt, ...);
gboolean plgi_raise_gerror(GError *error);



                /*******************************
                 *          Overrides          *
                 *******************************/

PLGI_PRED_DEF(plgi_g_closure_invoke);
PLGI_PRED_DEF(plgi_g_idle_add);
PLGI_PRED_DEF(plgi_g_is_object);
PLGI_PRED_DEF(plgi_g_is_value);
PLGI_PRED_DEF(plgi_g_object_type);
PLGI_PRED_DEF(plgi_g_param_spec_value_type);
PLGI_PRED_DEF(plgi_g_value_get_boxed);
PLGI_PRED_DEF(plgi_g_value_holds);
PLGI_PRED_DEF(plgi_g_value_init);
PLGI_PRED_DEF(plgi_g_value_set_boxed);
