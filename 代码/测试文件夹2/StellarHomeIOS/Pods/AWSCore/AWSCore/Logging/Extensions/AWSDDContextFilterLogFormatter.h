#import <Foundation/Foundation.h>
#ifndef AWSDD_LEGACY_MACROS
    #define AWSDD_LEGACY_MACROS 0
#endif
#import "AWSDDLog.h"
@interface AWSDDContextWhitelistFilterLogFormatter : NSObject <AWSDDLogFormatter>
- (instancetype)init NS_DESIGNATED_INITIALIZER;
- (void)addToWhitelist:(NSUInteger)loggingContext;
- (void)removeFromWhitelist:(NSUInteger)loggingContext;
@property (readonly, copy) NSArray<NSNumber *> *whitelist;
- (BOOL)isOnWhitelist:(NSUInteger)loggingContext;
@end
#pragma mark -
@interface AWSDDContextBlacklistFilterLogFormatter : NSObject <AWSDDLogFormatter>
- (instancetype)init NS_DESIGNATED_INITIALIZER;
- (void)addToBlacklist:(NSUInteger)loggingContext;
- (void)removeFromBlacklist:(NSUInteger)loggingContext;
@property (readonly, copy) NSArray<NSNumber *> *blacklist;
- (BOOL)isOnBlacklist:(NSUInteger)loggingContext;
@end