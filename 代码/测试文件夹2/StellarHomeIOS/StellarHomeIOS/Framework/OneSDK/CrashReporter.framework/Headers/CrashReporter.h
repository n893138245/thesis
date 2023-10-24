#import <Foundation/Foundation.h>
#ifdef __APPLE__
#import <AvailabilityMacros.h>
#endif
#import "PLCrashNamespace.h"
#import "PLCrashReporter.h"
#import "PLCrashReport.h"
#import "PLCrashReportTextFormatter.h"
extern NSString *PLCrashReporterException;
extern NSString *PLCrashReporterErrorDomain;
typedef enum {
    PLCrashReporterErrorUnknown = 0,
    PLCrashReporterErrorOperatingSystem = 1,
    PLCrashReporterErrorCrashReportInvalid = 2,
    PLCrashReporterErrorResourceBusy = 3,
    PLCRashReporterErrorNotFound = 4,
    PLCRashReporterErrorInsufficientMemory = 4
} PLCrashReporterError;
#import "PLCrashReporter.h"
#import "PLCrashReport.h"
#import "PLCrashReportTextFormatter.h"