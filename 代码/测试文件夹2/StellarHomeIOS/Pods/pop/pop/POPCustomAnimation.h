#import <pop/POPAnimation.h>
@class POPCustomAnimation;
typedef BOOL (^POPCustomAnimationBlock)(id target, POPCustomAnimation *animation);
@interface POPCustomAnimation : POPAnimation
+ (instancetype)animationWithBlock:(POPCustomAnimationBlock)block;
@property (readonly, nonatomic) CFTimeInterval currentTime;
@property (readonly, nonatomic) CFTimeInterval elapsedTime;
@end