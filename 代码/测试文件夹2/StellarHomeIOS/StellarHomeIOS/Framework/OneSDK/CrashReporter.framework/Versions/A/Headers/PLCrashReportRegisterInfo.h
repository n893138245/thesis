#import <Foundation/Foundation.h>
@interface PLCrashReportRegisterInfo : NSObject {
@private
    NSString *_registerName;
    uint64_t _registerValue;
}
- (id) initWithRegisterName: (NSString *) registerName registerValue: (uint64_t) registerValue;
@property(nonatomic, readonly) NSString *registerName;
@property(nonatomic, readonly) uint64_t registerValue;
@end