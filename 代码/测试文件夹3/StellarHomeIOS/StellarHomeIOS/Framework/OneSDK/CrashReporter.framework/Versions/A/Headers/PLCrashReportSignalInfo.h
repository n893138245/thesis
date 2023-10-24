#import <Foundation/Foundation.h>
@interface PLCrashReportSignalInfo : NSObject {
@private
    NSString *_name;
    NSString *_code;
    uint64_t _address;
}
- (id) initWithSignalName: (NSString *) name code: (NSString *) code address: (uint64_t) address;
@property(nonatomic, readonly) NSString *name;
@property(nonatomic, readonly) NSString *code;
@property(nonatomic, readonly) uint64_t address;
@end