#import <Foundation/Foundation.h>
#import <mach/mach_types.h>
@protocol CrashReporterMonitorDelegate <NSObject>
@optional
- (void)crashReporterLog:(id)loger;
- (NSDictionary *)crashReporterAdditionalInformation;
- (NSDictionary *)crashReporterAdditionalInformationWithUContext:(void *)ucontext;
- (NSDictionary *)crashReporterAdditionalInformationWithThread:(thread_t)thread ucontext:(void *)ucontext;
- (NSDictionary *)crashReporterAdditionalInformationWithThread:(thread_t)thread ucontext:(void *)ucontext errorPtr:(uintptr_t)errorPtr ;
@end
@interface TBCrashReporterMonitor : NSObject
+ (instancetype)sharedMonitor;
- (NSDictionary *)crashReportCallBackInfo:(NSString*)viewControllerInfo Count:(int)count UploadFlag:(int)flag ucontext:(void *)ucontext thread:(thread_t)thread errorPtr:(uintptr_t)errorPtr;
- (void)registerCrashLogMonitor:(id<CrashReporterMonitorDelegate>)monitor;
@end