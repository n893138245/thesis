#import <Foundation/Foundation.h>
@interface PLCrashReportMachExceptionInfo : NSObject {
@private
    uint64_t _type;
    NSArray *_codes;
}
- (id) initWithType: (uint64_t) type codes: (NSArray *) codes;
@property(nonatomic, readonly) uint64_t type;
@property(nonatomic, readonly) NSArray *codes;
@end