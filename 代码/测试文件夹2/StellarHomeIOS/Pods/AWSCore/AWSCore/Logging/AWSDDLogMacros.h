#ifndef AWSDD_LEGACY_MACROS
    #define AWSDD_LEGACY_MACROS 0
#endif
#import "AWSDDLog.h"
#ifndef AWSDD_LOG_ASYNC_ENABLED
    #define AWSDD_LOG_ASYNC_ENABLED YES
#endif
#define AWSDD_LOG_MACRO(isAsynchronous, lvl, flg, ctx, atag, fnct, frmt, ...) \
        [AWSDDLog log : isAsynchronous                                     \
             level : lvl                                                \
              flag : flg                                                \
           context : ctx                                                \
              file : __FILE__                                           \
          function : fnct                                               \
              line : __LINE__                                           \
               tag : atag                                               \
            format : (frmt), ## __VA_ARGS__]
#define LOG_MACRO_TO_AWSDDLOG(ddlog, isAsynchronous, lvl, flg, ctx, atag, fnct, frmt, ...) \
        [ddlog log : isAsynchronous                                     \
             level : lvl                                                \
              flag : flg                                                \
           context : ctx                                                \
              file : __FILE__                                           \
          function : fnct                                               \
              line : __LINE__                                           \
               tag : atag                                               \
            format : (frmt), ## __VA_ARGS__]
#define AWSDD_LOG_MAYBE(async, lvl, flg, ctx, tag, fnct, frmt, ...) \
        do { AWSDD_LOG_MACRO(async, lvl, flg, ctx, tag, fnct, frmt, ##__VA_ARGS__); } while(0)
#define LOG_MAYBE_TO_AWSDDLOG(ddlog, async, lvl, flg, ctx, tag, fnct, frmt, ...) \
        do { LOG_MACRO_TO_AWSDDLOG(ddlog, async, lvl, flg, ctx, tag, fnct, frmt, ##__VA_ARGS__); } while(0)
#define AWSDDLogError(frmt, ...)   AWSDD_LOG_MAYBE(NO,                [AWSDDLog sharedInstance].logLevel, AWSDDLogFlagError,   0, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__)
#define AWSDDLogWarn(frmt, ...)    AWSDD_LOG_MAYBE(AWSDD_LOG_ASYNC_ENABLED, [AWSDDLog sharedInstance].logLevel, AWSDDLogFlagWarning, 0, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__)
#define AWSDDLogInfo(frmt, ...)    AWSDD_LOG_MAYBE(AWSDD_LOG_ASYNC_ENABLED, [AWSDDLog sharedInstance].logLevel, AWSDDLogFlagInfo,    0, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__)
#define AWSDDLogDebug(frmt, ...)   AWSDD_LOG_MAYBE(AWSDD_LOG_ASYNC_ENABLED, [AWSDDLog sharedInstance].logLevel, AWSDDLogFlagDebug,   0, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__)
#define AWSDDLogVerbose(frmt, ...) AWSDD_LOG_MAYBE(AWSDD_LOG_ASYNC_ENABLED, [AWSDDLog sharedInstance].logLevel, AWSDDLogFlagVerbose, 0, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__)
#define AWSDDLogErrorToAWSDDLog(ddlog, frmt, ...)   LOG_MAYBE_TO_AWSDDLOG(ddlog, NO,                [AWSDDLog sharedInstance].logLevel, AWSDDLogFlagError,   0, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__)
#define AWSDDLogWarnToAWSDDLog(ddlog, frmt, ...)    LOG_MAYBE_TO_AWSDDLOG(ddlog, AWSDD_LOG_ASYNC_ENABLED, [AWSDDLog sharedInstance].logLevel, AWSDDLogFlagWarning, 0, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__)
#define AWSDDLogInfoToAWSDDLog(ddlog, frmt, ...)    LOG_MAYBE_TO_AWSDDLOG(ddlog, AWSDD_LOG_ASYNC_ENABLED, [AWSDDLog sharedInstance].logLevel, AWSDDLogFlagInfo,    0, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__)
#define AWSDDLogDebugToAWSDDLog(ddlog, frmt, ...)   LOG_MAYBE_TO_AWSDDLOG(ddlog, AWSDD_LOG_ASYNC_ENABLED, [AWSDDLog sharedInstance].logLevel, AWSDDLogFlagDebug,   0, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__)
#define AWSDDLogVerboseToAWSDDLog(ddlog, frmt, ...) LOG_MAYBE_TO_AWSDDLOG(ddlog, AWSDD_LOG_ASYNC_ENABLED, [AWSDDLog sharedInstance].logLevel, AWSDDLogFlagVerbose, 0, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__)