#import <Foundation/Foundation.h>
#ifndef AWSDD_LEGACY_MACROS
    #define AWSDD_LEGACY_MACROS 0
#endif
#import "AWSDDLog.h"
@interface AWSDDMultiFormatter : NSObject <AWSDDLogFormatter>
@property (readonly) NSArray<id<AWSDDLogFormatter>> *formatters;
- (void)addFormatter:(id<AWSDDLogFormatter>)formatter NS_SWIFT_NAME(add(_:));
- (void)removeFormatter:(id<AWSDDLogFormatter>)formatter NS_SWIFT_NAME(remove(_:));
- (void)removeAllFormatters NS_SWIFT_NAME(removeAll());
- (BOOL)isFormattingWithFormatter:(id<AWSDDLogFormatter>)formatter;
@end