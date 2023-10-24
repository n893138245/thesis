#import <QuartzCore/CAAnimation.h>
#import <pop/POPDefines.h>
#import <pop/POPSpringAnimation.h>
extern CGFloat POPAnimationDragCoefficient(void);
@interface CAAnimation (POPAnimationExtras)
- (void)pop_applyDragCoefficient;
@end
@interface POPSpringAnimation (POPAnimationExtras)
+ (void)convertBounciness:(CGFloat)bounciness speed:(CGFloat)speed toTension:(CGFloat *)outTension friction:(CGFloat *)outFriction mass:(CGFloat *)outMass;
+ (void)convertTension:(CGFloat)tension friction:(CGFloat)friction toBounciness:(CGFloat *)outBounciness speed:(CGFloat *)outSpeed;
@end