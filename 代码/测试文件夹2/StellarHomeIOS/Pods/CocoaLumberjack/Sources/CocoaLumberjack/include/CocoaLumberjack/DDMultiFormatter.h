#import <Foundation/Foundation.h>
#ifndef DD_LEGACY_MACROS
    #define DD_LEGACY_MACROS 0
#endif
#import <CocoaLumberjack/DDLog.h>
NS_ASSUME_NONNULL_BEGIN
@interface DDMultiFormatter : NSObject <DDLogFormatter>
@property (nonatomic, readonly) NSArray<id<DDLogFormatter>> *formatters;
- (void)addFormatter:(id<DDLogFormatter>)formatter NS_SWIFT_NAME(add(_:));
- (void)removeFormatter:(id<DDLogFormatter>)formatter NS_SWIFT_NAME(remove(_:));
- (void)removeAllFormatters NS_SWIFT_NAME(removeAll());
- (BOOL)isFormattingWithFormatter:(id<DDLogFormatter>)formatter;
@end
NS_ASSUME_NONNULL_END