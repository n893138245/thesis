#import <Foundation/Foundation.h>
@interface UTHitBuilder : NSObject
-(NSDictionary *) build;
-(void) setProperty:(NSString *) pKey value:(NSString *) pValue;
-(void) setProperties:(NSDictionary *) pPageProperties;
@end