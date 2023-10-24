#import <Foundation/Foundation.h>
#import "POPAnimationEvent.h"
@interface POPAnimationEvent ()
- (instancetype)initWithType:(POPAnimationEventType)type time:(CFTimeInterval)time;
@property (readwrite, nonatomic, copy) NSString *animationDescription;
@end
@interface POPAnimationValueEvent ()
- (instancetype)initWithType:(POPAnimationEventType)type time:(CFTimeInterval)time value:(id)value;
@property (readwrite, nonatomic, strong) id velocity;
@end