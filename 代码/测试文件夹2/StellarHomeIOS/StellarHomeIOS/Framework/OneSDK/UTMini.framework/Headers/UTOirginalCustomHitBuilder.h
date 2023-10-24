#import <Foundation/Foundation.h>
#import "UTHitBuilder.h"
@interface UTOirginalCustomHitBuilder : UTHitBuilder
-(void) setPageName:(NSString *) pPage;
-(void) setEventId:(NSString *) pEventId;
-(void) setArg1:(NSString *) pArg1;
-(void) setArg2:(NSString *) pArg2;
-(void) setArg3:(NSString *) pArg3;
-(void) setArgs:(NSDictionary *) pArgs;
@end