#import <Foundation/Foundation.h>
#import "AppMonitorTable.h"
#import "AppMonitorAlarm.h"
#import "AppMonitorCounter.h"
#import "AppMonitorStat.h"
@interface AppMonitor : NSObject
+ (BOOL)isInit;
+ (BOOL) isUTInit;
+ (void) setUTInit;
+ (instancetype)sharedInstance;
+ (void)setSamplingConfigWithJson:(NSString *)jsonStr;
+ (void)disableSample;
+ (void)setSampling:(NSString *)sampling;
+ (BOOL)isTurnOnRealTimeDebug;
+ (NSString*)realTimeDebugUploadUrl;
+ (NSString*)realTimeDebugId;
+(void) turnOnAppMonitorRealtimeDebug:(NSDictionary *) pDict;
+(void) turnOffAppMonitorRealtimeDebug;
@end