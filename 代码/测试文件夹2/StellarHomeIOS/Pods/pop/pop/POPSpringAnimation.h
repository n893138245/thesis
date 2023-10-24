#import <pop/POPPropertyAnimation.h>
@interface POPSpringAnimation : POPPropertyAnimation
+ (instancetype)animation;
+ (instancetype)animationWithPropertyNamed:(NSString *)name;
@property (copy, nonatomic) id velocity;
@property (assign, nonatomic) CGFloat springBounciness;
@property (assign, nonatomic) CGFloat springSpeed;
@property (assign, nonatomic) CGFloat dynamicsTension;
@property (assign, nonatomic) CGFloat dynamicsFriction;
@property (assign, nonatomic) CGFloat dynamicsMass;
@end