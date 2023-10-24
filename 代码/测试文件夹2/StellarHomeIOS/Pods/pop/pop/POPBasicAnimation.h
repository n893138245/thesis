#import <pop/POPPropertyAnimation.h>
@interface POPBasicAnimation : POPPropertyAnimation
+ (instancetype)animation;
+ (instancetype)animationWithPropertyNamed:(NSString *)name;
+ (instancetype)defaultAnimation;
+ (instancetype)linearAnimation;
+ (instancetype)easeInAnimation;
+ (instancetype)easeOutAnimation;
+ (instancetype)easeInEaseOutAnimation;
@property (assign, nonatomic) CFTimeInterval duration;
@property (strong, nonatomic) CAMediaTimingFunction *timingFunction;
@end