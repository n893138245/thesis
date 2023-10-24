#import <Foundation/Foundation.h>
#import <mach/machine.h>
typedef enum {
    PLCrashReportProcessorTypeEncodingUnknown = 0,
    PLCrashReportProcessorTypeEncodingMach = 1
} PLCrashReportProcessorTypeEncoding;
@interface PLCrashReportProcessorInfo : NSObject {
@private
    PLCrashReportProcessorTypeEncoding _typeEncoding;
    uint64_t _type;
    uint64_t _subtype;
}
- (id) initWithTypeEncoding: (PLCrashReportProcessorTypeEncoding) typeEncoding
                       type: (uint64_t) type
                    subtype: (uint64_t) subtype;
@property(nonatomic, readonly) PLCrashReportProcessorTypeEncoding typeEncoding;
@property(nonatomic, readonly) uint64_t type;
@property(nonatomic, readonly) uint64_t subtype;
@end