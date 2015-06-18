#include "callbacktests.h"

/**
 * callback_tests_scope_call:
 * @callback: (scope call):
 */
void
callback_tests_scope_call (CallbackTestsCallbackScopeCall callback)
{
  callback ();
  return;
}

/**
 * callback_tests_scope_call_multiple_invocations:
 * @callback: (scope call):
 */
void
callback_tests_scope_call_multiple_invocations (CallbackTestsCallbackScopeCall callback)
{
  callback ();
  callback ();
  callback ();
  return;
}

static CallbackTestsCallbackScopeAsync async_callback = NULL;

/**
 * callback_tests_scope_async:
 * @callback: (scope async):
 */
void
callback_tests_scope_async (CallbackTestsCallbackScopeAsync callback)
{
  async_callback = callback;
  return;
}

/**
 * callback_tests_invoke_async_callback:
 */
void
callback_tests_invoke_async_callback (void)
{
  (*async_callback) ();
  async_callback = NULL;
  return;
}

static CallbackTestsCallbackScopeNotified notified_callback = NULL;
static gpointer notified_callback_closure = NULL;
static GDestroyNotify notified_callback_destroy = NULL;

/**
 * callback_tests_scope_notified:
 * @callback: (scope notified):
 * @data: (allow-none):
 * @destroy: (allow-none):
 */
void
callback_tests_scope_notified (CallbackTestsCallbackScopeNotified callback, gpointer data, GDestroyNotify destroy)
{
  notified_callback = callback;
  notified_callback_closure = data;
  notified_callback_destroy = destroy;
  return;
}

/**
 * callback_tests_invoke_notified_callback:
 */
void
callback_tests_invoke_notified_callback (void)
{
  (*notified_callback) (notified_callback_closure);
  return;
}

/**
 * callback_tests_destroy_notified_callback:
 */
void
callback_tests_destroy_notified_callback (void)
{
  (*notified_callback_destroy) (notified_callback_closure);
  return;
}

/**
 * callback_tests_arity_one:
 * @callback: (scope call):
 */
void
callback_tests_arity_one (CallbackTestsCallbackArityOne callback)
{
  callback ("const \xe2\x99\xa5 utf8");
  return;
}

/**
 * callback_tests_nullfunc:
 * @callback: (scope call):
 */
void
callback_tests_nullfunc (CallbackTestsCallbackVoid callback)
{
  callback ();
  return;
}

/**
 * callback_tests_return_gboolean:
 * @callback: (scope call):
 */
gboolean
callback_tests_return_gboolean (CallbackTestsCallbackReturnBoolean callback)
{
  return callback ();
}

/**
 * callback_tests_return_gint8:
 * @callback: (scope call):
 */
gint8
callback_tests_return_gint8 (CallbackTestsCallbackReturnInt8 callback)
{
  return callback ();
}

/**
 * callback_tests_return_guint8:
 * @callback: (scope call):
 */
guint8
callback_tests_return_guint8 (CallbackTestsCallbackReturnUint8 callback)
{
  return callback ();
}

/**
 * callback_tests_return_gint16:
 * @callback: (scope call):
 */
gint16
callback_tests_return_gint16 (CallbackTestsCallbackReturnInt16 callback)
{
  return callback ();
}

/**
 * callback_tests_return_guint16:
 * @callback: (scope call):
 */
guint16
callback_tests_return_guint16 (CallbackTestsCallbackReturnUint16 callback)
{
  return callback ();
}

/**
 * callback_tests_return_gint32:
 * @callback: (scope call):
 */
gint32
callback_tests_return_gint32 (CallbackTestsCallbackReturnInt32 callback)
{
  return callback ();
}

/**
 * callback_tests_return_guint32:
 * @callback: (scope call):
 */
guint32
callback_tests_return_guint32 (CallbackTestsCallbackReturnUint32 callback)
{
  return callback ();
}

/**
 * callback_tests_return_gint64:
 * @callback: (scope call):
 */
gint64
callback_tests_return_gint64 (CallbackTestsCallbackReturnInt64 callback)
{
  return callback ();
}

/**
 * callback_tests_return_guint64:
 * @callback: (scope call):
 */
guint64
callback_tests_return_guint64 (CallbackTestsCallbackReturnUint64 callback)
{
  return callback ();
}

/**
 * callback_tests_return_gchar:
 * @callback: (scope call):
 */
gchar
callback_tests_return_gchar (CallbackTestsCallbackReturnChar callback)
{
  return callback ();
}

/**
 * callback_tests_return_gshort:
 * @callback: (scope call):
 */
gshort
callback_tests_return_gshort (CallbackTestsCallbackReturnShort callback)
{
  return callback ();
}

/**
 * callback_tests_return_gushort:
 * @callback: (scope call):
 */
gushort
callback_tests_return_gushort (CallbackTestsCallbackReturnUshort callback)
{
  return callback ();
}

/**
 * callback_tests_return_gint:
 * @callback: (scope call):
 */
gint
callback_tests_return_gint (CallbackTestsCallbackReturnInt callback)
{
  return callback ();
}

/**
 * callback_tests_return_guint:
 * @callback: (scope call):
 */
guint
callback_tests_return_guint (CallbackTestsCallbackReturnUint callback)
{
  return callback ();
}

/**
 * callback_tests_return_glong:
 * @callback: (scope call):
 */
glong
callback_tests_return_glong (CallbackTestsCallbackReturnLong callback)
{
  return callback ();
}

/**
 * callback_tests_return_gulong:
 * @callback: (scope call):
 */
gulong
callback_tests_return_gulong (CallbackTestsCallbackReturnUlong callback)
{
  return callback ();
}

/**
 * callback_tests_return_gsize:
 * @callback: (scope call):
 */
gsize
callback_tests_return_gsize (CallbackTestsCallbackReturnSize callback)
{
  return callback ();
}

/**
 * callback_tests_return_gssize:
 * @callback: (scope call):
 */
gssize
callback_tests_return_gssize (CallbackTestsCallbackReturnSsize callback)
{
  return callback ();
}

/**
 * callback_tests_return_gintptr:
 * @callback: (scope call):
 */
gintptr
callback_tests_return_gintptr (CallbackTestsCallbackReturnIntPtr callback)
{
  return callback ();
}

/**
 * callback_tests_return_guintptr:
 * @callback: (scope call):
 */
guintptr
callback_tests_return_guintptr (CallbackTestsCallbackReturnUintPtr callback)
{
  return callback ();
}

/**
 * callback_tests_return_gfloat:
 * @callback: (scope call):
 */
gfloat
callback_tests_return_gfloat (CallbackTestsCallbackReturnFloat callback)
{
  return callback ();
}

/**
 * callback_tests_return_gdouble:
 * @callback: (scope call):
 */
gdouble
callback_tests_return_gdouble (CallbackTestsCallbackReturnDouble callback)
{
  return callback ();
}

/**
 * callback_tests_return_gunichar:
 * @callback: (scope call):
 */
gunichar
callback_tests_return_gunichar (CallbackTestsCallbackReturnUnichar callback)
{
  return callback ();
}

/**
 * callback_tests_return_GType:
 * @callback: (scope call):
 */
GType
callback_tests_return_GType (CallbackTestsCallbackReturnGType callback)
{
  return callback ();
}

/**
 * callback_tests_return_utf8:
 * @callback: (scope call):
 */
const gchar*
callback_tests_return_utf8 (CallbackTestsCallbackReturnString callback)
{
  return callback ();
}

/**
 * callback_tests_return_filename:
 * @callback: (scope call):
 */
const gchar*
callback_tests_return_filename (CallbackTestsCallbackReturnFilename callback)
{
  return callback ();
}

/**
 * callback_tests_return_struct:
 * @callback: (scope call):
 * Returns: (transfer none):
 */
CallbackTestsStruct*
callback_tests_return_struct (CallbackTestsCallbackReturnStruct callback)
{
  return callback ();
}

/**
 * callback_tests_return_enum:
 * @callback: (scope call):
 */
CallbackTestsEnum
callback_tests_return_enum (CallbackTestsCallbackReturnEnum callback)
{
  return callback ();
}

/**
 * callback_tests_return_flags:
 * @callback: (scope call):
 */
CallbackTestsFlags
callback_tests_return_flags (CallbackTestsCallbackReturnFlags callback)
{
  return callback ();
}

/**
 * callback_tests_return_array:
 * @callback: (scope call):
 * @len: (out) (transfer none):
 * Returns: (array length=len) (transfer none):
 */
gint*
callback_tests_return_array (CallbackTestsCallbackReturnArray callback, gint* len)
{
  return callback (len);
}

/**
 * callback_tests_return_list:
 * @callback: (scope call):
 * Returns: (element-type gint) (transfer none):
 */
GList*
callback_tests_return_list (CallbackTestsCallbackReturnList callback)
{
  return callback ();
}

/**
 * callback_tests_return_transfer_none:
 * @callback: (scope call) (transfer none):
 */
const gchar*
callback_tests_return_transfer_none (CallbackTestsCallbackReturnTransferNone callback)
{
  return callback ();
}

/**
 * callback_tests_return_transfer_full:
 * @callback: (scope call) (transfer full):
 */
gchar*
callback_tests_return_transfer_full (CallbackTestsCallbackReturnTransferFull callback)
{
  return callback ();
}

/**
 * callback_tests_return_transfer_container:
 * @callback: (scope call):
 * @len: (out):
 * Returns: (array length=len) (transfer container):
 */
gchar**
callback_tests_return_transfer_container (CallbackTestsCallbackReturnTransferContainer callback, gint* len)
{
  return callback (len);
}

/**
 * callback_tests_inparam_gboolean:
 * @callback: (scope call):
 * @arg0: :
 */
void
callback_tests_inparam_gboolean (CallbackTestsCallbackInBoolean callback, gboolean arg0)
{
  callback (arg0);
  return;
}

/**
 * callback_tests_inparam_gint8:
 * @callback: (scope call):
 * @arg0: :
 */
void
callback_tests_inparam_gint8 (CallbackTestsCallbackInInt8 callback, gint8 arg0)
{
  callback (arg0);
  return;
}

/**
 * callback_tests_inparam_guint8:
 * @callback: (scope call):
 * @arg0: :
 */
void
callback_tests_inparam_guint8 (CallbackTestsCallbackInUint8 callback, guint8 arg0)
{
  callback (arg0);
  return;
}

/**
 * callback_tests_inparam_gint16:
 * @callback: (scope call):
 * @arg0: :
 */
void
callback_tests_inparam_gint16 (CallbackTestsCallbackInInt16 callback, gint16 arg0)
{
  callback (arg0);
  return;
}

/**
 * callback_tests_inparam_guint16:
 * @callback: (scope call):
 * @arg0: :
 */
void
callback_tests_inparam_guint16 (CallbackTestsCallbackInUint16 callback, guint16 arg0)
{
  callback (arg0);
  return;
}

/**
 * callback_tests_inparam_gint32:
 * @callback: (scope call):
 * @arg0: :
 */
void
callback_tests_inparam_gint32 (CallbackTestsCallbackInInt32 callback, gint32 arg0)
{
  callback (arg0);
  return;
}

/**
 * callback_tests_inparam_guint32:
 * @callback: (scope call):
 * @arg0: :
 */
void
callback_tests_inparam_guint32 (CallbackTestsCallbackInUint32 callback, guint32 arg0)
{
  callback (arg0);
  return;
}

/**
 * callback_tests_inparam_gint64:
 * @callback: (scope call):
 * @arg0: :
 */
void
callback_tests_inparam_gint64 (CallbackTestsCallbackInInt64 callback, gint64 arg0)
{
  callback (arg0);
  return;
}

/**
 * callback_tests_inparam_guint64:
 * @callback: (scope call):
 * @arg0: :
 */
void
callback_tests_inparam_guint64 (CallbackTestsCallbackInUint64 callback, guint64 arg0)
{
  callback (arg0);
  return;
}

/**
 * callback_tests_inparam_gchar:
 * @callback: (scope call):
 * @arg0: :
 */
void
callback_tests_inparam_gchar (CallbackTestsCallbackInChar callback, gchar arg0)
{
  callback (arg0);
  return;
}

/**
 * callback_tests_inparam_gshort:
 * @callback: (scope call):
 * @arg0: :
 */
void
callback_tests_inparam_gshort (CallbackTestsCallbackInShort callback, gshort arg0)
{
  callback (arg0);
  return;
}

/**
 * callback_tests_inparam_gushort:
 * @callback: (scope call):
 * @arg0: :
 */
void
callback_tests_inparam_gushort (CallbackTestsCallbackInUshort callback, gushort arg0)
{
  callback (arg0);
  return;
}

/**
 * callback_tests_inparam_gint:
 * @callback: (scope call):
 * @arg0: :
 */
void
callback_tests_inparam_gint (CallbackTestsCallbackInInt callback, gint arg0)
{
  callback (arg0);
  return;
}

/**
 * callback_tests_inparam_guint:
 * @callback: (scope call):
 * @arg0: :
 */
void
callback_tests_inparam_guint (CallbackTestsCallbackInUint callback, guint arg0)
{
  callback (arg0);
  return;
}

/**
 * callback_tests_inparam_glong:
 * @callback: (scope call):
 * @arg0: :
 */
void
callback_tests_inparam_glong (CallbackTestsCallbackInLong callback, glong arg0)
{
  callback (arg0);
  return;
}

/**
 * callback_tests_inparam_gulong:
 * @callback: (scope call):
 * @arg0: :
 */
void
callback_tests_inparam_gulong (CallbackTestsCallbackInUlong callback, gulong arg0)
{
  callback (arg0);
  return;
}

/**
 * callback_tests_inparam_gsize:
 * @callback: (scope call):
 * @arg0: :
 */
void
callback_tests_inparam_gsize (CallbackTestsCallbackInSize callback, gsize arg0)
{
  callback (arg0);
  return;
}

/**
 * callback_tests_inparam_gssize:
 * @callback: (scope call):
 * @arg0: :
 */
void
callback_tests_inparam_gssize (CallbackTestsCallbackInSsize callback, gssize arg0)
{
  callback (arg0);
  return;
}

/**
 * callback_tests_inparam_gintptr:
 * @callback: (scope call):
 * @arg0: :
 */
void
callback_tests_inparam_gintptr (CallbackTestsCallbackInIntPtr callback, gintptr arg0)
{
  callback (arg0);
  return;
}

/**
 * callback_tests_inparam_guintptr:
 * @callback: (scope call):
 * @arg0: :
 */
void
callback_tests_inparam_guintptr (CallbackTestsCallbackInUintPtr callback, guintptr arg0)
{
  callback (arg0);
  return;
}

/**
 * callback_tests_inparam_gfloat:
 * @callback: (scope call):
 * @arg0: :
 */
void
callback_tests_inparam_gfloat (CallbackTestsCallbackInFloat callback, gfloat arg0)
{
  callback (arg0);
  return;
}

/**
 * callback_tests_inparam_gdouble:
 * @callback: (scope call):
 * @arg0: :
 */
void
callback_tests_inparam_gdouble (CallbackTestsCallbackInDouble callback, gdouble arg0)
{
  callback (arg0);
  return;
}

/**
 * callback_tests_inparam_gunichar:
 * @callback: (scope call):
 * @arg0: :
 */
void
callback_tests_inparam_gunichar (CallbackTestsCallbackInUnichar callback, gunichar arg0)
{
  callback (arg0);
  return;
}

/**
 * callback_tests_inparam_GType:
 * @callback: (scope call):
 * @arg0: :
 */
void
callback_tests_inparam_GType (CallbackTestsCallbackInGType callback, GType arg0)
{
  callback (arg0);
  return;
}

/**
 * callback_tests_inparam_utf8:
 * @callback: (scope call):
 * @arg0: :
 */
void
callback_tests_inparam_utf8 (CallbackTestsCallbackInString callback, const gchar* arg0)
{
  callback (arg0);
  return;
}

/**
 * callback_tests_inparam_filename:
 * @callback: (scope call):
 * @arg0: :
 */
void
callback_tests_inparam_filename (CallbackTestsCallbackInFilename callback, const gchar* arg0)
{
  callback (arg0);
  return;
}

/**
 * callback_tests_inparam_struct:
 * @callback: (scope call):
 * @arg0: :
 */
void
callback_tests_inparam_struct (CallbackTestsCallbackInStruct callback, CallbackTestsStruct* arg0)
{
  callback (arg0);
  return;
}

/**
 * callback_tests_inparam_enum:
 * @callback: (scope call):
 * @arg0: :
 */
void
callback_tests_inparam_enum (CallbackTestsCallbackInEnum callback, CallbackTestsEnum arg0)
{
  callback (arg0);
  return;
}

/**
 * callback_tests_inparam_flags:
 * @callback: (scope call):
 * @arg0: :
 */
void
callback_tests_inparam_flags (CallbackTestsCallbackInFlags callback, CallbackTestsFlags arg0)
{
  callback (arg0);
  return;
}

/**
 * callback_tests_inparam_array:
 * @callback: (scope call):
 * @arg0: (array length=len):
 * @len: :
 */
void
callback_tests_inparam_array (CallbackTestsCallbackInArray callback, gint* arg0, gint len)
{
  callback (arg0, len);
  return;
}

/**
 * callback_tests_inparam_list:
 * @callback: (scope call):
 * @arg0: (element-type gint):
 */
void
callback_tests_inparam_list (CallbackTestsCallbackInList callback, GList* arg0)
{
  callback (arg0);
  return;
}

/**
 * callback_tests_inparam_transfer_none:
 * @callback: (scope call):
 * @arg0: (transfer none):
 */
void
callback_tests_inparam_transfer_none (CallbackTestsCallbackInTransferNone callback, const gchar* arg0)
{
  callback (arg0);
  return;
}

/**
 * callback_tests_inparam_transfer_full:
 * @callback: (scope call):
 * @arg0: (transfer full):
 */
void
callback_tests_inparam_transfer_full (CallbackTestsCallbackInTransferFull callback, gchar* arg0)
{
  callback (arg0);
  return;
}

/**
 * callback_tests_inparam_transfer_container:
 * @callback: (scope call):
 * @arg0: (array length=len) (transfer container):
 * @len: :
 */
void
callback_tests_inparam_transfer_container (CallbackTestsCallbackInTransferContainer callback, gchar** arg0, gint len)
{
  callback (arg0, len);
  return;
}

/**
 * callback_tests_outparam_gboolean:
 * @callback: (scope call):
 * @arg0: (out) (transfer none):
 */
void
callback_tests_outparam_gboolean (CallbackTestsCallbackOutBoolean callback, gboolean* arg0)
{
  callback (arg0);
  return;
}

/**
 * callback_tests_outparam_gint8:
 * @callback: (scope call):
 * @arg0: (out) (transfer none):
 */
void
callback_tests_outparam_gint8 (CallbackTestsCallbackOutInt8 callback, gint8* arg0)
{
  callback (arg0);
  return;
}

/**
 * callback_tests_outparam_guint8:
 * @callback: (scope call):
 * @arg0: (out) (transfer none):
 */
void
callback_tests_outparam_guint8 (CallbackTestsCallbackOutUint8 callback, guint8* arg0)
{
  callback (arg0);
  return;
}

/**
 * callback_tests_outparam_gint16:
 * @callback: (scope call):
 * @arg0: (out) (transfer none):
 */
void
callback_tests_outparam_gint16 (CallbackTestsCallbackOutInt16 callback, gint16* arg0)
{
  callback (arg0);
  return;
}

/**
 * callback_tests_outparam_guint16:
 * @callback: (scope call):
 * @arg0: (out) (transfer none):
 */
void
callback_tests_outparam_guint16 (CallbackTestsCallbackOutUint16 callback, guint16* arg0)
{
  callback (arg0);
  return;
}

/**
 * callback_tests_outparam_gint32:
 * @callback: (scope call):
 * @arg0: (out) (transfer none):
 */
void
callback_tests_outparam_gint32 (CallbackTestsCallbackOutInt32 callback, gint32* arg0)
{
  callback (arg0);
  return;
}

/**
 * callback_tests_outparam_guint32:
 * @callback: (scope call):
 * @arg0: (out) (transfer none):
 */
void
callback_tests_outparam_guint32 (CallbackTestsCallbackOutUint32 callback, guint32* arg0)
{
  callback (arg0);
  return;
}

/**
 * callback_tests_outparam_gint64:
 * @callback: (scope call):
 * @arg0: (out) (transfer none):
 */
void
callback_tests_outparam_gint64 (CallbackTestsCallbackOutInt64 callback, gint64* arg0)
{
  callback (arg0);
  return;
}

/**
 * callback_tests_outparam_guint64:
 * @callback: (scope call):
 * @arg0: (out) (transfer none):
 */
void
callback_tests_outparam_guint64 (CallbackTestsCallbackOutUint64 callback, guint64* arg0)
{
  callback (arg0);
  return;
}

/**
 * callback_tests_outparam_gchar:
 * @callback: (scope call):
 * @arg0: (out) (transfer none):
 */
void
callback_tests_outparam_gchar (CallbackTestsCallbackOutChar callback, gchar* arg0)
{
  callback (arg0);
  return;
}

/**
 * callback_tests_outparam_gshort:
 * @callback: (scope call):
 * @arg0: (out) (transfer none):
 */
void
callback_tests_outparam_gshort (CallbackTestsCallbackOutShort callback, gshort* arg0)
{
  callback (arg0);
  return;
}

/**
 * callback_tests_outparam_gushort:
 * @callback: (scope call):
 * @arg0: (out) (transfer none):
 */
void
callback_tests_outparam_gushort (CallbackTestsCallbackOutUshort callback, gushort* arg0)
{
  callback (arg0);
  return;
}

/**
 * callback_tests_outparam_gint:
 * @callback: (scope call):
 * @arg0: (out) (transfer none):
 */
void
callback_tests_outparam_gint (CallbackTestsCallbackOutInt callback, gint* arg0)
{
  callback (arg0);
  return;
}

/**
 * callback_tests_outparam_guint:
 * @callback: (scope call):
 * @arg0: (out) (transfer none):
 */
void
callback_tests_outparam_guint (CallbackTestsCallbackOutUint callback, guint* arg0)
{
  callback (arg0);
  return;
}

/**
 * callback_tests_outparam_glong:
 * @callback: (scope call):
 * @arg0: (out) (transfer none):
 */
void
callback_tests_outparam_glong (CallbackTestsCallbackOutLong callback, glong* arg0)
{
  callback (arg0);
  return;
}

/**
 * callback_tests_outparam_gulong:
 * @callback: (scope call):
 * @arg0: (out) (transfer none):
 */
void
callback_tests_outparam_gulong (CallbackTestsCallbackOutUlong callback, gulong* arg0)
{
  callback (arg0);
  return;
}

/**
 * callback_tests_outparam_gsize:
 * @callback: (scope call):
 * @arg0: (out) (transfer none):
 */
void
callback_tests_outparam_gsize (CallbackTestsCallbackOutSize callback, gsize* arg0)
{
  callback (arg0);
  return;
}

/**
 * callback_tests_outparam_gssize:
 * @callback: (scope call):
 * @arg0: (out) (transfer none):
 */
void
callback_tests_outparam_gssize (CallbackTestsCallbackOutSsize callback, gssize* arg0)
{
  callback (arg0);
  return;
}

/**
 * callback_tests_outparam_gintptr:
 * @callback: (scope call):
 * @arg0: (out) (transfer none):
 */
void
callback_tests_outparam_gintptr (CallbackTestsCallbackOutIntPtr callback, gintptr* arg0)
{
  callback (arg0);
  return;
}

/**
 * callback_tests_outparam_guintptr:
 * @callback: (scope call):
 * @arg0: (out) (transfer none):
 */
void
callback_tests_outparam_guintptr (CallbackTestsCallbackOutUintPtr callback, guintptr* arg0)
{
  callback (arg0);
  return;
}

/**
 * callback_tests_outparam_gfloat:
 * @callback: (scope call):
 * @arg0: (out) (transfer none):
 */
void
callback_tests_outparam_gfloat (CallbackTestsCallbackOutFloat callback, gfloat* arg0)
{
  callback (arg0);
  return;
}

/**
 * callback_tests_outparam_gdouble:
 * @callback: (scope call):
 * @arg0: (out) (transfer none):
 */
void
callback_tests_outparam_gdouble (CallbackTestsCallbackOutDouble callback, gdouble* arg0)
{
  callback (arg0);
  return;
}

/**
 * callback_tests_outparam_gunichar:
 * @callback: (scope call):
 * @arg0: (out) (transfer none):
 */
void
callback_tests_outparam_gunichar (CallbackTestsCallbackOutUnichar callback, gunichar* arg0)
{
  callback (arg0);
  return;
}

/**
 * callback_tests_outparam_GType:
 * @callback: (scope call):
 * @arg0: (out) (transfer none):
 */
void
callback_tests_outparam_GType (CallbackTestsCallbackOutGType callback, GType* arg0)
{
  callback (arg0);
  return;
}

/**
 * callback_tests_outparam_utf8:
 * @callback: (scope call):
 * @arg0: (out) (transfer none):
 */
void
callback_tests_outparam_utf8 (CallbackTestsCallbackOutString callback, const gchar** arg0)
{
  callback (arg0);
  return;
}

/**
 * callback_tests_outparam_filename:
 * @callback: (scope call):
 * @arg0: (out) (transfer none):
 */
void
callback_tests_outparam_filename (CallbackTestsCallbackOutFilename callback, const gchar** arg0)
{
  callback (arg0);
  return;
}

/**
 * callback_tests_outparam_struct:
 * @callback: (scope call):
 * @arg0: (out) (transfer none):
 */
void
callback_tests_outparam_struct (CallbackTestsCallbackOutStruct callback, CallbackTestsStruct** arg0)
{
  callback (arg0);
  return;
}

/**
 * callback_tests_outparam_enum:
 * @callback: (scope call):
 * @arg0: (out) (transfer none):
 */
void
callback_tests_outparam_enum (CallbackTestsCallbackOutEnum callback, CallbackTestsEnum* arg0)
{
  callback (arg0);
  return;
}

/**
 * callback_tests_outparam_flags:
 * @callback: (scope call):
 * @arg0: (out) (transfer none):
 */
void
callback_tests_outparam_flags (CallbackTestsCallbackOutFlags callback, CallbackTestsFlags* arg0)
{
  callback (arg0);
  return;
}

/**
 * callback_tests_outparam_array:
 * @callback: (scope call):
 * @arg0: (out) (array length=len) (transfer none):
 * @len: (out) (transfer none):
 */
void
callback_tests_outparam_array (CallbackTestsCallbackOutArray callback, gint** arg0, gint* len)
{
  callback (arg0, len);
  return;
}

/**
 * callback_tests_outparam_list:
 * @callback: (scope call):
 * @arg0: (out) (element-type gint) (transfer none):
 */
void
callback_tests_outparam_list (CallbackTestsCallbackOutList callback, GList** arg0)
{
  callback (arg0);
  return;
}

/**
 * callback_tests_outparam_transfer_none:
 * @callback: (scope call):
 * @arg0: (out) (transfer none):
 */
void
callback_tests_outparam_transfer_none (CallbackTestsCallbackOutTransferNone callback, const gchar** arg0)
{
  callback (arg0);
  return;
}

/**
 * callback_tests_outparam_transfer_full:
 * @callback: (scope call):
 * @arg0: (out) (transfer full):
 */
void
callback_tests_outparam_transfer_full (CallbackTestsCallbackOutTransferFull callback, gchar** arg0)
{
  callback (arg0);
  return;
}

/**
 * callback_tests_outparam_transfer_container:
 * @callback: (scope call):
 * @arg0: (out) (array length=len) (transfer container):
 * @len: (out):
 */
void
callback_tests_outparam_transfer_container (CallbackTestsCallbackOutTransferContainer callback, gchar** arg0, gint* len)
{
  callback (arg0, len);
  return;
}

/**
 * callback_tests_inoutparam_gboolean:
 * @callback: (scope call):
 * @arg0: (inout):
 */
void
callback_tests_inoutparam_gboolean (CallbackTestsCallbackInOutBoolean callback, gboolean* arg0)
{
  callback (arg0);
  return;
}

/**
 * callback_tests_inoutparam_gint8:
 * @callback: (scope call):
 * @arg0: (inout):
 */
void
callback_tests_inoutparam_gint8 (CallbackTestsCallbackInOutInt8 callback, gint8* arg0)
{
  callback (arg0);
  return;
}

/**
 * callback_tests_inoutparam_guint8:
 * @callback: (scope call):
 * @arg0: (inout):
 */
void
callback_tests_inoutparam_guint8 (CallbackTestsCallbackInOutUint8 callback, guint8* arg0)
{
  callback (arg0);
  return;
}

/**
 * callback_tests_inoutparam_gint16:
 * @callback: (scope call):
 * @arg0: (inout):
 */
void
callback_tests_inoutparam_gint16 (CallbackTestsCallbackInOutInt16 callback, gint16* arg0)
{
  callback (arg0);
  return;
}

/**
 * callback_tests_inoutparam_guint16:
 * @callback: (scope call):
 * @arg0: (inout):
 */
void
callback_tests_inoutparam_guint16 (CallbackTestsCallbackInOutUint16 callback, guint16* arg0)
{
  callback (arg0);
  return;
}

/**
 * callback_tests_inoutparam_gint32:
 * @callback: (scope call):
 * @arg0: (inout):
 */
void
callback_tests_inoutparam_gint32 (CallbackTestsCallbackInOutInt32 callback, gint32* arg0)
{
  callback (arg0);
  return;
}

/**
 * callback_tests_inoutparam_guint32:
 * @callback: (scope call):
 * @arg0: (inout):
 */
void
callback_tests_inoutparam_guint32 (CallbackTestsCallbackInOutUint32 callback, guint32* arg0)
{
  callback (arg0);
  return;
}

/**
 * callback_tests_inoutparam_gint64:
 * @callback: (scope call):
 * @arg0: (inout):
 */
void
callback_tests_inoutparam_gint64 (CallbackTestsCallbackInOutInt64 callback, gint64* arg0)
{
  callback (arg0);
  return;
}

/**
 * callback_tests_inoutparam_guint64:
 * @callback: (scope call):
 * @arg0: (inout):
 */
void
callback_tests_inoutparam_guint64 (CallbackTestsCallbackInOutUint64 callback, guint64* arg0)
{
  callback (arg0);
  return;
}

/**
 * callback_tests_inoutparam_gchar:
 * @callback: (scope call):
 * @arg0: (inout):
 */
void
callback_tests_inoutparam_gchar (CallbackTestsCallbackInOutChar callback, gchar* arg0)
{
  callback (arg0);
  return;
}

/**
 * callback_tests_inoutparam_gshort:
 * @callback: (scope call):
 * @arg0: (inout):
 */
void
callback_tests_inoutparam_gshort (CallbackTestsCallbackInOutShort callback, gshort* arg0)
{
  callback (arg0);
  return;
}

/**
 * callback_tests_inoutparam_gushort:
 * @callback: (scope call):
 * @arg0: (inout):
 */
void
callback_tests_inoutparam_gushort (CallbackTestsCallbackInOutUshort callback, gushort* arg0)
{
  callback (arg0);
  return;
}

/**
 * callback_tests_inoutparam_gint:
 * @callback: (scope call):
 * @arg0: (inout):
 */
void
callback_tests_inoutparam_gint (CallbackTestsCallbackInOutInt callback, gint* arg0)
{
  callback (arg0);
  return;
}

/**
 * callback_tests_inoutparam_guint:
 * @callback: (scope call):
 * @arg0: (inout):
 */
void
callback_tests_inoutparam_guint (CallbackTestsCallbackInOutUint callback, guint* arg0)
{
  callback (arg0);
  return;
}

/**
 * callback_tests_inoutparam_glong:
 * @callback: (scope call):
 * @arg0: (inout):
 */
void
callback_tests_inoutparam_glong (CallbackTestsCallbackInOutLong callback, glong* arg0)
{
  callback (arg0);
  return;
}

/**
 * callback_tests_inoutparam_gulong:
 * @callback: (scope call):
 * @arg0: (inout):
 */
void
callback_tests_inoutparam_gulong (CallbackTestsCallbackInOutUlong callback, gulong* arg0)
{
  callback (arg0);
  return;
}

/**
 * callback_tests_inoutparam_gsize:
 * @callback: (scope call):
 * @arg0: (inout):
 */
void
callback_tests_inoutparam_gsize (CallbackTestsCallbackInOutSize callback, gsize* arg0)
{
  callback (arg0);
  return;
}

/**
 * callback_tests_inoutparam_gssize:
 * @callback: (scope call):
 * @arg0: (inout):
 */
void
callback_tests_inoutparam_gssize (CallbackTestsCallbackInOutSsize callback, gssize* arg0)
{
  callback (arg0);
  return;
}

/**
 * callback_tests_inoutparam_gintptr:
 * @callback: (scope call):
 * @arg0: (inout):
 */
void
callback_tests_inoutparam_gintptr (CallbackTestsCallbackInOutIntPtr callback, gintptr* arg0)
{
  callback (arg0);
  return;
}

/**
 * callback_tests_inoutparam_guintptr:
 * @callback: (scope call):
 * @arg0: (inout):
 */
void
callback_tests_inoutparam_guintptr (CallbackTestsCallbackInOutUintPtr callback, guintptr* arg0)
{
  callback (arg0);
  return;
}

/**
 * callback_tests_inoutparam_gfloat:
 * @callback: (scope call):
 * @arg0: (inout):
 */
void
callback_tests_inoutparam_gfloat (CallbackTestsCallbackInOutFloat callback, gfloat* arg0)
{
  callback (arg0);
  return;
}

/**
 * callback_tests_inoutparam_gdouble:
 * @callback: (scope call):
 * @arg0: (inout):
 */
void
callback_tests_inoutparam_gdouble (CallbackTestsCallbackInOutDouble callback, gdouble* arg0)
{
  callback (arg0);
  return;
}

/**
 * callback_tests_inoutparam_gunichar:
 * @callback: (scope call):
 * @arg0: (inout):
 */
void
callback_tests_inoutparam_gunichar (CallbackTestsCallbackInOutUnichar callback, gunichar* arg0)
{
  callback (arg0);
  return;
}

/**
 * callback_tests_inoutparam_GType:
 * @callback: (scope call):
 * @arg0: (inout):
 */
void
callback_tests_inoutparam_GType (CallbackTestsCallbackInOutGType callback, GType* arg0)
{
  callback (arg0);
  return;
}

/**
 * callback_tests_inoutparam_utf8:
 * @callback: (scope call):
 * @arg0: (inout):
 */
void
callback_tests_inoutparam_utf8 (CallbackTestsCallbackInOutString callback, const gchar** arg0)
{
  callback (arg0);
  return;
}

/**
 * callback_tests_inoutparam_filename:
 * @callback: (scope call):
 * @arg0: (inout):
 */
void
callback_tests_inoutparam_filename (CallbackTestsCallbackInOutFilename callback, const gchar** arg0)
{
  callback (arg0);
  return;
}

/**
 * callback_tests_inoutparam_struct:
 * @callback: (scope call):
 * @arg0: (inout):
 */
void
callback_tests_inoutparam_struct (CallbackTestsCallbackInOutStruct callback, CallbackTestsStruct** arg0)
{
  callback (arg0);
  return;
}

/**
 * callback_tests_inoutparam_enum:
 * @callback: (scope call):
 * @arg0: (inout):
 */
void
callback_tests_inoutparam_enum (CallbackTestsCallbackInOutEnum callback, CallbackTestsEnum* arg0)
{
  callback (arg0);
  return;
}

/**
 * callback_tests_inoutparam_flags:
 * @callback: (scope call):
 * @arg0: (inout):
 */
void
callback_tests_inoutparam_flags (CallbackTestsCallbackInOutFlags callback, CallbackTestsFlags* arg0)
{
  callback (arg0);
  return;
}

/**
 * callback_tests_inoutparam_array:
 * @callback: (scope call):
 * @arg0: (inout) (array length=len):
 * @len: (inout):
 */
void
callback_tests_inoutparam_array (CallbackTestsCallbackInOutArray callback, gint** arg0, gint* len)
{
  callback (arg0, len);
  return;
}

/**
 * callback_tests_inoutparam_list:
 * @callback: (scope call):
 * @arg0: (inout) (element-type gint):
 */
void
callback_tests_inoutparam_list (CallbackTestsCallbackInOutList callback, GList** arg0)
{
  callback (arg0);
  return;
}

/**
 * callback_tests_inoutparam_transfer_none:
 * @callback: (scope call):
 * @arg0: (inout) (transfer none):
 */
void
callback_tests_inoutparam_transfer_none (CallbackTestsCallbackInOutTransferNone callback, const gchar** arg0)
{
  callback (arg0);
  return;
}

/**
 * callback_tests_inoutparam_transfer_full:
 * @callback: (scope call):
 * @arg0: (inout) (transfer full):
 */
void
callback_tests_inoutparam_transfer_full (CallbackTestsCallbackInOutTransferFull callback, gchar** arg0)
{
  callback (arg0);
  return;
}

/**
 * callback_tests_inoutparam_transfer_container:
 * @callback: (scope call):
 * @arg0: (inout) (array length=len) (transfer container):
 * @len: (inout):
 */
void
callback_tests_inoutparam_transfer_container (CallbackTestsCallbackInOutTransferContainer callback, gchar** arg0, gint* len)
{
  callback (arg0, len);
  return;
}
