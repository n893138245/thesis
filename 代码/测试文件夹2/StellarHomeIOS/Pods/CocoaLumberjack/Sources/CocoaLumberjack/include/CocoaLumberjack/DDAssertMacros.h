#define DDAssert(condition, frmt, ...)                                                \
        if (!(condition)) {                                                           \
            NSString *description = [NSString stringWithFormat:frmt, ## __VA_ARGS__]; \
            DDLogError(@"%@", description);                                           \
            NSAssert(NO, @"%@", description);                                         \
        }
#define DDAssertCondition(condition) DDAssert(condition, @"Condition not satisfied: %s", #condition)
#define DDAssertionFailure(frmt, ...) DDAssert(NO, frmt, ##__VA_ARGS__)