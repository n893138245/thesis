#import <objc/runtime.h>
#import <Foundation/Foundation.h>
#import "FBObjectReference.h"
typedef NS_ENUM(NSUInteger, FBType) {
  FBObjectType,
  FBBlockType,
  FBStructType,
  FBUnknownType,
};
@interface FBIvarReference : NSObject <FBObjectReference>
@property (nonatomic, copy, readonly, nullable) NSString *name;
@property (nonatomic, readonly) FBType type;
@property (nonatomic, readonly) ptrdiff_t offset;
@property (nonatomic, readonly) NSUInteger index;
@property (nonatomic, readonly, nonnull) Ivar ivar;
- (nonnull instancetype)initWithIvar:(nonnull Ivar)ivar;
@end