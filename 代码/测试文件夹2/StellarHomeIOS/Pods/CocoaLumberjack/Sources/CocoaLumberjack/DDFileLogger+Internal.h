#import <CocoaLumberjack/DDFileLogger.h>
NS_ASSUME_NONNULL_BEGIN
@interface DDFileLogger (Internal)
- (void)logData:(NSData *)data;
- (void)lt_logData:(NSData *)data;
- (nullable NSData *)lt_dataForMessage:(DDLogMessage *)message;
@end
NS_ASSUME_NONNULL_END