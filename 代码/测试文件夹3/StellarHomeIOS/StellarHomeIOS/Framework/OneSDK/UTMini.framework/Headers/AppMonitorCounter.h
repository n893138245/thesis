#import <Foundation/Foundation.h>
#import "AppMonitorBase.h"
@interface AppMonitorCounter : AppMonitorBase
+ (void)commitWithPage:(NSString *)page monitorPoint:(NSString *)monitorPoint value:(double)value;
+ (void)commitWithPage:(NSString *)page monitorPoint:(NSString *)monitorPoint value:(double)value arg:(NSString *)arg;
@end