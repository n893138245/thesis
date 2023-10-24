#import "FBIvarReference.h"
@implementation FBIvarReference
- (instancetype)initWithIvar:(Ivar)ivar
{
  if (self = [super init]) {
    _name = @(ivar_getName(ivar));
    _type = [self _convertEncodingToType:ivar_getTypeEncoding(ivar)];
    _offset = ivar_getOffset(ivar);
    _index = _offset / sizeof(void *);
    _ivar = ivar;
  }
  return self;
}
- (FBType)_convertEncodingToType:(const char *)typeEncoding
{
  if (typeEncoding == NULL) {
    return FBUnknownType;
  }
  if (typeEncoding[0] == '{') {
    return FBStructType;
  }
  if (typeEncoding[0] == '@') {
    if (strncmp(typeEncoding, "@?", 2) == 0) {
      return FBBlockType;
    }
    return FBObjectType;
  }
  return FBUnknownType;
}
- (NSString *)description
{
  return [NSString stringWithFormat:@"[%@, index: %lu]", _name, (unsigned long)_index];
}
#pragma mark - FBObjectReference
- (NSUInteger)indexInIvarLayout
{
  return _index;
}
- (id)objectReferenceFromObject:(id)object
{
  return object_getIvar(object, _ivar);
}
- (NSArray<NSString *> *)namePath
{
  return @[@(ivar_getName(_ivar))];
}
@end