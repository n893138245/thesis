#import <Foundation/Foundation.h>
#import "UTIRequestAuthentication.h"
@interface UTBaseRequestAuthentication : NSObject<UTIRequestAuthentication>
-(id) initWithAppKey:(NSString *) pAppKey appSecret:(NSString *) pSecret;
@end