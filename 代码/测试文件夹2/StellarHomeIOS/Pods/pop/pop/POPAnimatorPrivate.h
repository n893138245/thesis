#import <pop/POPAnimator.h>
@class POPAnimation;
@protocol POPAnimatorObserving <NSObject>
@required
- (void)animatorDidAnimate:(POPAnimator *)animator;
@end
@interface POPAnimator ()
#if !TARGET_OS_IPHONE
+ (BOOL)disableBackgroundThread;
+ (void)setDisableBackgroundThread:(BOOL)flag;
+ (uint64_t)displayTimerFrequency;
+ (void)setDisplayTimerFrequency:(uint64_t)frequency;
#endif
@property (assign, nonatomic) BOOL disableDisplayLink;
@property (assign, nonatomic) CFTimeInterval beginTime;
- (void)renderTime:(CFTimeInterval)time;
- (void)addAnimation:(POPAnimation *)anim forObject:(id)obj key:(NSString *)key;
- (void)removeAllAnimationsForObject:(id)obj;
- (void)removeAnimationForObject:(id)obj key:(NSString *)key;
- (NSArray *)animationKeysForObject:(id)obj;
- (POPAnimation *)animationForObject:(id)obj key:(NSString *)key;
- (void)addObserver:(id<POPAnimatorObserving>)observer;
- (void)removeObserver:(id<POPAnimatorObserving>)observer;
@end