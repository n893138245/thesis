#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <mach/mach_types.h>
#import <JDYThreadTrace/JDYThreadScene.h>
typedef enum : NSUInteger {
    JDYThreadTraceReportDeviceInfo      = 1UL << 0,
    JDYThreadTraceReportCpuAndMem       = 1UL << 1,
    JDYThreadTraceReportMainThread      = 1UL << 2,
    JDYThreadTraceReportOtherThread     = 1UL << 3,
    JDYThreadTraceReportRegisters       = 1UL << 4, 
    JDYThreadTraceReportBinaryImages    = 1UL << 5,
    JDYThreadTraceReportMain            = 0x27U,    
    JDYThreadTraceReportAll             = 0xFFU
} JDYThreadTraceReportMask;
@interface JDYThreadTracer : NSObject
+ (NSString *)generateTraceReport:(JDYThreadTraceReportMask)reportMask;
+ (NSString *)generateTraceReportWithThread:(thread_t)thread;
+ (NSString *)generateMainThreadTraceReportWithTrace:(NSArray<NSNumber*>*)trace customReason:(NSString*)customReason customInfo:(NSString*)customInfo;
+ (NSString *)getThreadNameWithThread:(thread_t)thread;
+ (NSArray *)getThreadNameListForAllThreads;
+ (NSString *)generateTraceReportForCurrentThread;
+ (NSString *)generateTraceReportForCurrentThreadWithSkip:(NSUInteger)skipCout;
+ (NSString *)generateTraceReport:(JDYThreadTraceReportMask)reportMask needSymbolicated:(BOOL)needSymbolicated;
+ (NSString *)generateTraceReportWithAppVersion:(NSString*) appVersion ReportMask:(JDYThreadTraceReportMask)reportMask;
+ (NSString *)getMainStackTrace;
+ (NSString *)getCurrentMemoryInfo;
+ (NSString *)generateTraceReportForThreadScenes:(NSArray *)scenes needSymbolicated:(BOOL)sym reason:(NSString *)reason;
@end