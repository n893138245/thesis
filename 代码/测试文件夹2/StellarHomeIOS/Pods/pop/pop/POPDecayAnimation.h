#import <pop/POPPropertyAnimation.h>
@interface POPDecayAnimation : POPPropertyAnimation
+ (instancetype)animation;
+ (instancetype)animationWithPropertyNamed:(NSString *)name;
@property (copy, nonatomic) id velocity;
@property (copy, nonatomic, readonly) id originalVelocity;
@property (assign, nonatomic) CGFloat deceleration;
@property (readonly, assign, nonatomic) CFTimeInterval duration;
- (void)setToValue:(id)toValue NS_UNAVAILABLE;
- (id)reversedVelocity;
@end