#import <Foundation/Foundation.h>
#import <pop/POPAnimationTracer.h>
@interface POPAnimationTracer (Internal)
- (instancetype)initWithAnimation:(POPAnimation *)anAnim;
- (void)readPropertyValue:(id)aValue;
- (void)writePropertyValue:(id)aValue;
- (void)updateToValue:(id)aValue;
- (void)updateFromValue:(id)aValue;
- (void)updateVelocity:(id)aValue;
- (void)updateBounciness:(float)aFloat;
- (void)updateSpeed:(float)aFloat;
- (void)updateFriction:(float)aFloat;
- (void)updateMass:(float)aFloat;
- (void)updateTension:(float)aFloat;
- (void)didAdd;
- (void)didStart;
- (void)didStop:(BOOL)finished;
- (void)didReachToValue:(id)aValue;
- (void)autoreversed;
@end