#include "signaltests.h"


GType
signal_tests_enum_get_type(void)
{
  static GType type = 0;
  if ( G_UNLIKELY(type == 0) )
    {
      static const GEnumValue values[] = {
        {SIGNAL_TESTS_ENUM_VALUE1,
         "SIGNAL_TESTS_ENUM_VALUE1", "value1"},
        {SIGNAL_TESTS_ENUM_VALUE2,
         "SIGNAL_TESTS_ENUM_VALUE2", "value2"},
        {SIGNAL_TESTS_ENUM_VALUE3,
         "SIGNAL_TESTS_ENUM_VALUE3", "value3"},
        {0, NULL, NULL}
      };
      type = g_enum_register_static("SignalTestsEnum", values);
    }

  return type;
}


GType
signal_tests_flags_get_type(void)
{
  static GType type = 0;
  if ( G_UNLIKELY(type == 0) )
  {
    static const GFlagsValue values[] = {
        {SIGNAL_TESTS_FLAGS_VALUE1,
         "SIGNAL_TESTS_FLAGS_VALUE1", "value1"},
        {SIGNAL_TESTS_FLAGS_VALUE2,
         "SIGNAL_TESTS_FLAGS_VALUE2", "value2"},
        {SIGNAL_TESTS_FLAGS_VALUE3,
         "SIGNAL_TESTS_FLAGS_VALUE3", "value3"},
        {0, NULL, NULL}
    };
    type = g_flags_register_static("SignalTestsFlags", values);
  }

  return type;
}


static SignalTestsBoxedStruct*
signal_tests_boxed_struct_copy(SignalTestsBoxedStruct *struct_)
{
  SignalTestsBoxedStruct *copy;

  if (struct_ == NULL)
  { return NULL;
  }

  copy = g_malloc0(sizeof(*copy));
  *copy = *struct_;

  return copy;
}

static void
signal_tests_boxed_struct_free(SignalTestsBoxedStruct *struct_)
{
  if (struct_ != NULL)
  { g_free(struct_);
  }
}

GType
signal_tests_boxed_struct_get_type(void)
{
  static GType gtype = 0;

  if (gtype == 0)
  {
    gtype = g_boxed_type_register_static("SignalTestsBoxedStruct",
                                         (GBoxedCopyFunc)signal_tests_boxed_struct_copy,
                                         (GBoxedFreeFunc)signal_tests_boxed_struct_free);
  }

  return gtype;
}


static void
signal_tests_object_init(SignalTestsObject *object)
{
}

G_DEFINE_TYPE (SignalTestsObject, signal_tests_object, G_TYPE_OBJECT);

static void
signal_tests_object_class_init(SignalTestsObjectClass *klass)
{
  g_signal_new("void-params",
               G_TYPE_FROM_CLASS (klass),
               G_SIGNAL_RUN_LAST,
               0,
               NULL, NULL,
               g_cclosure_marshal_VOID__VOID,
               G_TYPE_NONE, 0);

  g_signal_new("return-boolean",
               G_TYPE_FROM_CLASS (klass),
               G_SIGNAL_RUN_LAST,
               0,
               NULL, NULL,
               NULL,
               G_TYPE_BOOLEAN, 0);

  g_signal_new("return-char",
               G_TYPE_FROM_CLASS (klass),
               G_SIGNAL_RUN_LAST,
               0,
               NULL, NULL,
               NULL,
               G_TYPE_CHAR, 0);

  g_signal_new("return-uchar",
               G_TYPE_FROM_CLASS (klass),
               G_SIGNAL_RUN_LAST,
               0,
               NULL, NULL,
               NULL,
               G_TYPE_UCHAR, 0);

  g_signal_new("return-int",
               G_TYPE_FROM_CLASS (klass),
               G_SIGNAL_RUN_LAST,
               0,
               NULL, NULL,
               NULL,
               G_TYPE_INT, 0);

  g_signal_new("return-uint",
               G_TYPE_FROM_CLASS (klass),
               G_SIGNAL_RUN_LAST,
               0,
               NULL, NULL,
               NULL,
               G_TYPE_UINT, 0);

  g_signal_new("return-long",
               G_TYPE_FROM_CLASS (klass),
               G_SIGNAL_RUN_LAST,
               0,
               NULL, NULL,
               NULL,
               G_TYPE_LONG, 0);

  g_signal_new("return-ulong",
               G_TYPE_FROM_CLASS (klass),
               G_SIGNAL_RUN_LAST,
               0,
               NULL, NULL,
               NULL,
               G_TYPE_ULONG, 0);

  g_signal_new("return-int64",
               G_TYPE_FROM_CLASS (klass),
               G_SIGNAL_RUN_LAST,
               0,
               NULL, NULL,
               NULL,
               G_TYPE_INT64, 0);

  g_signal_new("return-uint64",
               G_TYPE_FROM_CLASS (klass),
               G_SIGNAL_RUN_LAST,
               0,
               NULL, NULL,
               NULL,
               G_TYPE_UINT64, 0);

  g_signal_new("return-float",
               G_TYPE_FROM_CLASS (klass),
               G_SIGNAL_RUN_LAST,
               0,
               NULL, NULL,
               NULL,
               G_TYPE_FLOAT, 0);

  g_signal_new("return-double",
               G_TYPE_FROM_CLASS (klass),
               G_SIGNAL_RUN_LAST,
               0,
               NULL, NULL,
               NULL,
               G_TYPE_DOUBLE, 0);

  g_signal_new("return-enum",
               G_TYPE_FROM_CLASS (klass),
               G_SIGNAL_RUN_LAST,
               0,
               NULL, NULL,
               NULL,
               SIGNAL_TESTS_TYPE_ENUM, 0);

  g_signal_new("return-flags",
               G_TYPE_FROM_CLASS (klass),
               G_SIGNAL_RUN_LAST,
               0,
               NULL, NULL,
               NULL,
               SIGNAL_TESTS_TYPE_FLAGS, 0);

  g_signal_new("return-string",
               G_TYPE_FROM_CLASS (klass),
               G_SIGNAL_RUN_LAST,
               0,
               NULL, NULL,
               NULL,
               G_TYPE_STRING, 0);

  /**
   * SignalTestsObject::return-param:
   * Returns: (transfer none):
   */
  g_signal_new("return-param",
               G_TYPE_FROM_CLASS (klass),
               G_SIGNAL_RUN_LAST,
               0,
               NULL, NULL,
               NULL,
               G_TYPE_PARAM, 0);

  g_signal_new("return-boxed",
               G_TYPE_FROM_CLASS (klass),
               G_SIGNAL_RUN_LAST,
               0,
               NULL, NULL,
               NULL,
               SIGNAL_TESTS_TYPE_BOXED_STRUCT, 0);

  /**
   * SignalTestsObject::return-pointer:
   * Returns: (transfer none):
   */
  g_signal_new("return-pointer",
               G_TYPE_FROM_CLASS (klass),
               G_SIGNAL_RUN_LAST,
               0,
               NULL, NULL,
               NULL,
               G_TYPE_POINTER, 0);

  /**
   * SignalTestsObject::return-object:
   * Returns: (transfer none):
   */
  g_signal_new("return-object",
               G_TYPE_FROM_CLASS (klass),
               G_SIGNAL_RUN_LAST,
               0,
               NULL, NULL,
               NULL,
               G_TYPE_OBJECT, 0);

  g_signal_new("return-gtype",
               G_TYPE_FROM_CLASS (klass),
               G_SIGNAL_RUN_LAST,
               0,
               NULL, NULL,
               NULL,
               G_TYPE_GTYPE, 0);

  /**
   * SignalTestsObject::return-variant:
   * Returns: (transfer none):
   */
  g_signal_new("return-variant",
               G_TYPE_FROM_CLASS (klass),
               G_SIGNAL_RUN_LAST,
               0,
               NULL, NULL,
               NULL,
               G_TYPE_VARIANT, 0);

  /**
   * SignalTestsObject::inparam-boolean:
   * @instance: :
   * @arg0: (in):
   */
  g_signal_new("inparam-boolean",
               G_TYPE_FROM_CLASS (klass),
               G_SIGNAL_RUN_LAST,
               0,
               NULL, NULL,
               g_cclosure_marshal_VOID__BOOLEAN,
               G_TYPE_NONE, 1,
               G_TYPE_BOOLEAN);

/**
 * SignalTestsObject::inparam-char:
 * @instance: :
 * @arg0: (in):
 */
  g_signal_new("inparam-char",
               G_TYPE_FROM_CLASS (klass),
               G_SIGNAL_RUN_LAST,
               0,
               NULL, NULL,
               g_cclosure_marshal_VOID__CHAR,
               G_TYPE_NONE, 1,
               G_TYPE_CHAR);

/**
 * SignalTestsObject::inparam-uchar:
 * @instance: :
 * @arg0: (in):
 */
  g_signal_new("inparam-uchar",
               G_TYPE_FROM_CLASS (klass),
               G_SIGNAL_RUN_LAST,
               0,
               NULL, NULL,
               g_cclosure_marshal_VOID__UCHAR,
               G_TYPE_NONE, 1,
               G_TYPE_UCHAR);

/**
 * SignalTestsObject::inparam-int:
 * @instance: :
 * @arg0: (in):
 */
  g_signal_new("inparam-int",
               G_TYPE_FROM_CLASS (klass),
               G_SIGNAL_RUN_LAST,
               0,
               NULL, NULL,
               g_cclosure_marshal_VOID__INT,
               G_TYPE_NONE, 1,
               G_TYPE_INT);

/**
 * SignalTestsObject::inparam-uint:
 * @instance: :
 * @arg0: (in):
 */
  g_signal_new("inparam-uint",
               G_TYPE_FROM_CLASS (klass),
               G_SIGNAL_RUN_LAST,
               0,
               NULL, NULL,
               g_cclosure_marshal_VOID__UINT,
               G_TYPE_NONE, 1,
               G_TYPE_UINT);

/**
 * SignalTestsObject::inparam-long:
 * @instance: :
 * @arg0: (in):
 */
  g_signal_new("inparam-long",
               G_TYPE_FROM_CLASS (klass),
               G_SIGNAL_RUN_LAST,
               0,
               NULL, NULL,
               g_cclosure_marshal_VOID__LONG,
               G_TYPE_NONE, 1,
               G_TYPE_LONG);

/**
 * SignalTestsObject::inparam-ulong:
 * @instance: :
 * @arg0: (in):
 */
  g_signal_new("inparam-ulong",
               G_TYPE_FROM_CLASS (klass),
               G_SIGNAL_RUN_LAST,
               0,
               NULL, NULL,
               g_cclosure_marshal_VOID__ULONG,
               G_TYPE_NONE, 1,
               G_TYPE_ULONG);

/**
 * SignalTestsObject::inparam-int64:
 * @instance: :
 * @arg0: (in):
 */
  g_signal_new("inparam-int64",
               G_TYPE_FROM_CLASS (klass),
               G_SIGNAL_RUN_LAST,
               0,
               NULL, NULL,
               NULL,
               G_TYPE_NONE, 1,
               G_TYPE_INT64);

/**
 * SignalTestsObject::inparam-uint64:
 * @instance: :
 * @arg0: (in):
 */
  g_signal_new("inparam-uint64",
               G_TYPE_FROM_CLASS (klass),
               G_SIGNAL_RUN_LAST,
               0,
               NULL, NULL,
               NULL,
               G_TYPE_NONE, 1,
               G_TYPE_UINT64);

/**
 * SignalTestsObject::inparam-float:
 * @instance: :
 * @arg0: (in):
 */
  g_signal_new("inparam-float",
               G_TYPE_FROM_CLASS (klass),
               G_SIGNAL_RUN_LAST,
               0,
               NULL, NULL,
               g_cclosure_marshal_VOID__FLOAT,
               G_TYPE_NONE, 1,
               G_TYPE_FLOAT);

/**
 * SignalTestsObject::inparam-double:
 * @instance: :
 * @arg0: (in):
 */
  g_signal_new("inparam-double",
               G_TYPE_FROM_CLASS (klass),
               G_SIGNAL_RUN_LAST,
               0,
               NULL, NULL,
               g_cclosure_marshal_VOID__DOUBLE,
               G_TYPE_NONE, 1,
               G_TYPE_DOUBLE);

/**
 * SignalTestsObject::inparam-enum:
 * @instance: :
 * @arg0: (in):
 */
  g_signal_new("inparam-enum",
               G_TYPE_FROM_CLASS (klass),
               G_SIGNAL_RUN_LAST,
               0,
               NULL, NULL,
               g_cclosure_marshal_VOID__ENUM,
               G_TYPE_NONE, 1,
               SIGNAL_TESTS_TYPE_ENUM);

/**
 * SignalTestsObject::inparam-flags:
 * @instance: :
 * @arg0: (in):
 */
  g_signal_new("inparam-flags",
               G_TYPE_FROM_CLASS (klass),
               G_SIGNAL_RUN_LAST,
               0,
               NULL, NULL,
               g_cclosure_marshal_VOID__FLAGS,
               G_TYPE_NONE, 1,
               SIGNAL_TESTS_TYPE_FLAGS);

/**
 * SignalTestsObject::inparam-string:
 * @instance: :
 * @arg0: (in):
 */
  g_signal_new("inparam-string",
               G_TYPE_FROM_CLASS (klass),
               G_SIGNAL_RUN_LAST,
               0,
               NULL, NULL,
               g_cclosure_marshal_VOID__STRING,
               G_TYPE_NONE, 1,
               G_TYPE_STRING);

/**
 * SignalTestsObject::inparam-param:
 * @instance: :
 * @arg0: (in):
 */
  g_signal_new("inparam-param",
               G_TYPE_FROM_CLASS (klass),
               G_SIGNAL_RUN_LAST,
               0,
               NULL, NULL,
               g_cclosure_marshal_VOID__POINTER,
               G_TYPE_NONE, 1,
               G_TYPE_PARAM);

/**
 * SignalTestsObject::inparam-boxed:
 * @instance: :
 * @arg0: (in):
 */
  g_signal_new("inparam-boxed",
               G_TYPE_FROM_CLASS (klass),
               G_SIGNAL_RUN_LAST,
               0,
               NULL, NULL,
               g_cclosure_marshal_VOID__BOXED,
               G_TYPE_NONE, 1,
               SIGNAL_TESTS_TYPE_BOXED_STRUCT);

/**
 * SignalTestsObject::inparam-pointer:
 * @instance: :
 * @arg0: (in):
 */
  g_signal_new("inparam-pointer",
               G_TYPE_FROM_CLASS (klass),
               G_SIGNAL_RUN_LAST,
               0,
               NULL, NULL,
               g_cclosure_marshal_VOID__POINTER,
               G_TYPE_NONE, 1,
               G_TYPE_POINTER);

/**
 * SignalTestsObject::inparam-object:
 * @instance: :
 * @arg0: (in):
 */
  g_signal_new("inparam-object",
               G_TYPE_FROM_CLASS (klass),
               G_SIGNAL_RUN_LAST,
               0,
               NULL, NULL,
               g_cclosure_marshal_VOID__OBJECT,
               G_TYPE_NONE, 1,
               G_TYPE_OBJECT);

/**
 * SignalTestsObject::inparam-gtype:
 * @instance: :
 * @arg0: (in):
 */
  g_signal_new("inparam-gtype",
               G_TYPE_FROM_CLASS (klass),
               G_SIGNAL_RUN_LAST,
               0,
               NULL, NULL,
               NULL,
               G_TYPE_NONE, 1,
               G_TYPE_GTYPE);

/**
 * SignalTestsObject::inparam-variant:
 * @instance: :
 * @arg0: (in):
 */
  g_signal_new("inparam-variant",
               G_TYPE_FROM_CLASS (klass),
               G_SIGNAL_RUN_LAST,
               0,
               NULL, NULL,
               g_cclosure_marshal_VOID__VARIANT,
               G_TYPE_NONE, 1,
               G_TYPE_VARIANT);

/**
 * SignalTestsObject::outparam-boolean:
 * @instance: :
 * @arg0: (out):
 */
  g_signal_new("outparam-boolean",
               G_TYPE_FROM_CLASS (klass),
               G_SIGNAL_RUN_LAST,
               0,
               NULL, NULL,
               g_cclosure_marshal_VOID__BOOLEAN,
               G_TYPE_NONE, 1,
               G_TYPE_BOOLEAN);

/**
 * SignalTestsObject::outparam-char:
 * @instance: :
 * @arg0: (out):
 */
  g_signal_new("outparam-char",
               G_TYPE_FROM_CLASS (klass),
               G_SIGNAL_RUN_LAST,
               0,
               NULL, NULL,
               g_cclosure_marshal_VOID__CHAR,
               G_TYPE_NONE, 1,
               G_TYPE_CHAR);

/**
 * SignalTestsObject::outparam-uchar:
 * @instance: :
 * @arg0: (out):
 */
  g_signal_new("outparam-uchar",
               G_TYPE_FROM_CLASS (klass),
               G_SIGNAL_RUN_LAST,
               0,
               NULL, NULL,
               g_cclosure_marshal_VOID__UCHAR,
               G_TYPE_NONE, 1,
               G_TYPE_UCHAR);

/**
 * SignalTestsObject::outparam-int:
 * @instance: :
 * @arg0: (out):
 */
  g_signal_new("outparam-int",
               G_TYPE_FROM_CLASS (klass),
               G_SIGNAL_RUN_LAST,
               0,
               NULL, NULL,
               g_cclosure_marshal_VOID__INT,
               G_TYPE_NONE, 1,
               G_TYPE_INT);

/**
 * SignalTestsObject::outparam-uint:
 * @instance: :
 * @arg0: (out):
 */
  g_signal_new("outparam-uint",
               G_TYPE_FROM_CLASS (klass),
               G_SIGNAL_RUN_LAST,
               0,
               NULL, NULL,
               g_cclosure_marshal_VOID__UINT,
               G_TYPE_NONE, 1,
               G_TYPE_UINT);

/**
 * SignalTestsObject::outparam-long:
 * @instance: :
 * @arg0: (out):
 */
  g_signal_new("outparam-long",
               G_TYPE_FROM_CLASS (klass),
               G_SIGNAL_RUN_LAST,
               0,
               NULL, NULL,
               g_cclosure_marshal_VOID__LONG,
               G_TYPE_NONE, 1,
               G_TYPE_LONG);

/**
 * SignalTestsObject::outparam-ulong:
 * @instance: :
 * @arg0: (out):
 */
  g_signal_new("outparam-ulong",
               G_TYPE_FROM_CLASS (klass),
               G_SIGNAL_RUN_LAST,
               0,
               NULL, NULL,
               g_cclosure_marshal_VOID__ULONG,
               G_TYPE_NONE, 1,
               G_TYPE_ULONG);

/**
 * SignalTestsObject::outparam-int64:
 * @instance: :
 * @arg0: (out):
 */
  g_signal_new("outparam-int64",
               G_TYPE_FROM_CLASS (klass),
               G_SIGNAL_RUN_LAST,
               0,
               NULL, NULL,
               NULL,
               G_TYPE_NONE, 1,
               G_TYPE_INT64);

/**
 * SignalTestsObject::outparam-uint64:
 * @instance: :
 * @arg0: (out):
 */
  g_signal_new("outparam-uint64",
               G_TYPE_FROM_CLASS (klass),
               G_SIGNAL_RUN_LAST,
               0,
               NULL, NULL,
               NULL,
               G_TYPE_NONE, 1,
               G_TYPE_UINT64);

/**
 * SignalTestsObject::outparam-float:
 * @instance: :
 * @arg0: (out):
 */
  g_signal_new("outparam-float",
               G_TYPE_FROM_CLASS (klass),
               G_SIGNAL_RUN_LAST,
               0,
               NULL, NULL,
               g_cclosure_marshal_VOID__FLOAT,
               G_TYPE_NONE, 1,
               G_TYPE_FLOAT);

/**
 * SignalTestsObject::outparam-double:
 * @instance: :
 * @arg0: (out):
 */
  g_signal_new("outparam-double",
               G_TYPE_FROM_CLASS (klass),
               G_SIGNAL_RUN_LAST,
               0,
               NULL, NULL,
               g_cclosure_marshal_VOID__DOUBLE,
               G_TYPE_NONE, 1,
               G_TYPE_DOUBLE);

/**
 * SignalTestsObject::outparam-enum:
 * @instance: :
 * @arg0: (out):
 */
  g_signal_new("outparam-enum",
               G_TYPE_FROM_CLASS (klass),
               G_SIGNAL_RUN_LAST,
               0,
               NULL, NULL,
               g_cclosure_marshal_VOID__ENUM,
               G_TYPE_NONE, 1,
               SIGNAL_TESTS_TYPE_ENUM);

/**
 * SignalTestsObject::outparam-flags:
 * @instance: :
 * @arg0: (out):
 */
  g_signal_new("outparam-flags",
               G_TYPE_FROM_CLASS (klass),
               G_SIGNAL_RUN_LAST,
               0,
               NULL, NULL,
               g_cclosure_marshal_VOID__FLAGS,
               G_TYPE_NONE, 1,
               SIGNAL_TESTS_TYPE_FLAGS);

/**
 * SignalTestsObject::outparam-string:
 * @instance: :
 * @arg0: (out):
 */
  g_signal_new("outparam-string",
               G_TYPE_FROM_CLASS (klass),
               G_SIGNAL_RUN_LAST,
               0,
               NULL, NULL,
               g_cclosure_marshal_VOID__STRING,
               G_TYPE_NONE, 1,
               G_TYPE_STRING);

/**
 * SignalTestsObject::outparam-param:
 * @instance: :
 * @arg0: (out):
 */
  g_signal_new("outparam-param",
               G_TYPE_FROM_CLASS (klass),
               G_SIGNAL_RUN_LAST,
               0,
               NULL, NULL,
               g_cclosure_marshal_VOID__POINTER,
               G_TYPE_NONE, 1,
               G_TYPE_PARAM);

/**
 * SignalTestsObject::outparam-boxed:
 * @instance: :
 * @arg0: (out):
 */
  g_signal_new("outparam-boxed",
               G_TYPE_FROM_CLASS (klass),
               G_SIGNAL_RUN_LAST,
               0,
               NULL, NULL,
               g_cclosure_marshal_VOID__BOXED,
               G_TYPE_NONE, 1,
               SIGNAL_TESTS_TYPE_BOXED_STRUCT);

/**
 * SignalTestsObject::outparam-pointer:
 * @instance: :
 * @arg0: (out):
 */
  g_signal_new("outparam-pointer",
               G_TYPE_FROM_CLASS (klass),
               G_SIGNAL_RUN_LAST,
               0,
               NULL, NULL,
               g_cclosure_marshal_VOID__POINTER,
               G_TYPE_NONE, 1,
               G_TYPE_POINTER);

/**
 * SignalTestsObject::outparam-object:
 * @instance: :
 * @arg0: (out):
 */
  g_signal_new("outparam-object",
               G_TYPE_FROM_CLASS (klass),
               G_SIGNAL_RUN_LAST,
               0,
               NULL, NULL,
               g_cclosure_marshal_VOID__OBJECT,
               G_TYPE_NONE, 1,
               G_TYPE_OBJECT);

/**
 * SignalTestsObject::outparam-gtype:
 * @instance: :
 * @arg0: (out):
 */
  g_signal_new("outparam-gtype",
               G_TYPE_FROM_CLASS (klass),
               G_SIGNAL_RUN_LAST,
               0,
               NULL, NULL,
               NULL,
               G_TYPE_NONE, 1,
               G_TYPE_GTYPE);

/**
 * SignalTestsObject::outparam-variant:
 * @instance: :
 * @arg0: (out):
 */
  g_signal_new("outparam-variant",
               G_TYPE_FROM_CLASS (klass),
               G_SIGNAL_RUN_LAST,
               0,
               NULL, NULL,
               g_cclosure_marshal_VOID__VARIANT,
               G_TYPE_NONE, 1,
               G_TYPE_VARIANT);
}
