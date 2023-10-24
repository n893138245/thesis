#import "FBObjectiveCObject.h"
#import <objc/runtime.h>
#import "FBClassStrongLayout.h"
#import "FBObjectGraphConfiguration.h"
#import "FBObjectReference.h"
#import "FBRetainCycleUtils.h"
@implementation FBObjectiveCObject
- (NSSet *)allRetainedObjects
{
  Class aCls = object_getClass(self.object);
  if (!self.object || !aCls) {
    return nil;
  }
  NSArray *strongIvars = FBGetObjectStrongReferences(self.object, self.configuration.layoutCache);
  NSMutableArray *retainedObjects = [[[super allRetainedObjects] allObjects] mutableCopy];
  for (id<FBObjectReference> ref in strongIvars) {
    id referencedObject = [ref objectReferenceFromObject:self.object];
    if (referencedObject) {
      NSArray<NSString *> *namePath = [ref namePath];
      FBObjectiveCGraphElement *element = FBWrapObjectGraphElementWithContext(self,
                                                                              referencedObject,
                                                                              self.configuration,
                                                                              namePath);
      if (element) {
        [retainedObjects addObject:element];
      }
    }
  }
  if ([NSStringFromClass(aCls) hasPrefix:@"__NSCF"]) {
    return [NSSet setWithArray:retainedObjects];
  }
  if (class_isMetaClass(aCls)) {
    return nil;
  }
  if ([aCls conformsToProtocol:@protocol(NSFastEnumeration)]) {
    BOOL retainsKeys = [self _objectRetainsEnumerableKeys];
    BOOL retainsValues = [self _objectRetainsEnumerableValues];
    BOOL isKeyValued = NO;
    if ([aCls instancesRespondToSelector:@selector(objectForKey:)]) {
      isKeyValued = YES;
    }
    NSInteger tries = 10;
    for (NSInteger i = 0; i < tries; ++i) {
      NSMutableSet *temporaryRetainedObjects = [NSMutableSet new];
      @try {
        for (id subobject in self.object) {
          if (retainsKeys) {
            FBObjectiveCGraphElement *element = FBWrapObjectGraphElement(self, subobject, self.configuration);
            if (element) {
              [temporaryRetainedObjects addObject:element];
            }
          }
          if (isKeyValued && retainsValues) {
            FBObjectiveCGraphElement *element = FBWrapObjectGraphElement(self,
                                                                         [self.object objectForKey:subobject],
                                                                         self.configuration);
            if (element) {
              [temporaryRetainedObjects addObject:element];
            }
          }
        }
      }
      @catch (NSException *exception) {
        continue;
      }
      [retainedObjects addObjectsFromArray:[temporaryRetainedObjects allObjects]];
      break;
    }
  }
  return [NSSet setWithArray:retainedObjects];
}
- (BOOL)_objectRetainsEnumerableValues
{
  if ([self.object respondsToSelector:@selector(valuePointerFunctions)]) {
    NSPointerFunctions *pointerFunctions = [self.object valuePointerFunctions];
    if (pointerFunctions.acquireFunction == NULL) {
      return NO;
    }
    if (pointerFunctions.usesWeakReadAndWriteBarriers) {
      return NO;
    }
  }
  return YES;
}
- (BOOL)_objectRetainsEnumerableKeys
{
  if ([self.object respondsToSelector:@selector(pointerFunctions)]) {
    NSPointerFunctions *pointerFunctions = [self.object pointerFunctions];
    if (pointerFunctions.acquireFunction == NULL) {
      return NO;
    }
    if (pointerFunctions.usesWeakReadAndWriteBarriers) {
      return NO;
    }
  }
  if ([self.object respondsToSelector:@selector(keyPointerFunctions)]) {
    NSPointerFunctions *pointerFunctions = [self.object keyPointerFunctions];
    if (pointerFunctions.acquireFunction == NULL) {
      return NO;
    }
    if (pointerFunctions.usesWeakReadAndWriteBarriers) {
      return NO;
    }
  }
  return YES;
}
@end