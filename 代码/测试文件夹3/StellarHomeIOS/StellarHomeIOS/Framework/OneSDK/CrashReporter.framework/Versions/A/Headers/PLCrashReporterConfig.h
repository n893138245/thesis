#import <Foundation/Foundation.h>
#import "PLCrashFeatureConfig.h"
typedef NS_ENUM(NSUInteger, PLCrashReporterSignalHandlerType) {
    PLCrashReporterSignalHandlerTypeBSD = 0,
#if PLCRASH_FEATURE_MACH_EXCEPTIONS
    PLCrashReporterSignalHandlerTypeMach = 1
#endif 
};
typedef NS_OPTIONS(NSUInteger, PLCrashReporterSymbolicationStrategy) {
    PLCrashReporterSymbolicationStrategyNone = 0,
    PLCrashReporterSymbolicationStrategySymbolTable = 1 << 0,
    PLCrashReporterSymbolicationStrategyObjC = 1 << 1,
    PLCrashReporterSymbolicationStrategyAll = (PLCrashReporterSymbolicationStrategySymbolTable|PLCrashReporterSymbolicationStrategyObjC)
};
@interface PLCrashReporterConfig : NSObject {
@private
    PLCrashReporterSignalHandlerType _signalHandlerType;
    PLCrashReporterSymbolicationStrategy _symbolicationStrategy;
}
+ (instancetype) defaultConfiguration;
- (instancetype) init;
- (instancetype) initWithSignalHandlerType: (PLCrashReporterSignalHandlerType) signalHandlerType
                     symbolicationStrategy: (PLCrashReporterSymbolicationStrategy) symbolicationStrategy;
@property(nonatomic, readonly) PLCrashReporterSignalHandlerType signalHandlerType;
@property(nonatomic, readonly) PLCrashReporterSymbolicationStrategy symbolicationStrategy;
@end