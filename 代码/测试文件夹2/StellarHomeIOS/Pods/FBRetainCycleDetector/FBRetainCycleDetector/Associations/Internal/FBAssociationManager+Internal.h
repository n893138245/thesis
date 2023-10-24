#import "FBAssociationManager.h"
#import "FBRetainCycleDetector.h"
#if _INTERNAL_RCD_ENABLED
namespace FB { namespace AssociationManager {
  void _threadUnsafeResetAssociationAtKey(id object, void *key);
  void _threadUnsafeSetStrongAssociation(id object, void *key, id value);
  void _threadUnsafeRemoveAssociations(id object);
  NSArray *associations(id object);
} }
#endif