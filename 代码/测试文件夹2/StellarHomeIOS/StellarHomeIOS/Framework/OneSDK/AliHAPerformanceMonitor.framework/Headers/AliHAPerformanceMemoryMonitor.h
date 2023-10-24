#import <AliHAProtocol/AliHAProtocol.h>
#import <Foundation/Foundation.h>
@interface AliHAPerformanceMemoryMonitor : NSObject
+ (instancetype)sharedInstance;
- (void)startMonitor:(NSTimeInterval)interval withContext:(id<AliHAContextProtocol>)context;
- (void)stopMonitor;
- (void)latestMemoryStatus:(float*)footPrint freeSize:(float *)freeSize residentSize:(float *)residentSize virtualSize:(float *)virtualSize;
@end