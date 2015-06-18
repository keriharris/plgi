#include "namespacetests.h"

/**
 * namespace_tests_function:
 */
void
namespace_tests_function (void)
{
  return;
}


static void
namespace_tests_object_init (NamespaceTestsObject *object)
{
}

G_DEFINE_TYPE (NamespaceTestsObject, namespace_tests_object, G_TYPE_OBJECT);

static void
namespace_tests_object_class_init (NamespaceTestsObjectClass *klass)
{
}
