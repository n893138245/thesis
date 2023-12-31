#import "AWSDDASLLogCapture.h"
#ifndef AWSDD_LEGACY_MACROS
    #define AWSDD_LEGACY_MACROS 0
#endif
#import "AWSDDLog.h"
#include <asl.h>
#include <notify.h>
#include <notify_keys.h>
#include <sys/time.h>
static BOOL _cancel = YES;
static AWSDDLogLevel _captureLevel = AWSDDLogLevelVerbose;
#ifdef __IPHONE_8_0
    #define AWSDDASL_IOS_PIVOT_VERSION __IPHONE_8_0
#endif
#ifdef __MAC_10_10
    #define AWSDDASL_OSX_PIVOT_VERSION __MAC_10_10
#endif
@implementation AWSDDASLLogCapture
static aslmsg (*dd_asl_next)(aslresponse obj);
static void (*dd_asl_release)(aslresponse obj);
+ (void)initialize
{
    #if (defined(AWSDDASL_IOS_PIVOT_VERSION) && __IPHONE_OS_VERSION_MAX_ALLOWED >= AWSDDASL_IOS_PIVOT_VERSION) || (defined(AWSDDASL_OSX_PIVOT_VERSION) && __MAC_OS_X_VERSION_MAX_ALLOWED >= AWSDDASL_OSX_PIVOT_VERSION)
        #if __IPHONE_OS_VERSION_MIN_REQUIRED < AWSDDASL_IOS_PIVOT_VERSION || __MAC_OS_X_VERSION_MIN_REQUIRED < AWSDDASL_OSX_PIVOT_VERSION
            #pragma GCC diagnostic push
            #pragma GCC diagnostic ignored "-Wdeprecated-declarations"
                dd_asl_next    = &aslresponse_next;
                dd_asl_release = &aslresponse_free;
            #pragma GCC diagnostic pop
        #else
            dd_asl_next    = &asl_next;
            dd_asl_release = &asl_release;
        #endif
    #else
        dd_asl_next    = &aslresponse_next;
        dd_asl_release = &aslresponse_free;
    #endif
}
+ (void)start {
    if (!_cancel) {
        return;
    }
    _cancel = NO;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        [self captureAslLogs];
    });
}
+ (void)stop {
    _cancel = YES;
}
+ (AWSDDLogLevel)captureLevel {
    return _captureLevel;
}
+ (void)setCaptureLevel:(AWSDDLogLevel)level {
    _captureLevel = level;
}
#pragma mark - Private methods
+ (void)configureAslQuery:(aslmsg)query {
    const char param[] = "7";  
    asl_set_query(query, ASL_KEY_LEVEL, param, ASL_QUERY_OP_LESS_EQUAL | ASL_QUERY_OP_NUMERIC);
    asl_set_query(query, kAWSDDASLKeyAWSDDLog, kAWSDDASLAWSDDLogValue, ASL_QUERY_OP_NOT_EQUAL);
#if !TARGET_OS_IPHONE || TARGET_SIMULATOR
    int processId = [[NSProcessInfo processInfo] processIdentifier];
    char pid[16];
    sprintf(pid, "%d", processId);
    asl_set_query(query, ASL_KEY_PID, pid, ASL_QUERY_OP_EQUAL | ASL_QUERY_OP_NUMERIC);
#endif
}
+ (void)aslMessageReceived:(aslmsg)msg {
    const char* messageCString = asl_get( msg, ASL_KEY_MSG );
    if (messageCString == NULL)
        return;
    int flag;
    BOOL async;
    const char* levelCString = asl_get(msg, ASL_KEY_LEVEL);
    switch (levelCString? atoi(levelCString) : 0) {
        case ASL_LEVEL_EMERG    :
        case ASL_LEVEL_ALERT    :
        case ASL_LEVEL_CRIT     : flag = AWSDDLogFlagError;    async = NO;  break;
        case ASL_LEVEL_ERR      : flag = AWSDDLogFlagWarning;  async = YES; break;
        case ASL_LEVEL_WARNING  : flag = AWSDDLogFlagInfo;     async = YES; break;
        case ASL_LEVEL_NOTICE   : flag = AWSDDLogFlagDebug;    async = YES; break;
        case ASL_LEVEL_INFO     :
        case ASL_LEVEL_DEBUG    :
        default                 : flag = AWSDDLogFlagVerbose;  async = YES;  break;
    }
    if (!(_captureLevel & flag)) {
        return;
    }
    NSString *message = @(messageCString);
    const char* secondsCString = asl_get( msg, ASL_KEY_TIME );
    const char* nanoCString = asl_get( msg, ASL_KEY_TIME_NSEC );
    NSTimeInterval seconds = secondsCString ? strtod(secondsCString, NULL) : [NSDate timeIntervalSinceReferenceDate] - NSTimeIntervalSince1970;
    double nanoSeconds = nanoCString? strtod(nanoCString, NULL) : 0;
    NSTimeInterval totalSeconds = seconds + (nanoSeconds / 1e9);
    NSDate *timeStamp = [NSDate dateWithTimeIntervalSince1970:totalSeconds];
    AWSDDLogMessage *logMessage = [[AWSDDLogMessage alloc]initWithMessage:message
                                                              level:_captureLevel
                                                               flag:flag
                                                            context:0
                                                             file:@"AWSDDASLLogCapture"
                                                           function:0
                                                               line:0
                                                                tag:nil
                                                            options:0
                                                          timestamp:timeStamp];
    [AWSDDLog log:async message:logMessage];
}
+ (void)captureAslLogs {
    @autoreleasepool
    {
        struct timeval timeval = {
            .tv_sec = 0
        };
        gettimeofday(&timeval, NULL);
        unsigned long long startTime = timeval.tv_sec;
        __block unsigned long long lastSeenID = 0;
        int notifyToken = 0;  
        notify_register_dispatch(kNotifyASLDBUpdate, &notifyToken, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^(int token)
        {
            @autoreleasepool
            {
                aslmsg query = asl_new(ASL_TYPE_QUERY);
                char stringValue[64];
                if (lastSeenID > 0) {
                    snprintf(stringValue, sizeof stringValue, "%llu", lastSeenID);
                    asl_set_query(query, ASL_KEY_MSG_ID, stringValue, ASL_QUERY_OP_GREATER | ASL_QUERY_OP_NUMERIC);
                } else {
                    snprintf(stringValue, sizeof stringValue, "%llu", startTime);
                    asl_set_query(query, ASL_KEY_TIME, stringValue, ASL_QUERY_OP_GREATER_EQUAL | ASL_QUERY_OP_NUMERIC);
                }
                [self configureAslQuery:query];
                aslmsg msg;
                aslresponse response = asl_search(NULL, query);
                while ((msg = dd_asl_next(response)))
                {
                    [self aslMessageReceived:msg];
                    lastSeenID = atoll(asl_get(msg, ASL_KEY_MSG_ID));
                }
                dd_asl_release(response);
                asl_free(query);
                if (_cancel) {
                    notify_cancel(token);
                    return;
                }
            }
        });
    }
}
@end