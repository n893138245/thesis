#import <CocoaLumberjack/DDContextFilterLogFormatter.h>
NS_ASSUME_NONNULL_BEGIN
__attribute__((deprecated("Use DDContextAllowlistFilterLogFormatter instead")))
typedef DDContextAllowlistFilterLogFormatter DDContextWhitelistFilterLogFormatter;
@interface DDContextAllowlistFilterLogFormatter (Deprecated)
- (void)addToWhitelist:(NSInteger)loggingContext __attribute__((deprecated("Use -addToAllowlist: instead")));
- (void)removeFromWhitelist:(NSInteger)loggingContext __attribute__((deprecated("Use -removeFromAllowlist: instead")));
@property (nonatomic, readonly, copy) NSArray<NSNumber *> *whitelist __attribute__((deprecated("Use allowlist instead")));
- (BOOL)isOnWhitelist:(NSInteger)loggingContext __attribute__((deprecated("Use -isOnAllowlist: instead")));
@end
__attribute__((deprecated("Use DDContextDenylistFilterLogFormatter instead")))
typedef DDContextDenylistFilterLogFormatter DDContextBlacklistFilterLogFormatter;
@interface DDContextDenylistFilterLogFormatter (Deprecated)
- (void)addToBlacklist:(NSInteger)loggingContext __attribute__((deprecated("Use -addToDenylist: instead")));
- (void)removeFromBlacklist:(NSInteger)loggingContext __attribute__((deprecated("Use -removeFromDenylist: instead")));
@property (readonly, copy) NSArray<NSNumber *> *blacklist __attribute__((deprecated("Use denylist instead")));
- (BOOL)isOnBlacklist:(NSInteger)loggingContext __attribute__((deprecated("Use -isOnDenylist: instead")));
@end
NS_ASSUME_NONNULL_END