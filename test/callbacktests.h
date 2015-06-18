#ifndef __CALLBACKTESTS_H__
#define __CALLBACKTESTS_H__

#include <glib-object.h>


typedef enum
{
  CALLBACK_TESTS_ENUM_VALUE1,
  CALLBACK_TESTS_ENUM_VALUE2,
  CALLBACK_TESTS_ENUM_VALUE3
} CallbackTestsEnum;

typedef enum
{
  CALLBACK_TESTS_FLAGS_VALUE1 = 1 << 0,
  CALLBACK_TESTS_FLAGS_VALUE2 = 1 << 1,
  CALLBACK_TESTS_FLAGS_VALUE3 = 1 << 2
} CallbackTestsFlags;

typedef struct CallbackTestsStruct {
    gint32 x;
} CallbackTestsStruct;


/**
 * CallbackTestsCallbackScopeCall:
 */
typedef void (* CallbackTestsCallbackScopeCall) (void);

void
callback_tests_scope_call (CallbackTestsCallbackScopeCall callback);
void
callback_tests_scope_call_multiple_invocations (CallbackTestsCallbackScopeCall callback);

/**
 * CallbackTestsCallbackScopeAsync:
 */
typedef void (* CallbackTestsCallbackScopeAsync) (void);

void
callback_tests_scope_async (CallbackTestsCallbackScopeAsync callback);
void
callback_tests_invoke_async_callback (void);

/**
 * CallbackTestsCallbackScopeNotified:
 * @data: (closure)
 */
typedef void (* CallbackTestsCallbackScopeNotified) (gpointer data);

void
callback_tests_scope_notified (CallbackTestsCallbackScopeNotified callback, gpointer data, GDestroyNotify destroy);
void
callback_tests_invoke_notified_callback (void);
void
callback_tests_destroy_notified_callback (void);

/**
 * CallbackTestsCallbackArityOne:
 */
typedef void (* CallbackTestsCallbackArityOne) (gchar *string);

void
callback_tests_arity_one (CallbackTestsCallbackArityOne callback);

/**
 * CallbackTestsCallbackVoid:
 */
typedef void (* CallbackTestsCallbackVoid) (void);

void
callback_tests_nullfunc (CallbackTestsCallbackVoid callback);

/**
 * CallbackTestsCallbackReturnBoolean:
 * Returns: (transfer none):
 */
typedef gboolean (* CallbackTestsCallbackReturnBoolean) (void);

gboolean
callback_tests_return_gboolean (CallbackTestsCallbackReturnBoolean callback);


/**
 * CallbackTestsCallbackReturnInt8:
 * Returns: (transfer none):
 */
typedef gint8 (* CallbackTestsCallbackReturnInt8) (void);

gint8
callback_tests_return_gint8 (CallbackTestsCallbackReturnInt8 callback);


/**
 * CallbackTestsCallbackReturnUint8:
 * Returns: (transfer none):
 */
typedef guint8 (* CallbackTestsCallbackReturnUint8) (void);

guint8
callback_tests_return_guint8 (CallbackTestsCallbackReturnUint8 callback);


/**
 * CallbackTestsCallbackReturnInt16:
 * Returns: (transfer none):
 */
typedef gint16 (* CallbackTestsCallbackReturnInt16) (void);

gint16
callback_tests_return_gint16 (CallbackTestsCallbackReturnInt16 callback);


/**
 * CallbackTestsCallbackReturnUint16:
 * Returns: (transfer none):
 */
typedef guint16 (* CallbackTestsCallbackReturnUint16) (void);

guint16
callback_tests_return_guint16 (CallbackTestsCallbackReturnUint16 callback);


/**
 * CallbackTestsCallbackReturnInt32:
 * Returns: (transfer none):
 */
typedef gint32 (* CallbackTestsCallbackReturnInt32) (void);

gint32
callback_tests_return_gint32 (CallbackTestsCallbackReturnInt32 callback);


/**
 * CallbackTestsCallbackReturnUin32:
 * Returns: (transfer none):
 */
typedef guint32 (* CallbackTestsCallbackReturnUint32) (void);

guint32
callback_tests_return_guint32 (CallbackTestsCallbackReturnUint32 callback);


/**
 * CallbackTestsCallbackReturnInt64:
 * Returns: (transfer none):
 */
typedef gint64 (* CallbackTestsCallbackReturnInt64) (void);

gint64
callback_tests_return_gint64 (CallbackTestsCallbackReturnInt64 callback);


/**
 * CallbackTestsCallbackReturnUint64:
 * Returns: (transfer none):
 */
typedef guint64 (* CallbackTestsCallbackReturnUint64) (void);

guint64
callback_tests_return_guint64 (CallbackTestsCallbackReturnUint64 callback);


/**
 * CallbackTestsCallbackReturnChar:
 * Returns: (transfer none):
 */
typedef gchar (* CallbackTestsCallbackReturnChar) (void);

gchar
callback_tests_return_gchar (CallbackTestsCallbackReturnChar callback);


/**
 * CallbackTestsCallbackReturnShort:
 * Returns: (transfer none):
 */
typedef gshort (* CallbackTestsCallbackReturnShort) (void);

gshort
callback_tests_return_gshort (CallbackTestsCallbackReturnShort callback);


/**
 * CallbackTestsCallbackReturnUshort:
 * Returns: (transfer none):
 */
typedef gushort (* CallbackTestsCallbackReturnUshort) (void);

gushort
callback_tests_return_gushort (CallbackTestsCallbackReturnUshort callback);


/**
 * CallbackTestsCallbackReturnInt:
 * Returns: (transfer none):
 */
typedef gint (* CallbackTestsCallbackReturnInt) (void);

gint
callback_tests_return_gint (CallbackTestsCallbackReturnInt callback);


/**
 * CallbackTestsCallbackReturnUint:
 * Returns: (transfer none):
 */
typedef guint (* CallbackTestsCallbackReturnUint) (void);

guint
callback_tests_return_guint (CallbackTestsCallbackReturnUint callback);


/**
 * CallbackTestsCallbackReturnLong:
 * Returns: (transfer none):
 */
typedef glong (* CallbackTestsCallbackReturnLong) (void);

glong
callback_tests_return_glong (CallbackTestsCallbackReturnLong callback);


/**
 * CallbackTestsCallbackReturnUlong:
 * Returns: (transfer none):
 */
typedef gulong (* CallbackTestsCallbackReturnUlong) (void);

gulong
callback_tests_return_gulong (CallbackTestsCallbackReturnUlong callback);


/**
 * CallbackTestsCallbackReturnSize:
 * Returns: (transfer none):
 */
typedef gsize (* CallbackTestsCallbackReturnSize) (void);

gsize
callback_tests_return_gsize (CallbackTestsCallbackReturnSize callback);


/**
 * CallbackTestsCallbackReturnSsize:
 * Returns: (transfer none):
 */
typedef gssize (* CallbackTestsCallbackReturnSsize) (void);

gssize
callback_tests_return_gssize (CallbackTestsCallbackReturnSsize callback);


/**
 * CallbackTestsCallbackReturnIntPtr:
 * Returns: (transfer none):
 */
typedef gintptr (* CallbackTestsCallbackReturnIntPtr) (void);

gintptr
callback_tests_return_gintptr (CallbackTestsCallbackReturnIntPtr callback);


/**
 * CallbackTestsCallbackReturnUintPtr:
 * Returns: (transfer none):
 */
typedef guintptr (* CallbackTestsCallbackReturnUintPtr) (void);

guintptr
callback_tests_return_guintptr (CallbackTestsCallbackReturnUintPtr callback);


/**
 * CallbackTestsCallbackReturnFloat:
 * Returns: (transfer none):
 */
typedef gfloat (* CallbackTestsCallbackReturnFloat) (void);

gfloat
callback_tests_return_gfloat (CallbackTestsCallbackReturnFloat callback);


/**
 * CallbackTestsCallbackReturnDouble:
 * Returns: (transfer none):
 */
typedef gdouble (* CallbackTestsCallbackReturnDouble) (void);

gdouble
callback_tests_return_gdouble (CallbackTestsCallbackReturnDouble callback);


/**
 * CallbackTestsCallbackReturnUnichar:
 * Returns: (transfer none):
 */
typedef gunichar (* CallbackTestsCallbackReturnUnichar) (void);

gunichar
callback_tests_return_gunichar (CallbackTestsCallbackReturnUnichar callback);


/**
 * CallbackTestsCallbackReturnGType:
 * Returns: (transfer none):
 */
typedef GType (* CallbackTestsCallbackReturnGType) (void);

GType
callback_tests_return_GType (CallbackTestsCallbackReturnGType callback);


/**
 * CallbackTestsCallbackReturnString:
 * Returns: (transfer none):
 */
typedef gchar* (* CallbackTestsCallbackReturnString) (void);

const gchar*
callback_tests_return_utf8 (CallbackTestsCallbackReturnString callback);


/**
 * CallbackTestsCallbackReturnFilename:
 * Returns: (transfer none):
 */
typedef gchar* (* CallbackTestsCallbackReturnFilename) (void);

const gchar*
callback_tests_return_filename (CallbackTestsCallbackReturnFilename callback);


/**
 * CallbackTestsCallbackReturnStruct:
 * Returns: (transfer none):
 */
typedef CallbackTestsStruct* (* CallbackTestsCallbackReturnStruct) (void);

CallbackTestsStruct*
callback_tests_return_struct (CallbackTestsCallbackReturnStruct callback);


/**
 * CallbackTestsCallbackReturnEnum:
 * Returns: (transfer none):
 */
typedef CallbackTestsEnum (* CallbackTestsCallbackReturnEnum) (void);

CallbackTestsEnum
callback_tests_return_enum (CallbackTestsCallbackReturnEnum callback);


/**
 * CallbackTestsCallbackReturnFlags:
 * Returns: (transfer none):
 */
typedef CallbackTestsFlags (* CallbackTestsCallbackReturnFlags) (void);

CallbackTestsFlags
callback_tests_return_flags (CallbackTestsCallbackReturnFlags callback);


/**
 * CallbackTestsCallbackReturnArray:
 * @len: (out) (transfer none):
 * Returns: (array length=len) (transfer none):
 */
typedef gint* (* CallbackTestsCallbackReturnArray) (gint* len);

gint*
callback_tests_return_array (CallbackTestsCallbackReturnArray callback, gint* len);


/**
 * CallbackTestsCallbackReturnList:
 * Returns: (element-type gint) (transfer none):
 */
typedef GList* (* CallbackTestsCallbackReturnList) (void);

GList*
callback_tests_return_list (CallbackTestsCallbackReturnList callback);


/**
 * CallbackTestsCallbackReturnTransferNone:
 * Returns: (transfer none):
 */
typedef const gchar* (* CallbackTestsCallbackReturnTransferNone) (void);

const gchar*
callback_tests_return_transfer_none (CallbackTestsCallbackReturnTransferNone callback);


/**
 * CallbackTestsCallbackReturnTransferFull:
 * Returns: (transfer full):
 */
typedef gchar* (* CallbackTestsCallbackReturnTransferFull) (void);

gchar*
callback_tests_return_transfer_full (CallbackTestsCallbackReturnTransferFull callback);


/**
 * CallbackTestsCallbackReturnTransferContainer:
 * @len: (out):
 * Returns: (array length=len) (transfer container):
 */
typedef gchar** (* CallbackTestsCallbackReturnTransferContainer) (gint* len);

gchar**
callback_tests_return_transfer_container (CallbackTestsCallbackReturnTransferContainer callback, gint* len);


/**
 * CallbackTestsCallbackInBoolean:
 */
typedef void (* CallbackTestsCallbackInBoolean) (gboolean a);

void
callback_tests_inparam_gboolean (CallbackTestsCallbackInBoolean callback, gboolean arg0);


/**
 * CallbackTestsCallbackInInt8:
 */
typedef void (* CallbackTestsCallbackInInt8) (gint8 a);

void
callback_tests_inparam_gint8 (CallbackTestsCallbackInInt8 callback, gint8 arg0);


/**
 * CallbackTestsCallbackInUint8:
 */
typedef void (* CallbackTestsCallbackInUint8) (guint8 a);

void
callback_tests_inparam_guint8 (CallbackTestsCallbackInUint8 callback, guint8 arg0);


/**
 * CallbackTestsCallbackInInt16:
 */
typedef void (* CallbackTestsCallbackInInt16) (gint16 a);

void
callback_tests_inparam_gint16 (CallbackTestsCallbackInInt16 callback, gint16 arg0);


/**
 * CallbackTestsCallbackInUint16:
 */
typedef void (* CallbackTestsCallbackInUint16) (guint16 a);

void
callback_tests_inparam_guint16 (CallbackTestsCallbackInUint16 callback, guint16 arg0);


/**
 * CallbackTestsCallbackInInt32:
 */
typedef void (* CallbackTestsCallbackInInt32) (gint32 a);

void
callback_tests_inparam_gint32 (CallbackTestsCallbackInInt32 callback, gint32 arg0);


/**
 * CallbackTestsCallbackInUint32:
 */
typedef void (* CallbackTestsCallbackInUint32) (guint32 a);

void
callback_tests_inparam_guint32 (CallbackTestsCallbackInUint32 callback, guint32 arg0);


/**
 * CallbackTestsCallbackInInt64:
 */
typedef void (* CallbackTestsCallbackInInt64) (gint64 a);

void
callback_tests_inparam_gint64 (CallbackTestsCallbackInInt64 callback, gint64 arg0);


/**
 * CallbackTestsCallbackInUint64:
 */
typedef void (* CallbackTestsCallbackInUint64) (guint64 a);

void
callback_tests_inparam_guint64 (CallbackTestsCallbackInUint64 callback, guint64 arg0);


/**
 * CallbackTestsCallbackInChar:
 */
typedef void (* CallbackTestsCallbackInChar) (gchar a);

void
callback_tests_inparam_gchar (CallbackTestsCallbackInChar callback, gchar arg0);


/**
 * CallbackTestsCallbackInShort:
 */
typedef void (* CallbackTestsCallbackInShort) (gshort a);

void
callback_tests_inparam_gshort (CallbackTestsCallbackInShort callback, gshort arg0);


/**
 * CallbackTestsCallbackInUshort:
 */
typedef void (* CallbackTestsCallbackInUshort) (gushort a);

void
callback_tests_inparam_gushort (CallbackTestsCallbackInUshort callback, gushort arg0);


/**
 * CallbackTestsCallbackInInt:
 */
typedef void (* CallbackTestsCallbackInInt) (gint a);

void
callback_tests_inparam_gint (CallbackTestsCallbackInInt callback, gint arg0);


/**
 * CallbackTestsCallbackInUint:
 */
typedef void (* CallbackTestsCallbackInUint) (guint a);

void
callback_tests_inparam_guint (CallbackTestsCallbackInUint callback, guint arg0);


/**
 * CallbackTestsCallbackInLong:
 */
typedef void (* CallbackTestsCallbackInLong) (glong a);

void
callback_tests_inparam_glong (CallbackTestsCallbackInLong callback, glong arg0);


/**
 * CallbackTestsCallbackInUlong:
 */
typedef void (* CallbackTestsCallbackInUlong) (gulong a);

void
callback_tests_inparam_gulong (CallbackTestsCallbackInUlong callback, gulong arg0);


/**
 * CallbackTestsCallbackInSize:
 */
typedef void (* CallbackTestsCallbackInSize) (gsize a);

void
callback_tests_inparam_gsize (CallbackTestsCallbackInSize callback, gsize arg0);


/**
 * CallbackTestsCallbackInSsize:
 */
typedef void (* CallbackTestsCallbackInSsize) (gssize a);

void
callback_tests_inparam_gssize (CallbackTestsCallbackInSsize callback, gssize arg0);


/**
 * CallbackTestsCallbackInIntPtr:
 */
typedef void (* CallbackTestsCallbackInIntPtr) (gintptr a);

void
callback_tests_inparam_gintptr (CallbackTestsCallbackInIntPtr callback, gintptr arg0);


/**
 * CallbackTestsCallbackInUintPtr:
 */
typedef void (* CallbackTestsCallbackInUintPtr) (guintptr a);

void
callback_tests_inparam_guintptr (CallbackTestsCallbackInUintPtr callback, guintptr arg0);


/**
 * CallbackTestsCallbackInFloat:
 */
typedef void (* CallbackTestsCallbackInFloat) (gfloat a);

void
callback_tests_inparam_gfloat (CallbackTestsCallbackInFloat callback, gfloat arg0);


/**
 * CallbackTestsCallbackInDouble:
 */
typedef void (* CallbackTestsCallbackInDouble) (gdouble a);

void
callback_tests_inparam_gdouble (CallbackTestsCallbackInDouble callback, gdouble arg0);


/**
 * CallbackTestsCallbackInUnichar:
 */
typedef void (* CallbackTestsCallbackInUnichar) (gunichar a);

void
callback_tests_inparam_gunichar (CallbackTestsCallbackInUnichar callback, gunichar arg0);


/**
 * CallbackTestsCallbackInGType:
 */
typedef void (* CallbackTestsCallbackInGType) (GType a);

void
callback_tests_inparam_GType (CallbackTestsCallbackInGType callback, GType arg0);


/**
 * CallbackTestsCallbackInString:
 */
typedef void (* CallbackTestsCallbackInString) (const gchar* a);

void
callback_tests_inparam_utf8 (CallbackTestsCallbackInString callback, const gchar* arg0);


/**
 * CallbackTestsCallbackInFilename:
 */
typedef void (* CallbackTestsCallbackInFilename) (const gchar* a);

void
callback_tests_inparam_filename (CallbackTestsCallbackInFilename callback, const gchar* arg0);


/**
 * CallbackTestsCallbackInStruct:
 */
typedef void (* CallbackTestsCallbackInStruct) (CallbackTestsStruct* a);

void
callback_tests_inparam_struct (CallbackTestsCallbackInStruct callback, CallbackTestsStruct* arg0);


/**
 * CallbackTestsCallbackInEnum:
 */
typedef void (* CallbackTestsCallbackInEnum) (CallbackTestsEnum a);

void
callback_tests_inparam_enum (CallbackTestsCallbackInEnum callback, CallbackTestsEnum arg0);


/**
 * CallbackTestsCallbackInFlags:
 */
typedef void (* CallbackTestsCallbackInFlags) (CallbackTestsFlags a);

void
callback_tests_inparam_flags (CallbackTestsCallbackInFlags callback, CallbackTestsFlags arg0);


/**
 * CallbackTestsCallbackInArray:
 * @a: (array length=len):
 * @len: :
 */
typedef void (* CallbackTestsCallbackInArray) (gint* a, gint len);

void
callback_tests_inparam_array (CallbackTestsCallbackInArray callback, gint* arg0, gint len);


/**
 * CallbackTestsCallbackInList:
 * @a: (element-type gint):
 */
typedef void (* CallbackTestsCallbackInList) (GList* a);

void
callback_tests_inparam_list (CallbackTestsCallbackInList callback, GList* arg0);


/**
 * CallbackTestsCallbackInTransferNone:
 * @a: (transfer none):
 */
typedef void (* CallbackTestsCallbackInTransferNone) (const gchar* a);

void
callback_tests_inparam_transfer_none (CallbackTestsCallbackInTransferNone callback, const gchar* arg0);


/**
 * CallbackTestsCallbackInTransferFull:
 * @a: (transfer full):
 */
typedef void (* CallbackTestsCallbackInTransferFull) (gchar* a);

void
callback_tests_inparam_transfer_full (CallbackTestsCallbackInTransferFull callback, gchar* arg0);


/**
 * CallbackTestsCallbackInTransferContainer:
 * @a: (array length=len) (transfer container):
 * @len: :
 */
typedef void (* CallbackTestsCallbackInTransferContainer) (gchar** a, gint len);

void
callback_tests_inparam_transfer_container (CallbackTestsCallbackInTransferContainer callback, gchar** arg0, gint len);


/**
 * CallbackTestsCallbackOutBoolean:
 * @a: (out) (transfer none):
 */
typedef void (* CallbackTestsCallbackOutBoolean) (gboolean* a);

void
callback_tests_outparam_gboolean (CallbackTestsCallbackOutBoolean callback, gboolean* arg0);


/**
 * CallbackTestsCallbackOutInt8:
 * @a: (out) (transfer none):
 */
typedef void (* CallbackTestsCallbackOutInt8) (gint8* a);

void
callback_tests_outparam_gint8 (CallbackTestsCallbackOutInt8 callback, gint8* arg0);


/**
 * CallbackTestsCallbackOutUint8:
 * @a: (out) (transfer none):
 */
typedef void (* CallbackTestsCallbackOutUint8) (guint8* a);

void
callback_tests_outparam_guint8 (CallbackTestsCallbackOutUint8 callback, guint8* arg0);


/**
 * CallbackTestsCallbackOutInt16:
 * @a: (out) (transfer none):
 */
typedef void (* CallbackTestsCallbackOutInt16) (gint16* a);

void
callback_tests_outparam_gint16 (CallbackTestsCallbackOutInt16 callback, gint16* arg0);


/**
 * CallbackTestsCallbackOutUint16:
 * @a: (out) (transfer none):
 */
typedef void (* CallbackTestsCallbackOutUint16) (guint16* a);

void
callback_tests_outparam_guint16 (CallbackTestsCallbackOutUint16 callback, guint16* arg0);


/**
 * CallbackTestsCallbackOutInt32:
 * @a: (out) (transfer none):
 */
typedef void (* CallbackTestsCallbackOutInt32) (gint32* a);

void
callback_tests_outparam_gint32 (CallbackTestsCallbackOutInt32 callback, gint32* arg0);


/**
 * CallbackTestsCallbackOutUint32:
 * @a: (out) (transfer none):
 */
typedef void (* CallbackTestsCallbackOutUint32) (guint32* a);

void
callback_tests_outparam_guint32 (CallbackTestsCallbackOutUint32 callback, guint32* arg0);


/**
 * CallbackTestsCallbackOutInt64:
 * @a: (out) (transfer none):
 */
typedef void (* CallbackTestsCallbackOutInt64) (gint64* a);

void
callback_tests_outparam_gint64 (CallbackTestsCallbackOutInt64 callback, gint64* arg0);


/**
 * CallbackTestsCallbackOutUint64:
 * @a: (out) (transfer none):
 */
typedef void (* CallbackTestsCallbackOutUint64) (guint64* a);

void
callback_tests_outparam_guint64 (CallbackTestsCallbackOutUint64 callback, guint64* arg0);


/**
 * CallbackTestsCallbackOutChar:
 * @a: (out) (transfer none):
 */
typedef void (* CallbackTestsCallbackOutChar) (gchar* a);

void
callback_tests_outparam_gchar (CallbackTestsCallbackOutChar callback, gchar* arg0);


/**
 * CallbackTestsCallbackOutShort:
 * @a: (out) (transfer none):
 */
typedef void (* CallbackTestsCallbackOutShort) (gshort* a);

void
callback_tests_outparam_gshort (CallbackTestsCallbackOutShort callback, gshort* arg0);


/**
 * CallbackTestsCallbackOutUshort:
 * @a: (out) (transfer none):
 */
typedef void (* CallbackTestsCallbackOutUshort) (gushort* a);

void
callback_tests_outparam_gushort (CallbackTestsCallbackOutUshort callback, gushort* arg0);


/**
 * CallbackTestsCallbackOutInt:
 * @a: (out) (transfer none):
 */
typedef void (* CallbackTestsCallbackOutInt) (gint* a);

void
callback_tests_outparam_gint (CallbackTestsCallbackOutInt callback, gint* arg0);


/**
 * CallbackTestsCallbackOutUint:
 * @a: (out) (transfer none):
 */
typedef void (* CallbackTestsCallbackOutUint) (guint* a);

void
callback_tests_outparam_guint (CallbackTestsCallbackOutUint callback, guint* arg0);


/**
 * CallbackTestsCallbackOutLong:
 * @a: (out) (transfer none):
 */
typedef void (* CallbackTestsCallbackOutLong) (glong* a);

void
callback_tests_outparam_glong (CallbackTestsCallbackOutLong callback, glong* arg0);


/**
 * CallbackTestsCallbackOutUlong:
 * @a: (out) (transfer none):
 */
typedef void (* CallbackTestsCallbackOutUlong) (gulong* a);

void
callback_tests_outparam_gulong (CallbackTestsCallbackOutUlong callback, gulong* arg0);


/**
 * CallbackTestsCallbackOutSize:
 * @a: (out) (transfer none):
 */
typedef void (* CallbackTestsCallbackOutSize) (gsize* a);

void
callback_tests_outparam_gsize (CallbackTestsCallbackOutSize callback, gsize* arg0);


/**
 * CallbackTestsCallbackOutSsize:
 * @a: (out) (transfer none):
 */
typedef void (* CallbackTestsCallbackOutSsize) (gssize* a);

void
callback_tests_outparam_gssize (CallbackTestsCallbackOutSsize callback, gssize* arg0);


/**
 * CallbackTestsCallbackOutIntPtr:
 * @a: (out) (transfer none):
 */
typedef void (* CallbackTestsCallbackOutIntPtr) (gintptr* a);

void
callback_tests_outparam_gintptr (CallbackTestsCallbackOutIntPtr callback, gintptr* arg0);


/**
 * CallbackTestsCallbackOutUintPtr:
 * @a: (out) (transfer none):
 */
typedef void (* CallbackTestsCallbackOutUintPtr) (guintptr* a);

void
callback_tests_outparam_guintptr (CallbackTestsCallbackOutUintPtr callback, guintptr* arg0);


/**
 * CallbackTestsCallbackOutFloat:
 * @a: (out) (transfer none):
 */
typedef void (* CallbackTestsCallbackOutFloat) (gfloat* a);

void
callback_tests_outparam_gfloat (CallbackTestsCallbackOutFloat callback, gfloat* arg0);


/**
 * CallbackTestsCallbackOutDouble:
 * @a: (out) (transfer none):
 */
typedef void (* CallbackTestsCallbackOutDouble) (gdouble* a);

void
callback_tests_outparam_gdouble (CallbackTestsCallbackOutDouble callback, gdouble* arg0);


/**
 * CallbackTestsCallbackOutUnichar:
 * @a: (out) (transfer none):
 */
typedef void (* CallbackTestsCallbackOutUnichar) (gunichar* a);

void
callback_tests_outparam_gunichar (CallbackTestsCallbackOutUnichar callback, gunichar* arg0);


/**
 * CallbackTestsCallbackOutGType:
 * @a: (out) (transfer none):
 */
typedef void (* CallbackTestsCallbackOutGType) (GType* a);

void
callback_tests_outparam_GType (CallbackTestsCallbackOutGType callback, GType* arg0);


/**
 * CallbackTestsCallbackOutString
 * @a: (out) (transfer none):
 */
typedef void (* CallbackTestsCallbackOutString) (const gchar** a);

void
callback_tests_outparam_utf8 (CallbackTestsCallbackOutString callback, const gchar** arg0);


/**
 * CallbackTestsCallbackOutFilename:
 * @a: (out) (transfer none):
 */
typedef void (* CallbackTestsCallbackOutFilename) (const gchar** a);

void
callback_tests_outparam_filename (CallbackTestsCallbackOutFilename callback, const gchar** arg0);


/**
 * CallbackTestsCallbackOutStruct:
 * @a: (out) (transfer none):
 */
typedef void (* CallbackTestsCallbackOutStruct) (CallbackTestsStruct** a);

void
callback_tests_outparam_struct (CallbackTestsCallbackOutStruct callback, CallbackTestsStruct** arg0);


/**
 * CallbackTestsCallbackOutEnum:
 * @a: (out) (transfer none):
 */
typedef void (* CallbackTestsCallbackOutEnum) (CallbackTestsEnum* a);

void
callback_tests_outparam_enum (CallbackTestsCallbackOutEnum callback, CallbackTestsEnum* arg0);


/**
 * CallbackTestsCallbackOutFlags:
 * @a: (out) (transfer none):
 */
typedef void (* CallbackTestsCallbackOutFlags) (CallbackTestsFlags* a);

void
callback_tests_outparam_flags (CallbackTestsCallbackOutFlags callback, CallbackTestsFlags* arg0);


/**
 * CallbackTestsCallbackOutArray:
 * @a: (out) (array length=len) (transfer none):
 * @len: (out) (transfer none):
 */
typedef void (* CallbackTestsCallbackOutArray) (gint** a, gint* len);

void
callback_tests_outparam_array (CallbackTestsCallbackOutArray callback, gint** arg0, gint* len);


/**
 * CallbackTestsCallbackOutList:
 * @a: (out) (element-type gint) (transfer none):
 */
typedef void (* CallbackTestsCallbackOutList) (GList** a);

void
callback_tests_outparam_list (CallbackTestsCallbackOutList callback, GList** arg0);


/**
 * CallbackTestsCallbackOutTransferNone
 * @a: (out) (transfer none):
 */
typedef void (* CallbackTestsCallbackOutTransferNone) (const gchar** a);

void
callback_tests_outparam_transfer_none (CallbackTestsCallbackOutTransferNone callback, const gchar** arg0);


/**
 * CallbackTestsCallbackOutTransferFull
 * @a: (out) (transfer full):
 */
typedef void (* CallbackTestsCallbackOutTransferFull) (gchar** a);

void
callback_tests_outparam_transfer_full (CallbackTestsCallbackOutTransferFull callback, gchar** arg0);


/**
 * CallbackTestsCallbackOutTransferContainer
 * @a: (out) (array length=len) (transfer container):
 * @len: (out):
 */
typedef void (* CallbackTestsCallbackOutTransferContainer) (gchar** a, gint* len);

void
callback_tests_outparam_transfer_container (CallbackTestsCallbackOutTransferContainer callback, gchar** arg0, gint* len);


/**
 * CallbackTestsCallbackInOutBoolean:
 * @a: (inout):
 */
typedef void (* CallbackTestsCallbackInOutBoolean) (gboolean* a);

void
callback_tests_inoutparam_gboolean (CallbackTestsCallbackInOutBoolean callback, gboolean* arg0);


/**
 * CallbackTestsCallbackInOutInt8:
 * @a: (inout):
 */
typedef void (* CallbackTestsCallbackInOutInt8) (gint8* a);

void
callback_tests_inoutparam_gint8 (CallbackTestsCallbackInOutInt8 callback, gint8* arg0);


/**
 * CallbackTestsCallbackInOutUint8:
 * @a: (inout):
 */
typedef void (* CallbackTestsCallbackInOutUint8) (guint8* a);

void
callback_tests_inoutparam_guint8 (CallbackTestsCallbackInOutUint8 callback, guint8* arg0);


/**
 * CallbackTestsCallbackInOutInt16:
 * @a: (inout):
 */
typedef void (* CallbackTestsCallbackInOutInt16) (gint16* a);

void
callback_tests_inoutparam_gint16 (CallbackTestsCallbackInOutInt16 callback, gint16* arg0);


/**
 * CallbackTestsCallbackInOutUint16:
 * @a: (inout):
 */
typedef void (* CallbackTestsCallbackInOutUint16) (guint16* a);

void
callback_tests_inoutparam_guint16 (CallbackTestsCallbackInOutUint16 callback, guint16* arg0);


/**
 * CallbackTestsCallbackInOutInt32:
 * @a: (inout):
 */
typedef void (* CallbackTestsCallbackInOutInt32) (gint32* a);

void
callback_tests_inoutparam_gint32 (CallbackTestsCallbackInOutInt32 callback, gint32* arg0);


/**
 * CallbackTestsCallbackInOutUint32:
 * @a: (inout):
 */
typedef void (* CallbackTestsCallbackInOutUint32) (guint32* a);

void
callback_tests_inoutparam_guint32 (CallbackTestsCallbackInOutUint32 callback, guint32* arg0);


/**
 * CallbackTestsCallbackInOutInt64:
 * @a: (inout):
 */
typedef void (* CallbackTestsCallbackInOutInt64) (gint64* a);

void
callback_tests_inoutparam_gint64 (CallbackTestsCallbackInOutInt64 callback, gint64* arg0);


/**
 * CallbackTestsCallbackInOutUint64:
 * @a: (inout):
 */
typedef void (* CallbackTestsCallbackInOutUint64) (guint64* a);

void
callback_tests_inoutparam_guint64 (CallbackTestsCallbackInOutUint64 callback, guint64* arg0);


/**
 * CallbackTestsCallbackInOutChar:
 * @a: (inout):
 */
typedef void (* CallbackTestsCallbackInOutChar) (gchar* a);

void
callback_tests_inoutparam_gchar (CallbackTestsCallbackInOutChar callback, gchar* arg0);


/**
 * CallbackTestsCallbackInOutShort:
 * @a: (inout):
 */
typedef void (* CallbackTestsCallbackInOutShort) (gshort* a);

void
callback_tests_inoutparam_gshort (CallbackTestsCallbackInOutShort callback, gshort* arg0);


/**
 * CallbackTestsCallbackInOutUshort:
 * @a: (inout):
 */
typedef void (* CallbackTestsCallbackInOutUshort) (gushort* a);

void
callback_tests_inoutparam_gushort (CallbackTestsCallbackInOutUshort callback, gushort* arg0);


/**
 * CallbackTestsCallbackInOutInt:
 * @a: (inout):
 */
typedef void (* CallbackTestsCallbackInOutInt) (gint* a);

void
callback_tests_inoutparam_gint (CallbackTestsCallbackInOutInt callback, gint* arg0);


/**
 * CallbackTestsCallbackInOutUint:
 * @a: (inout):
 */
typedef void (* CallbackTestsCallbackInOutUint) (guint* a);

void
callback_tests_inoutparam_guint (CallbackTestsCallbackInOutUint callback, guint* arg0);


/**
 * CallbackTestsCallbackInOutLong:
 * @a: (inout):
 */
typedef void (* CallbackTestsCallbackInOutLong) (glong* a);

void
callback_tests_inoutparam_glong (CallbackTestsCallbackInOutLong callback, glong* arg0);


/**
 * CallbackTestsCallbackInOutUlong:
 * @a: (inout):
 */
typedef void (* CallbackTestsCallbackInOutUlong) (gulong* a);

void
callback_tests_inoutparam_gulong (CallbackTestsCallbackInOutUlong callback, gulong* arg0);


/**
 * CallbackTestsCallbackInOutSize:
 * @a: (inout):
 */
typedef void (* CallbackTestsCallbackInOutSize) (gsize* a);

void
callback_tests_inoutparam_gsize (CallbackTestsCallbackInOutSize callback, gsize* arg0);


/**
 * CallbackTestsCallbackInOutSsize:
 * @a: (inout):
 */
typedef void (* CallbackTestsCallbackInOutSsize) (gssize* a);

void
callback_tests_inoutparam_gssize (CallbackTestsCallbackInOutSsize callback, gssize* arg0);


/**
 * CallbackTestsCallbackInOutIntPtr:
 * @a: (inout):
 */
typedef void (* CallbackTestsCallbackInOutIntPtr) (gintptr* a);

void
callback_tests_inoutparam_gintptr (CallbackTestsCallbackInOutIntPtr callback, gintptr* arg0);


/**
 * CallbackTestsCallbackInOutUintPtr:
 * @a: (inout):
 */
typedef void (* CallbackTestsCallbackInOutUintPtr) (guintptr* a);

void
callback_tests_inoutparam_guintptr (CallbackTestsCallbackInOutUintPtr callback, guintptr* arg0);


/**
 * CallbackTestsCallbackInOutFloat:
 * @a: (inout):
 */
typedef void (* CallbackTestsCallbackInOutFloat) (gfloat* a);

void
callback_tests_inoutparam_gfloat (CallbackTestsCallbackInOutFloat callback, gfloat* arg0);


/**
 * CallbackTestsCallbackInOutDouble:
 * @a: (inout):
 */
typedef void (* CallbackTestsCallbackInOutDouble) (gdouble* a);

void
callback_tests_inoutparam_gdouble (CallbackTestsCallbackInOutDouble callback, gdouble* arg0);


/**
 * CallbackTestsCallbackInOutUnichar:
 * @a: (inout):
 */
typedef void (* CallbackTestsCallbackInOutUnichar) (gunichar* a);

void
callback_tests_inoutparam_gunichar (CallbackTestsCallbackInOutUnichar callback, gunichar* arg0);


/**
 * CallbackTestsCallbackInOutGType:
 * @a: (inout):
 */
typedef void (* CallbackTestsCallbackInOutGType) (GType* a);

void
callback_tests_inoutparam_GType (CallbackTestsCallbackInOutGType callback, GType* arg0);


/**
 * CallbackTestsCallbackInOutString:
 * @a: (inout):
 */
typedef void (* CallbackTestsCallbackInOutString) (const gchar** a);

void
callback_tests_inoutparam_utf8 (CallbackTestsCallbackInOutString callback, const gchar** arg0);


/**
 * CallbackTestsCallbackInOutFilename:
 * @a: (inout):
 */
typedef void (* CallbackTestsCallbackInOutFilename) (const gchar** a);

void
callback_tests_inoutparam_filename (CallbackTestsCallbackInOutFilename callback, const gchar** arg0);


/**
 * CallbackTestsCallbackInOutStruct:
 * @a: (inout):
 */
typedef void (* CallbackTestsCallbackInOutStruct) (CallbackTestsStruct** a);

void
callback_tests_inoutparam_struct (CallbackTestsCallbackInOutStruct callback, CallbackTestsStruct** arg0);


/**
 * CallbackTestsCallbackInOutEnum:
 * @a: (inout):
 */
typedef void (* CallbackTestsCallbackInOutEnum) (CallbackTestsEnum* a);

void
callback_tests_inoutparam_enum (CallbackTestsCallbackInOutEnum callback, CallbackTestsEnum* arg0);


/**
 * CallbackTestsCallbackInOutFlags:
 * @a: (inout):
 */
typedef void (* CallbackTestsCallbackInOutFlags) (CallbackTestsFlags* a);

void
callback_tests_inoutparam_flags (CallbackTestsCallbackInOutFlags callback, CallbackTestsFlags* arg0);


/**
 * CallbackTestsCallbackInOutArray:
 * @a: (inout) (array length=len):
 * @len: (inout):
 */
typedef void (* CallbackTestsCallbackInOutArray) (gint** a, gint* len);

void
callback_tests_inoutparam_array (CallbackTestsCallbackInOutArray callback, gint** arg0, gint* len);


/**
 * CallbackTestsCallbackInOutList:
 * @a: (inout) (element-type gint):
 */
typedef void (* CallbackTestsCallbackInOutList) (GList** a);

void
callback_tests_inoutparam_list (CallbackTestsCallbackInOutList callback, GList** arg0);


/**
 * CallbackTestsCallbackInOutTransferNone:
 * @a: (inout) (transfer none):
 */
typedef void (* CallbackTestsCallbackInOutTransferNone) (const gchar** a);

void
callback_tests_inoutparam_transfer_none (CallbackTestsCallbackInOutTransferNone callback, const gchar** arg0);


/**
 * CallbackTestsCallbackInOutTransferFull:
 * @a: (inout) (transfer full):
 */
typedef void (* CallbackTestsCallbackInOutTransferFull) (gchar** a);

void
callback_tests_inoutparam_transfer_full (CallbackTestsCallbackInOutTransferFull callback, gchar** arg0);


/**
 * CallbackTestsCallbackInOutTransferContainer:
 * @a: (inout) (array length=len) (transfer container):
 * @len: (inout):
 */
typedef void (* CallbackTestsCallbackInOutTransferContainer) (gchar** a, gint* len);

void
callback_tests_inoutparam_transfer_container (CallbackTestsCallbackInOutTransferContainer callback, gchar** arg0, gint* len);

#endif
