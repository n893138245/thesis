#import <Foundation/Foundation.h>
#import "PLCrashReportProcessorInfo.h"
@interface PLCrashReportMachineInfo : NSObject {
@private
    NSString *_modelName;
    PLCrashReportProcessorInfo *_processorInfo;
    NSUInteger _processorCount;
    NSUInteger _logicalProcessorCount;
}
- (id) initWithModelName: (NSString *) modelName
           processorInfo: (PLCrashReportProcessorInfo *) processorInfo
          processorCount: (NSUInteger) processorCount
   logicalProcessorCount: (NSUInteger) logicalProcessorCount;
@property(nonatomic, readonly) NSString *modelName;
@property(nonatomic, readonly) PLCrashReportProcessorInfo *processorInfo;
@property(nonatomic, readonly) NSUInteger processorCount;
@property(nonatomic, readonly) NSUInteger logicalProcessorCount;
@end