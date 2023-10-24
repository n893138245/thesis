#import <Foundation/Foundation.h>
#import "PLCrashReportSymbolInfo.h"
@interface PLCrashReportStackFrameInfo : NSObject {
@private
    uint64_t _instructionPointer;
    PLCrashReportSymbolInfo *_symbolInfo;
}
- (id) initWithInstructionPointer: (uint64_t) instructionPointer symbolInfo: (PLCrashReportSymbolInfo *) symbolInfo;
@property(nonatomic, readonly) uint64_t instructionPointer;
@property(nonatomic, readonly) PLCrashReportSymbolInfo *symbolInfo;
@end