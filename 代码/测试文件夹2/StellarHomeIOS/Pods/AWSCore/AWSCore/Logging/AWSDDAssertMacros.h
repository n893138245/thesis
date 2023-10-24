#define AWSDDAssert(condition, frmt, ...)                                                \
        if (!(condition)) {                                                           \
            NSString *description = [NSString stringWithFormat:frmt, ## __VA_ARGS__]; \
            AWSDDLogError(@"%@", description);                                           \
            NSAssert(NO, description);                                                \
        }
#define AWSDDAssertCondition(condition) AWSDDAssert(condition, @"Condition not satisfied: %s", #condition)