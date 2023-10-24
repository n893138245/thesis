#import <Foundation/Foundation.h>
@protocol UTIRequestAuthentication <NSObject>
-(NSString *) getAppKey;
-(NSString *) getSign:(NSString*) pToBeSignStr;
@end