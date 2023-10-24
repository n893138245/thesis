#import "FBObjectInStructReference.h"
#import "FBClassStrongLayoutHelpers.h"
@implementation FBObjectInStructReference
{
  NSUInteger _index;
  NSArray<NSString *> *_namePath;
}
- (instancetype)initWithIndex:(NSUInteger)index
                     namePath:(NSArray<NSString *> *)namePath
{
  if (self = [super init]) {
    _index = index;
    _namePath = namePath;
  }
  return self;
}
- (NSString *)description
{
  return [NSString stringWithFormat:@"[in_struct; index: %td]", _index];
}
#pragma mark - FBObjectReference
- (id)objectReferenceFromObject:(id)object
{
  return FBExtractObjectByOffset(object, _index);
}
- (NSUInteger)indexInIvarLayout
{
  return _index;
}
- (NSArray<NSString *> *)namePath
{
  return _namePath;
}
@end