#import <Foundation/Foundation.h>
@interface PLCrashReportSymbolInfo : NSObject {
@private
    NSString *_symbolName;
    uint64_t _startAddress;
    uint64_t _endAddress;
}
- (id) initWithSymbolName: (NSString *) symbolName
             startAddress: (uint64_t) startAddress
               endAddress: (uint64_t) endAddress;
@property(nonatomic, readonly) NSString *symbolName;
@property(nonatomic, readonly) uint64_t startAddress;
@property(nonatomic, readonly) uint64_t endAddress;
@end