#import <Foundation/Foundation.h>
#import <AliHAProtocol/AliHAProtocol.h>
#ifndef kAliHAStartupEndNotification
#define kAliHAStartupEndNotification        @"AliHAStartupEnd"
#endif
typedef void(^PerformanceDataOutputBlock)(NSString*pageName, NSInteger interval, NSDictionary *extraInfos);
@interface AliHAPerformanceMonitor : NSObject <AliHAPluginProtocol>
+ (void)setPerfomanceDataHandler:(PerformanceDataOutputBlock)performanceDataHandler;
@end