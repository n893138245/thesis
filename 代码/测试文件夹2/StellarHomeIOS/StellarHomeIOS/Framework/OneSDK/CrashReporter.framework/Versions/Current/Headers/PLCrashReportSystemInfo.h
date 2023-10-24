#import <Foundation/Foundation.h>
#include "PLCrashMacros.h"
@class PLCrashReportProcessorInfo;
typedef enum {
    PLCrashReportOperatingSystemMacOSX = 0,
    PLCrashReportOperatingSystemiPhoneOS = 1,
    PLCrashReportOperatingSystemiPhoneSimulator = 2,
    PLCrashReportOperatingSystemUnknown = 3,
} PLCrashReportOperatingSystem;
typedef enum {
    PLCrashReportArchitectureX86_32 = 0,
    PLCrashReportArchitectureX86_64 = 1,
    PLCrashReportArchitectureARMv6 = 2,
    PLCrashReportArchitectureARM PLCR_DEPRECATED = PLCrashReportArchitectureARMv6,
    PLCrashReportArchitecturePPC = 3,
    PLCrashReportArchitecturePPC64 = 4,
    PLCrashReportArchitectureARMv7 = 5,
    PLCrashReportArchitectureUnknown = 6
} PLCrashReportArchitecture;
extern PLCrashReportOperatingSystem PLCrashReportHostOperatingSystem;
PLCR_EXTERNAL_DEPRECATED_NOWARN_PUSH();
extern PLCrashReportArchitecture PLCrashReportHostArchitecture PLCR_EXTERNAL_DEPRECATED;
PLCR_EXTERNAL_DEPRECATED_NOWARN_PUSH();
@interface PLCrashReportSystemInfo : NSObject {
@private
    PLCrashReportOperatingSystem _operatingSystem;
    NSString *_osVersion;
    NSString *_osBuild;
    PLCrashReportArchitecture _architecture;
    NSDate *_timestamp;
    PLCrashReportProcessorInfo *_processorInfo;
}
- (id) initWithOperatingSystem: (PLCrashReportOperatingSystem) operatingSystem 
        operatingSystemVersion: (NSString *) operatingSystemVersion
                  architecture: (PLCrashReportArchitecture) architecture
                     timestamp: (NSDate *) timestamp PLCR_DEPRECATED;
- (id) initWithOperatingSystem: (PLCrashReportOperatingSystem) operatingSystem 
        operatingSystemVersion: (NSString *) operatingSystemVersion
          operatingSystemBuild: (NSString *) operatingSystemBuild
                  architecture: (PLCrashReportArchitecture) architecture
                     timestamp: (NSDate *) timestamp PLCR_DEPRECATED;
- (id) initWithOperatingSystem: (PLCrashReportOperatingSystem) operatingSystem
        operatingSystemVersion: (NSString *) operatingSystemVersion
          operatingSystemBuild: (NSString *) operatingSystemBuild
                  architecture: (PLCrashReportArchitecture) architecture
                 processorInfo: (PLCrashReportProcessorInfo *) processorInfo
                     timestamp: (NSDate *) timestamp;
@property(nonatomic, readonly) PLCrashReportOperatingSystem operatingSystem;
@property(nonatomic, readonly) NSString *operatingSystemVersion;
@property(nonatomic, readonly) NSString *operatingSystemBuild;
@property(nonatomic, readonly) PLCrashReportArchitecture architecture PLCR_DEPRECATED;
@property(nonatomic, readonly) NSDate *timestamp;
@property(nonatomic, readonly) PLCrashReportProcessorInfo *processorInfo;
@end