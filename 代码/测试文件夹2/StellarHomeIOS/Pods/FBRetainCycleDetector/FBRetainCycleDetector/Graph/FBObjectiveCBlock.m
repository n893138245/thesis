#import "FBObjectiveCBlock.h"
#import <objc/runtime.h>
#import "FBBlockStrongLayout.h"
#import "FBBlockStrongRelationDetector.h"
#import "FBObjectGraphConfiguration.h"
#import "FBObjectiveCObject.h"
#import "FBRetainCycleUtils.h"
struct __attribute__((packed)) BlockLiteral {
  void *isa;
  int flags;
  int reserved;
  void *invoke;
  void *descriptor;
};
@implementation FBObjectiveCBlock
- (NSSet *)allRetainedObjects
{
  NSMutableArray *results = [[[super allRetainedObjects] allObjects] mutableCopy];
  __attribute__((objc_precise_lifetime)) id anObject = self.object;
  void *blockObjectReference = (__bridge void *)anObject;
  NSArray *allRetainedReferences = FBGetBlockStrongReferences(blockObjectReference);
  for (id object in allRetainedReferences) {
    FBObjectiveCGraphElement *element = FBWrapObjectGraphElement(self, object, self.configuration);
    if (element) {
      [results addObject:element];
    }
  }
  return [NSSet setWithArray:results];
}
- (NSString *)classNameOrNull
{
  NSString *className = NSStringFromClass([self objectClass]);
  if (!className) {
    className = @"(null)";
  }
  if (!self.configuration.shouldIncludeBlockAddress) {
    return className;
  }
  __attribute__((objc_precise_lifetime)) id anObject = self.object;
  if ([anObject isKindOfClass:[FBBlockStrongRelationDetector class]]) {
    FBBlockStrongRelationDetector *blockObject = anObject;
    anObject = [blockObject forwarding];
  }
  void *blockObjectReference = (__bridge void *)anObject;
  if (!blockObjectReference) {
    return className;
  }
  const struct BlockLiteral *block = (struct BlockLiteral*) blockObjectReference;
  const void *blockCodePtr = block->invoke;
  return [NSString stringWithFormat:@"<<%@:0x%llx>>", className, (unsigned long long)blockCodePtr];
}
@end