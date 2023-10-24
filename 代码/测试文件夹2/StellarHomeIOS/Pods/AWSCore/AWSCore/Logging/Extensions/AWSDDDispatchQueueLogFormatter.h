#import <Foundation/Foundation.h>
#import <libkern/OSAtomic.h>
#ifndef AWSDD_LEGACY_MACROS
    #define AWSDD_LEGACY_MACROS 0
#endif
#import "AWSDDLog.h"
typedef NS_ENUM(NSUInteger, AWSDDDispatchQueueLogFormatterMode){
    AWSDDDispatchQueueLogFormatterModeShareble = 0,
    AWSDDDispatchQueueLogFormatterModeNonShareble,
};
@interface AWSDDDispatchQueueLogFormatter : NSObject <AWSDDLogFormatter>
- (instancetype)init NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithMode:(AWSDDDispatchQueueLogFormatterMode)mode;
@property (assign, atomic) NSUInteger minQueueLength;
@property (assign, atomic) NSUInteger maxQueueLength;
- (NSString *)replacementStringForQueueLabel:(NSString *)longLabel;
- (void)setReplacementString:(NSString *)shortLabel forQueueLabel:(NSString *)longLabel;
@end
@interface AWSDDDispatchQueueLogFormatter (OverridableMethods)
- (void)configureDateFormatter:(NSDateFormatter *)dateFormatter;
- (NSString *)stringFromDate:(NSDate *)date;
- (NSString *)queueThreadLabelForLogMessage:(AWSDDLogMessage *)logMessage;
- (NSString *)formatLogMessage:(AWSDDLogMessage *)logMessage;
@end