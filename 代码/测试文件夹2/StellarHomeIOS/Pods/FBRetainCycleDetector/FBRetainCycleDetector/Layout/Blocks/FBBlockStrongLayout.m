#if __has_feature(objc_arc)
#error This file must be compiled with MRR. Use -fno-objc-arc flag.
#endif
#import "FBBlockStrongLayout.h"
#import <objc/runtime.h>
#import "FBBlockInterface.h"
#import "FBBlockStrongRelationDetector.h"
static NSIndexSet *_GetBlockStrongLayout(void *block) {
  struct BlockLiteral *blockLiteral = block;
  if ((blockLiteral->flags & BLOCK_HAS_CTOR)
      || !(blockLiteral->flags & BLOCK_HAS_COPY_DISPOSE)) {
    return nil;
  }
  void (*dispose_helper)(void *src) = blockLiteral->descriptor->dispose_helper;
  const size_t ptrSize = sizeof(void *);
  const size_t elements = (blockLiteral->descriptor->size + ptrSize - 1) / ptrSize;
  void *obj[elements];
  void *detectors[elements];
  for (size_t i = 0; i < elements; ++i) {
    FBBlockStrongRelationDetector *detector = [FBBlockStrongRelationDetector new];
    obj[i] = detectors[i] = detector;
  }
  @autoreleasepool {
    dispose_helper(obj);
  }
  NSMutableIndexSet *layout = [NSMutableIndexSet indexSet];
  for (size_t i = 0; i < elements; ++i) {
    FBBlockStrongRelationDetector *detector = (FBBlockStrongRelationDetector *)(detectors[i]);
    if (detector.isStrong) {
      [layout addIndex:i];
    }
    [detector trueRelease];
  }
  return layout;
}
NSArray *FBGetBlockStrongReferences(void *block) {
  if (!FBObjectIsBlock(block)) {
    return nil;
  }
  NSMutableArray *results = [NSMutableArray new];
  void **blockReference = block;
  NSIndexSet *strongLayout = _GetBlockStrongLayout(block);
  [strongLayout enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
    void **reference = &blockReference[idx];
    if (reference && (*reference)) {
      id object = (id)(*reference);
      if (object) {
        [results addObject:object];
      }
    }
  }];
  return [results autorelease];
}
static Class _BlockClass() {
  static dispatch_once_t onceToken;
  static Class blockClass;
  dispatch_once(&onceToken, ^{
    void (^testBlock)() = [^{} copy];
    blockClass = [testBlock class];
    while(class_getSuperclass(blockClass) && class_getSuperclass(blockClass) != [NSObject class]) {
      blockClass = class_getSuperclass(blockClass);
    }
    [testBlock release];
  });
  return blockClass;
}
BOOL FBObjectIsBlock(void *object) {
  Class blockClass = _BlockClass();
  Class candidate = object_getClass((__bridge id)object);
  return [candidate isSubclassOfClass:blockClass];
}