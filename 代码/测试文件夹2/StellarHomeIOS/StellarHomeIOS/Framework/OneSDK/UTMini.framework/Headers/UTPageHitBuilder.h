#import "UTHitBuilder.h"
@interface UTPageHitBuilder : UTHitBuilder
-(void) setPageName:(NSString *) pPageName;
-(void) setReferPage:(NSString *) pReferPageName;
-(void) setDurationOnPage:(long long ) durationTimeOnPage;
@end