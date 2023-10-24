#import <Foundation/Foundation.h>
typedef void (^ABSUncaughtExceptionCallback)(NSException *exception);
@interface ABSUncaughtExceptionHandler : NSObject
+ (void)registerExceptionHandlerWithCallback:(ABSUncaughtExceptionCallback)callback;
@end