#import <Foundation/Foundation.h>
#import <mach/mach.h>
#import "PLCrashReporterConfig.h"
#import "PLCrashMacros.h"
@class PLCrashMachExceptionServer;
@class PLCrashMachExceptionPortSet;
typedef void (*PLCrashReporterPostCrashSignalCallback)(siginfo_t *info, ucontext_t *uap, void *context);
typedef struct PLCrashReporterCallbacks {
    uint16_t version;
    void *context;
    PLCrashReporterPostCrashSignalCallback handleSignal;
    BOOL (*prehandleMachException)(task_t task, thread_t thread, exception_type_t exception_type, mach_exception_data_t code, mach_msg_type_number_t code_count, kern_return_t* result);
} PLCrashReporterCallbacks;
@interface PLCrashReporter : NSObject {
@private
    PLCrashReporterConfig *_config;
    BOOL _enabled;
#if PLCRASH_FEATURE_MACH_EXCEPTIONS
    PLCrashMachExceptionServer *_machServer;
    PLCrashMachExceptionPortSet *_previousMachPorts;
#endif 
    NSString *_applicationIdentifier;
    NSString *_applicationVersion;
    NSString *_applicationMarketingVersion;
    NSString *_crashReportDirectory;
}
+ (PLCrashReporter *) sharedReporter PLCR_DEPRECATED;
- (instancetype) initWithConfiguration: (PLCrashReporterConfig *) config;
- (BOOL) hasPendingCrashReport;
- (NSData *) loadPendingCrashReportData;
- (NSData *) loadPendingCrashReportDataAndReturnError: (NSError **) outError;
- (NSData *) generateLiveReportWithThread: (thread_t) thread;
- (NSData *) generateLiveReportWithThread: (thread_t) thread error: (NSError **) outError;
- (NSData *) generateLiveReport;
- (NSData *) generateLiveReportAndReturnError: (NSError **) outError;
- (NSString*) generateLiveReportAndReturnErrorByFengchao: (thread_t) thread error:(NSError **) outError;
- (BOOL) purgePendingCrashReport;
- (BOOL) purgePendingCrashReportAndReturnError: (NSError **) outError;
- (BOOL) enableCrashReporter;
- (BOOL) enableCrashReporterAndReturnError: (NSError **) outError;
- (void) setCrashCallbacks: (PLCrashReporterCallbacks *) callbacks;
@end