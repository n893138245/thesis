#import <CocoaLumberjack/DDContextFilterLogFormatter+Deprecated.h>
@implementation DDContextAllowlistFilterLogFormatter (Deprecated)
- (void)addToWhitelist:(NSInteger)loggingContext {
    [self addToAllowlist:loggingContext];
}
- (void)removeFromWhitelist:(NSInteger)loggingContext {
    [self removeFromAllowlist:loggingContext];
}
- (NSArray *)whitelist {
    return [self allowlist];
}
- (BOOL)isOnWhitelist:(NSInteger)loggingContext {
    return [self isOnAllowlist:loggingContext];
}
@end
@implementation DDContextDenylistFilterLogFormatter (Deprecated)
- (void)addToBlacklist:(NSInteger)loggingContext {
    [self addToDenylist:loggingContext];
}
- (void)removeFromBlacklist:(NSInteger)loggingContext {
    [self removeFromDenylist:loggingContext];
}
- (NSArray *)blacklist {
    return [self denylist];
}
- (BOOL)isOnBlacklist:(NSInteger)loggingContext {
    return [self isOnDenylist:loggingContext];
}
@end