#import <Foundation/Foundation.h>
#import "PLCrashReportApplicationInfo.h"
#import "PLCrashReportBinaryImageInfo.h"
#import "PLCrashReportExceptionInfo.h"
#import "PLCrashReportMachineInfo.h"
#import "PLCrashReportMachExceptionInfo.h"
#import "PLCrashReportProcessInfo.h"
#import "PLCrashReportProcessorInfo.h"
#import "PLCrashReportRegisterInfo.h"
#import "PLCrashReportSignalInfo.h"
#import "PLCrashReportStackFrameInfo.h"
#import "PLCrashReportSymbolInfo.h"
#import "PLCrashReportSystemInfo.h"
#import "PLCrashReportThreadInfo.h"
#define PLCRASH_REPORT_FILE_MAGIC "plcrash"
#define PLCRASH_REPORT_FILE_VERSION 1
struct PLCrashReportFileHeader {
    const char magic[7];
    const uint8_t version;
    const uint8_t data[];
} __attribute__((packed));
typedef struct _PLCrashReportDecoder _PLCrashReportDecoder;
@interface PLCrashReport : NSObject {
@private
    _PLCrashReportDecoder *_decoder;
    PLCrashReportSystemInfo *_systemInfo;
    PLCrashReportMachineInfo *_machineInfo;
    PLCrashReportApplicationInfo *_applicationInfo;
    PLCrashReportProcessInfo *_processInfo;
    PLCrashReportSignalInfo *_signalInfo;
    PLCrashReportMachExceptionInfo *_machExceptionInfo;
    NSArray *_threads;
    NSArray *_images;
    PLCrashReportExceptionInfo *_exceptionInfo;
    CFUUIDRef _uuid;
}
- (id) initWithError :(NSError **) outError;
- (id) initWithData: (NSData *) encodedData error: (NSError **) outError;
- (PLCrashReportBinaryImageInfo *) imageForAddress: (uint64_t) address;
@property(nonatomic, strong) PLCrashReportSystemInfo *systemInfo;
@property(nonatomic, readonly) BOOL hasMachineInfo;
@property(nonatomic, strong) PLCrashReportMachineInfo *machineInfo;
@property(nonatomic, strong) PLCrashReportApplicationInfo *applicationInfo;
@property(nonatomic, readonly) BOOL hasProcessInfo;
@property(nonatomic, strong) PLCrashReportProcessInfo *processInfo;
@property(nonatomic, strong) PLCrashReportSignalInfo *signalInfo;
@property(nonatomic, strong) PLCrashReportMachExceptionInfo *machExceptionInfo;
@property(nonatomic, strong) NSArray *threads;
@property(nonatomic, strong) NSArray *images;
@property(nonatomic, readonly) BOOL hasExceptionInfo;
@property(nonatomic, strong) PLCrashReportExceptionInfo *exceptionInfo;
@property(nonatomic) CFUUIDRef uuidRef;
@end