#ifndef __NAMESPACETESTS_H__
#define __NAMESPACETESTS_H__

#include <glib-object.h>


typedef enum
{
  SIGNAL_TESTS_ENUM_VALUE1,
  SIGNAL_TESTS_ENUM_VALUE2,
  SIGNAL_TESTS_ENUM_VALUE3
} SignalTestsEnum;

GType signal_tests_enum_get_type (void) G_GNUC_CONST;
#define SIGNAL_TESTS_TYPE_ENUM (signal_tests_enum_get_type ())


typedef enum
{
  SIGNAL_TESTS_FLAGS_VALUE1 = 1 << 0,
  SIGNAL_TESTS_FLAGS_VALUE2 = 1 << 1,
  SIGNAL_TESTS_FLAGS_VALUE3 = 1 << 2
} SignalTestsFlags;

GType signal_tests_flags_get_type (void) G_GNUC_CONST;
#define SIGNAL_TESTS_TYPE_FLAGS (signal_tests_flags_get_type ())


typedef struct SignalTestsBoxedStruct {
    gint32 x;
} SignalTestsBoxedStruct;

GType signal_tests_boxed_struct_get_type (void) G_GNUC_CONST;
#define SIGNAL_TESTS_TYPE_BOXED_STRUCT (signal_tests_boxed_struct_get_type ())


#define SIGNAL_TESTS_TYPE_OBJECT             (signal_tests_object_get_type ())
#define SIGNAL_TESTS_OBJECT(obj)             (G_TYPE_CHECK_INSTANCE_CAST ((obj), SIGNAL_TESTS_TYPE_OBJECT, SignalTestsObject))
#define SIGNAL_TESTS_OBJECT_CLASS(klass)     (G_TYPE_CHECK_CLASS_CAST ((klass), SIGNAL_TESTS_TYPE_OBJECT, SignalTestsObjectClass))
#define SIGNAL_TESTS_IS_OBJECT(obj)          (G_TYPE_CHECK_INSTANCE_TYPE ((obj), SIGNAL_TESTS_TYPE_OBJECT))
#define SIGNAL_TESTS_IS_OBJECT_CLASS(klass)  (G_TYPE_CHECK_CLASS_TYPE ((klass), SIGNAL_TESTS_TYPE_OBJECT))
#define SIGNAL_TESTS_OBJECT_GET_CLASS(obj)   (G_TYPE_INSTANCE_GET_CLASS ((obj), SIGNAL_TESTS_TYPE_OBJECT, SignalTestsObjectClass))

typedef struct _SignalTestsObjectClass SignalTestsObjectClass;
typedef struct _SignalTestsObject SignalTestsObject;

struct _SignalTestsObjectClass
{
	GObjectClass parent_class;
};

struct _SignalTestsObject
{
	GObject parent_instance;
};

GType signal_tests_object_get_type (void) G_GNUC_CONST;

#endif
