#import <TargetConditionals.h>
#if !TARGET_OS_WATCH
#include <asl.h>
#include <notify.h>
#include <notify_keys.h>
#include <sys/time.h>
#import <CocoaLumberjack/DDASLLogCapture.h>
#ifndef DD_LEGACY_MACROS
    #define DD_LEGACY_MACROS 0
#endif
static BOOL _cancel = YES;
static DDLogLevel _captureLevel = DDLogLevelVerbose;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-implementations"
@implementation DDASLLogCapture
#pragma clang diagnostic pop
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
+ (DDLogLevel)captureLevel {
    return _captureLevel;
}
+ (void)setCaptureLevel:(DDLogLevel)level {
    _captureLevel = level;
}
#pragma mark - Private methods
+ (void)configureAslQuery:(aslmsg)query {
    const char param[] = "7";  
    asl_set_query(query, ASL_KEY_LEVEL, param, ASL_QUERY_OP_LESS_EQUAL | ASL_QUERY_OP_NUMERIC);
    asl_set_query(query, kDDASLKeyDDLog, kDDASLDDLogValue, ASL_QUERY_OP_NOT_EQUAL);
#if !TARGET_OS_IPHONE || (defined(TARGET_SIMULATOR) && TARGET_SIMULATOR)
    int processId = [[NSProcessInfo processInfo] processIdentifier];
    char pid[16];
    snprintf(pid, sizeof(pid), "%d", processId);
    asl_set_query(query, ASL_KEY_PID, pid, ASL_QUERY_OP_EQUAL | ASL_QUERY_OP_NUMERIC);
#endif
}
+ (void)aslMessageReceived:(aslmsg)msg {
    const char* messageCString = asl_get( msg, ASL_KEY_MSG );
    if ( messageCString == NULL )
        return;
    DDLogFlag flag;
    BOOL async;
    const char* levelCString = asl_get(msg, ASL_KEY_LEVEL);
    switch (levelCString? atoi(levelCString) : 0) {
        case ASL_LEVEL_EMERG    :
        case ASL_LEVEL_ALERT    :
        case ASL_LEVEL_CRIT     : flag = DDLogFlagError;    async = NO;  break;
        case ASL_LEVEL_ERR      : flag = DDLogFlagWarning;  async = YES; break;
        case ASL_LEVEL_WARNING  : flag = DDLogFlagInfo;     async = YES; break;
        case ASL_LEVEL_NOTICE   : flag = DDLogFlagDebug;    async = YES; break;
        case ASL_LEVEL_INFO     :
        case ASL_LEVEL_DEBUG    :
        default                 : flag = DDLogFlagVerbose;  async = YES;  break;
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
    DDLogMessage *logMessage = [[DDLogMessage alloc] initWithMessage:message
                                                               level:_captureLevel
                                                                flag:flag
                                                             context:0
                                                                file:@"DDASLLogCapture"
                                                            function:nil
                                                                line:0
                                                                 tag:nil
                                                             options:0
                                                           timestamp:timeStamp];
    [DDLog log:async message:logMessage];
}
+ (void)captureAslLogs {
    @autoreleasepool
    {
        struct timeval timeval = {
            .tv_sec = 0
        };
        gettimeofday(&timeval, NULL);
        unsigned long long startTime = (unsigned long long)timeval.tv_sec;
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
                while ((msg = asl_next(response)))
                {
                    [self aslMessageReceived:msg];
                    lastSeenID = (unsigned long long)atoll(asl_get(msg, ASL_KEY_MSG_ID));
                }
                asl_release(response);
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
#endif