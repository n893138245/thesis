#import <Foundation/Foundation.h>
typedef NS_ENUM(NSUInteger, POPAnimationEventType) {
  kPOPAnimationEventPropertyRead = 0,
  kPOPAnimationEventPropertyWrite,
  kPOPAnimationEventToValueUpdate,
  kPOPAnimationEventFromValueUpdate,
  kPOPAnimationEventVelocityUpdate,
  kPOPAnimationEventBouncinessUpdate,
  kPOPAnimationEventSpeedUpdate,
  kPOPAnimationEventFrictionUpdate,
  kPOPAnimationEventMassUpdate,
  kPOPAnimationEventTensionUpdate,
  kPOPAnimationEventDidStart,
  kPOPAnimationEventDidStop,
  kPOPAnimationEventDidReachToValue,
  kPOPAnimationEventAutoreversed
};
@interface POPAnimationEvent : NSObject
@property (readonly, nonatomic, assign) POPAnimationEventType type;
@property (readonly, nonatomic, assign) CFTimeInterval time;
@property (readonly, nonatomic, copy) NSString *animationDescription;
@end
@interface POPAnimationValueEvent : POPAnimationEvent
@property (readonly, nonatomic, strong) id value;
@property (readonly, nonatomic, strong) id velocity;
@end