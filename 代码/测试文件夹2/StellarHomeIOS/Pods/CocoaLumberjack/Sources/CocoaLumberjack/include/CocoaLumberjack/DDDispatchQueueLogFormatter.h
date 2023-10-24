#import <Foundation/Foundation.h>
#ifndef DD_LEGACY_MACROS
    #define DD_LEGACY_MACROS 0
#endif
#import <CocoaLumberjack/DDLog.h>
NS_ASSUME_NONNULL_BEGIN
__attribute__((deprecated("DDDispatchQueueLogFormatter is always shareable")))
typedef NS_ENUM(NSUInteger, DDDispatchQueueLogFormatterMode){
    DDDispatchQueueLogFormatterModeShareble = 0,
    DDDispatchQueueLogFormatterModeNonShareble,
};
typedef NSString * DDQualityOfServiceName NS_STRING_ENUM;
FOUNDATION_EXPORT DDQualityOfServiceName const DDQualityOfServiceUserInteractive NS_SWIFT_NAME(DDQualityOfServiceName.userInteractive) API_AVAILABLE(macos(10.10), ios(8.0));
FOUNDATION_EXPORT DDQualityOfServiceName const DDQualityOfServiceUserInitiated NS_SWIFT_NAME(DDQualityOfServiceName.userInitiated) API_AVAILABLE(macos(10.10), ios(8.0));
FOUNDATION_EXPORT DDQualityOfServiceName const DDQualityOfServiceDefault NS_SWIFT_NAME(DDQualityOfServiceName.default) API_AVAILABLE(macos(10.10), ios(8.0));
FOUNDATION_EXPORT DDQualityOfServiceName const DDQualityOfServiceUtility NS_SWIFT_NAME(DDQualityOfServiceName.utility) API_AVAILABLE(macos(10.10), ios(8.0));
FOUNDATION_EXPORT DDQualityOfServiceName const DDQualityOfServiceBackground NS_SWIFT_NAME(DDQualityOfServiceName.background) API_AVAILABLE(macos(10.10), ios(8.0));
FOUNDATION_EXPORT DDQualityOfServiceName const DDQualityOfServiceUnspecified NS_SWIFT_NAME(DDQualityOfServiceName.unspecified) API_AVAILABLE(macos(10.10), ios(8.0));
@interface DDDispatchQueueLogFormatter : NSObject <DDLogFormatter>
- (instancetype)init NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithMode:(DDDispatchQueueLogFormatterMode)mode __attribute__((deprecated("DDDispatchQueueLogFormatter is always shareable")));
@property (assign, atomic) NSUInteger minQueueLength;
@property (assign, atomic) NSUInteger maxQueueLength;
- (nullable NSString *)replacementStringForQueueLabel:(NSString *)longLabel;
- (void)setReplacementString:(nullable NSString *)shortLabel forQueueLabel:(NSString *)longLabel;
@end
@interface DDDispatchQueueLogFormatter (OverridableMethods)
- (void)configureDateFormatter:(NSDateFormatter *)dateFormatter;
- (NSString *)stringFromDate:(NSDate *)date;
- (NSString *)queueThreadLabelForLogMessage:(DDLogMessage *)logMessage;
- (NSString *)formatLogMessage:(DDLogMessage *)logMessage;
@end
#pragma mark - DDAtomicCountable
__attribute__((deprecated("DDAtomicCountable is useless since DDDispatchQueueLogFormatter is always shareable now")))
@protocol DDAtomicCountable <NSObject>
- (instancetype)initWithDefaultValue:(int32_t)defaultValue;
- (int32_t)increment;
- (int32_t)decrement;
- (int32_t)value;
@end
__attribute__((deprecated("DDAtomicCountable is deprecated")))
@interface DDAtomicCounter: NSObject<DDAtomicCountable>
@end
NS_ASSUME_NONNULL_END