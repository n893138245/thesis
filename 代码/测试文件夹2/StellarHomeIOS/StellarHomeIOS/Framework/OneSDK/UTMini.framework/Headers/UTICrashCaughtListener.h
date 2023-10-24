#import <Foundation/Foundation.h>
@protocol UTICrashCaughtListener <NSObject>
-(NSDictionary *) onCrashCaught:(NSString *) pCrashReason CallStack:(NSString *)callStack;
@end