#ifndef __NAMESPACETESTS_H__
#define __NAMESPACETESTS_H__

#include <glib-object.h>


typedef enum
{
  NAMESPACE_TESTS_ENUM_VALUE1,
  NAMESPACE_TESTS_ENUM_VALUE2,
  NAMESPACE_TESTS_ENUM_VALUE3
} NamespaceTestsEnum;

typedef enum
{
  NAMESPACE_TESTS_FLAGS_VALUE1 = 1 << 0,
  NAMESPACE_TESTS_FLAGS_VALUE2 = 1 << 1,
  NAMESPACE_TESTS_FLAGS_VALUE3 = 1 << 2
} NamespaceTestsFlags;

typedef struct NamespaceTestsStruct {
    gint32 x;
} NamespaceTestsStruct;

typedef union {
    gint32 x;
} NamespaceTestsUnion;

#define NAMESPACE_TESTS_TYPE_OBJECT             (namespace_tests_object_get_type ())
#define NAMESPACE_TESTS_OBJECT(obj)             (G_TYPE_CHECK_INSTANCE_CAST ((obj), NAMESPACE_TESTS_TYPE_OBJECT, NamespaceTestsObject))
#define NAMESPACE_TESTS_OBJECT_CLASS(klass)     (G_TYPE_CHECK_CLASS_CAST ((klass), NAMESPACE_TESTS_TYPE_OBJECT, NamespaceTestsObjectClass))
#define NAMESPACE_TESTS_IS_OBJECT(obj)          (G_TYPE_CHECK_INSTANCE_TYPE ((obj), NAMESPACE_TESTS_TYPE_OBJECT))
#define NAMESPACE_TESTS_IS_OBJECT_CLASS(klass)  (G_TYPE_CHECK_CLASS_TYPE ((klass), NAMESPACE_TESTS_TYPE_OBJECT))
#define NAMESPACE_TESTS_OBJECT_GET_CLASS(obj)   (G_TYPE_INSTANCE_GET_CLASS ((obj), NAMESPACE_TESTS_TYPE_OBJECT, NamespaceTestsObjectClass))

typedef struct _NamespaceTestsObjectClass NamespaceTestsObjectClass;
typedef struct _NamespaceTestsObject NamespaceTestsObject;

struct _NamespaceTestsObjectClass
{
	GObjectClass parent_class;
};

struct _NamespaceTestsObject
{
	GObject parent_instance;
};

GType namespace_tests_object_get_type (void) G_GNUC_CONST;

void
namespace_tests_function (void);


/**
 * NamespaceTestsCallback:
 */
typedef void (* NamespaceTestsCallback) (void);

#endif
