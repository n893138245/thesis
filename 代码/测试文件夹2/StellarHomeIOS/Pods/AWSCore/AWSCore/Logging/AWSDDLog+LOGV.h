#ifndef AWSDD_LEGACY_MACROS
    #define AWSDD_LEGACY_MACROS 0
#endif
#import "AWSDDLog.h"
#ifndef LOG_ASYNC_ENABLED
    #define LOG_ASYNC_ENABLED YES
#endif
#define LOGV_MACRO(isAsynchronous, lvl, flg, ctx, atag, fnct, frmt, avalist) \
        [AWSDDLog log : isAsynchronous                                     \
             level : lvl                                                \
              flag : flg                                                \
           context : ctx                                                \
              file : __FILE__                                           \
          function : fnct                                               \
              line : __LINE__                                           \
               tag : atag                                               \
            format : frmt                                               \
              args : avalist]
#define LOGV_MAYBE(async, lvl, flg, ctx, tag, fnct, frmt, avalist) \
        do { if(lvl & flg) LOGV_MACRO(async, lvl, flg, ctx, tag, fnct, frmt, avalist); } while(0)
#define AWSDDLogVError(frmt, avalist)   LOGV_MAYBE(NO,                LOG_LEVEL_DEF, AWSDDLogFlagError,   0, nil, __PRETTY_FUNCTION__, frmt, avalist)
#define AWSDDLogVWarn(frmt, avalist)    LOGV_MAYBE(LOG_ASYNC_ENABLED, LOG_LEVEL_DEF, AWSDDLogFlagWarning, 0, nil, __PRETTY_FUNCTION__, frmt, avalist)
#define AWSDDLogVInfo(frmt, avalist)    LOGV_MAYBE(LOG_ASYNC_ENABLED, LOG_LEVEL_DEF, AWSDDLogFlagInfo,    0, nil, __PRETTY_FUNCTION__, frmt, avalist)
#define AWSDDLogVDebug(frmt, avalist)   LOGV_MAYBE(LOG_ASYNC_ENABLED, LOG_LEVEL_DEF, AWSDDLogFlagDebug,   0, nil, __PRETTY_FUNCTION__, frmt, avalist)
#define AWSDDLogVVerbose(frmt, avalist) LOGV_MAYBE(LOG_ASYNC_ENABLED, LOG_LEVEL_DEF, AWSDDLogFlagVerbose, 0, nil, __PRETTY_FUNCTION__, frmt, avalist)