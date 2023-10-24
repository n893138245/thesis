#import <Foundation/Foundation.h>
@protocol POPAnimatorDelegate;
@interface POPAnimator : NSObject
+ (instancetype)sharedAnimator;
#if !TARGET_OS_IPHONE
- (instancetype)initWithDisplayID:(CGDirectDisplayID)displayID;
#endif
@property (weak, nonatomic) id<POPAnimatorDelegate> delegate;
@property (readonly, nonatomic) CFTimeInterval refreshPeriod;
@end
@protocol POPAnimatorDelegate <NSObject>
- (void)animatorWillAnimate:(POPAnimator *)animator;
- (void)animatorDidAnimate:(POPAnimator *)animator;
@end