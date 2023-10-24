#import <Foundation/Foundation.h>
#import "PLCrashReportStackFrameInfo.h"
#import "PLCrashReportRegisterInfo.h"
@interface PLCrashReportThreadInfo : NSObject {
@private
    NSInteger _threadNumber;
    NSArray *_stackFrames;
    BOOL _crashed;
    NSArray *_registers;
}
- (id) initWithThreadNumber: (NSInteger) threadNumber
                stackFrames: (NSArray *) stackFrames
                    crashed: (BOOL) crashed
                  registers: (NSArray *) registers;
@property(nonatomic, readonly) NSInteger threadNumber;
@property(nonatomic, readonly) NSArray *stackFrames;
@property(nonatomic, readonly) BOOL crashed;
@property(nonatomic, readonly) NSArray *registers;
@end