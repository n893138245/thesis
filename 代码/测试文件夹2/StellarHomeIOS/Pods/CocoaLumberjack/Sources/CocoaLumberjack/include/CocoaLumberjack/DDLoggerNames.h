#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN
typedef NSString *DDLoggerName NS_EXTENSIBLE_STRING_ENUM;
FOUNDATION_EXPORT DDLoggerName const DDLoggerNameOS NS_SWIFT_NAME(DDLoggerName.os);     
FOUNDATION_EXPORT DDLoggerName const DDLoggerNameFile NS_SWIFT_NAME(DDLoggerName.file); 
FOUNDATION_EXPORT DDLoggerName const DDLoggerNameTTY NS_SWIFT_NAME(DDLoggerName.tty);   
API_DEPRECATED("Use DDOSLogger instead", macosx(10.4, 10.12), ios(2.0, 10.0), watchos(2.0, 3.0), tvos(9.0, 10.0))
FOUNDATION_EXPORT DDLoggerName const DDLoggerNameASL NS_SWIFT_NAME(DDLoggerName.asl);   
NS_ASSUME_NONNULL_END