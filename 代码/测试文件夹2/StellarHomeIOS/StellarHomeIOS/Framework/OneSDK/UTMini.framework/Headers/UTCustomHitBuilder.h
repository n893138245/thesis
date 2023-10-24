#import "UTHitBuilder.h"
@interface UTCustomHitBuilder : UTHitBuilder
-(void) setEventLabel:(NSString *) pEventId;
-(void) setEventPage:(NSString *) pPageName;
-(void) setDurationOnEvent:(long long) durationOnEvent;
@end