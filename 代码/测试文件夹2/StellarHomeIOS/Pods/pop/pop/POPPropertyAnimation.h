#import <pop/POPAnimatableProperty.h>
#import <pop/POPAnimation.h>
typedef NS_OPTIONS(NSUInteger, POPAnimationClampFlags)
{
  kPOPAnimationClampNone        = 0,
  kPOPAnimationClampStart       = 1UL << 0,
  kPOPAnimationClampEnd         = 1UL << 1,
  kPOPAnimationClampBoth = kPOPAnimationClampStart | kPOPAnimationClampEnd,
};
@interface POPPropertyAnimation : POPAnimation
@property (strong, nonatomic) POPAnimatableProperty *property;
@property (copy, nonatomic) id fromValue;
@property (copy, nonatomic) id toValue;
@property (assign, nonatomic) CGFloat roundingFactor;
@property (assign, nonatomic) NSUInteger clampMode;
@property (assign, nonatomic, getter = isAdditive) BOOL additive;
@end
@interface POPPropertyAnimation (CustomProperty)
+ (instancetype)animationWithCustomPropertyNamed:(NSString *)name
                                       readBlock:(POPAnimatablePropertyReadBlock)readBlock
                                      writeBlock:(POPAnimatablePropertyWriteBlock)writeBlock;
+ (instancetype)animationWithCustomPropertyReadBlock:(POPAnimatablePropertyReadBlock)readBlock
                                          writeBlock:(POPAnimatablePropertyWriteBlock)writeBlock;
@end