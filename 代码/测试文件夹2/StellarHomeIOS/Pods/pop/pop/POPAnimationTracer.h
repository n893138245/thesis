#import <Foundation/Foundation.h>
#import <pop/POPAnimationEvent.h>
@class POPAnimation;
@interface POPAnimationTracer : NSObject
- (void)start;
- (void)stop;
- (void)reset;
@property (nonatomic, assign, readonly) NSArray *allEvents;
@property (nonatomic, assign, readonly) NSArray *writeEvents;
- (NSArray *)eventsWithType:(POPAnimationEventType)type;
@property (nonatomic, assign) BOOL shouldLogAndResetOnCompletion;
@end