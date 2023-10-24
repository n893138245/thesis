#import <Foundation/Foundation.h>
#import "UTIRequestAuthentication.h"
@interface UTSecuritySDKRequestAuthentication : NSObject<UTIRequestAuthentication>
-(id) initWithAppKey:(NSString *) pAppKey;
@end