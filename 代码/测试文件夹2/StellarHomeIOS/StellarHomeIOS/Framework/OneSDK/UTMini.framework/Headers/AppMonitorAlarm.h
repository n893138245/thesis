#import <Foundation/Foundation.h>
#import "AppMonitorBase.h"
@interface AppMonitorAlarm : AppMonitorBase
+ (void)commitSuccessWithPage:(NSString *)page monitorPoint:(NSString *)monitorPoint;
+ (void)commitFailWithPage:(NSString *)page monitorPoint:(NSString *)monitorPoint errorCode:(NSString *)errorCode errorMsg:(NSString *)errorMsg;
+ (void)commitSuccessWithPage:(NSString *)page monitorPoint:(NSString *)monitorPoint arg:(NSString *)arg;
+ (void)commitFailWithPage:(NSString *)page monitorPoint:(NSString *)monitorPoint errorCode:(NSString *)errorCode errorMsg:(NSString *)errorMsg arg:(NSString *)arg;
@end