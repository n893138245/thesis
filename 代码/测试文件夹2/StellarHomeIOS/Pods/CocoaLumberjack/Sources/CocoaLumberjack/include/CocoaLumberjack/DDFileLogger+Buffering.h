#import <CocoaLumberjack/DDFileLogger.h>
NS_ASSUME_NONNULL_BEGIN
@interface DDFileLogger (Buffering)
- (instancetype)wrapWithBuffer;
- (instancetype)unwrapFromBuffer;
@end
NS_ASSUME_NONNULL_END