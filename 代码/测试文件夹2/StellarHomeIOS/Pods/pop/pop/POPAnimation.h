#import <Foundation/NSObject.h>
#import <pop/POPAnimationTracer.h>
#import <pop/POPGeometry.h>
@class CAMediaTimingFunction;
@interface POPAnimation : NSObject
@property (copy, nonatomic) NSString *name;
@property (assign, nonatomic) CFTimeInterval beginTime;
@property (weak, nonatomic) id delegate;
@property (readonly, nonatomic) POPAnimationTracer *tracer;
@property (copy, nonatomic) void (^animationDidStartBlock)(POPAnimation *anim);
@property (copy, nonatomic) void (^animationDidReachToValueBlock)(POPAnimation *anim);
@property (copy, nonatomic) void (^completionBlock)(POPAnimation *anim, BOOL finished);
@property (copy, nonatomic) void (^animationDidApplyBlock)(POPAnimation *anim);
@property (assign, nonatomic) BOOL removedOnCompletion;
@property (assign, nonatomic, getter = isPaused) BOOL paused;
@property (assign, nonatomic) BOOL autoreverses;
@property (assign, nonatomic) NSInteger repeatCount;
@property (assign, nonatomic) BOOL repeatForever;
@end
@protocol POPAnimationDelegate <NSObject>
@optional
- (void)pop_animationDidStart:(POPAnimation *)anim;
- (void)pop_animationDidReachToValue:(POPAnimation *)anim;
- (void)pop_animationDidStop:(POPAnimation *)anim finished:(BOOL)finished;
- (void)pop_animationDidApply:(POPAnimation *)anim;
@end
@interface NSObject (POP)
- (void)pop_addAnimation:(POPAnimation *)anim forKey:(NSString *)key;
- (void)pop_removeAllAnimations;
- (void)pop_removeAnimationForKey:(NSString *)key;
- (NSArray *)pop_animationKeys;
- (id)pop_animationForKey:(NSString *)key;
@end
@interface POPAnimation (NSCopying) <NSCopying>
@end