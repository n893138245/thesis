#ifndef AWSDD_LEGACY_MACROS
    #define AWSDD_LEGACY_MACROS 0
#endif
#import "AWSDDLog.h"
#import <pthread.h>
#import <dispatch/dispatch.h>
#import <objc/runtime.h>
#import <mach/mach_host.h>
#import <mach/host_info.h>
#import <libkern/OSAtomic.h>
#import <Availability.h>
#if TARGET_OS_IOS
    #import <UIKit/UIDevice.h>
#endif
#if !__has_feature(objc_arc)
#error This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif
#ifndef AWSDD_DEBUG
    #define AWSDD_DEBUG NO
#endif
#define NSLogDebug(frmt, ...) do{ if(AWSDD_DEBUG) NSLog((frmt), ##__VA_ARGS__); } while(0)
#ifndef AWSDDLOG_MAX_QUEUE_SIZE
    #define AWSDDLOG_MAX_QUEUE_SIZE 1000 
#endif
static void *const GlobalLoggingQueueIdentityKey = (void *)&GlobalLoggingQueueIdentityKey;
@interface AWSDDLoggerNode : NSObject
{
    @public
    id <AWSDDLogger> _logger;
    AWSDDLogLevel _level;
    dispatch_queue_t _loggerQueue;
}
@property (nonatomic, readonly) id <AWSDDLogger> logger;
@property (nonatomic, readonly) AWSDDLogLevel level;
@property (nonatomic, readonly) dispatch_queue_t loggerQueue;
+ (AWSDDLoggerNode *)nodeWithLogger:(id <AWSDDLogger>)logger
                     loggerQueue:(dispatch_queue_t)loggerQueue
                           level:(AWSDDLogLevel)level;
@end
#pragma mark -
@interface AWSDDLog ()
@property (nonatomic, strong) NSMutableArray *_loggers;
@end
@implementation AWSDDLog
static dispatch_queue_t _loggingQueue;
static dispatch_group_t _loggingGroup;
static dispatch_semaphore_t _queueSemaphore;
static NSUInteger _numProcessors;
+ (instancetype)sharedInstance {
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}
+ (void)initialize {
    static dispatch_once_t AWSDDLogOnceToken;
    dispatch_once(&AWSDDLogOnceToken, ^{
        NSLogDebug(@"AWSDDLog: Using grand central dispatch");
        _loggingQueue = dispatch_queue_create("cocoa.lumberjack", NULL);
        _loggingGroup = dispatch_group_create();
        void *nonNullValue = GlobalLoggingQueueIdentityKey; 
        dispatch_queue_set_specific(_loggingQueue, GlobalLoggingQueueIdentityKey, nonNullValue, NULL);
        _queueSemaphore = dispatch_semaphore_create(AWSDDLOG_MAX_QUEUE_SIZE);
        _numProcessors = MAX([NSProcessInfo processInfo].processorCount, (NSUInteger) 1);
        NSLogDebug(@"AWSDDLog: numProcessors = %@", @(_numProcessors));
    });
}
- (id)init {
    self = [super init];
    if (self) {
        self._loggers = [[NSMutableArray alloc] initWithCapacity:4];
        self.logLevel = AWSDDLogLevelWarning;
#if TARGET_OS_IOS
        NSString *notificationName = @"UIApplicationWillTerminateNotification";
#else
        NSString *notificationName = nil;
#ifdef NSAppKitVersionNumber10_0
        if (NSApp) {
            notificationName = @"NSApplicationWillTerminateNotification";
        }
#endif
        if (!notificationName) {
            atexit_b (^{
                [self applicationWillTerminate:nil];
            });
        }
#endif 
        if (notificationName) {
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(applicationWillTerminate:)
                                                         name:notificationName
                                                       object:nil];
        }
    }
    return self;
}
+ (dispatch_queue_t)loggingQueue {
    return _loggingQueue;
}
#pragma mark Notifications
- (void)applicationWillTerminate:(NSNotification * __attribute__((unused)))notification {
    [self flushLog];
}
#pragma mark Logger Management
+ (void)addLogger:(id <AWSDDLogger>)logger {
    [self.sharedInstance addLogger:logger];
}
- (void)addLogger:(id <AWSDDLogger>)logger {
    [self addLogger:logger withLevel:AWSDDLogLevelAll]; 
}
+ (void)addLogger:(id <AWSDDLogger>)logger withLevel:(AWSDDLogLevel)level {
    [self.sharedInstance addLogger:logger withLevel:level];
}
- (void)addLogger:(id <AWSDDLogger>)logger withLevel:(AWSDDLogLevel)level {
    if (!logger) {
        return;
    }
    dispatch_async(_loggingQueue, ^{ @autoreleasepool {
        [self lt_addLogger:logger level:level];
    } });
}
+ (void)removeLogger:(id <AWSDDLogger>)logger {
    [self.sharedInstance removeLogger:logger];
}
- (void)removeLogger:(id <AWSDDLogger>)logger {
    if (!logger) {
        return;
    }
    dispatch_async(_loggingQueue, ^{ @autoreleasepool {
        [self lt_removeLogger:logger];
    } });
}
+ (void)removeAllLoggers {
    [self.sharedInstance removeAllLoggers];
}
- (void)removeAllLoggers {
    dispatch_async(_loggingQueue, ^{ @autoreleasepool {
        [self lt_removeAllLoggers];
    } });
}
+ (NSArray<id<AWSDDLogger>> *)allLoggers {
    return [self.sharedInstance allLoggers];
}
- (NSArray<id<AWSDDLogger>> *)allLoggers {
    __block NSArray *theLoggers;
    dispatch_sync(_loggingQueue, ^{ @autoreleasepool {
        theLoggers = [self lt_allLoggers];
    } });
    return theLoggers;
}
+ (NSArray<AWSDDLoggerInformation *> *)allLoggersWithLevel {
    return [self.sharedInstance allLoggersWithLevel];
}
- (NSArray<AWSDDLoggerInformation *> *)allLoggersWithLevel {
    __block NSArray *theLoggersWithLevel;
    dispatch_sync(_loggingQueue, ^{ @autoreleasepool {
        theLoggersWithLevel = [self lt_allLoggersWithLevel];
    } });
    return theLoggersWithLevel;
}
#pragma mark - Master Logging
- (void)queueLogMessage:(AWSDDLogMessage *)logMessage asynchronously:(BOOL)asyncFlag {
    dispatch_semaphore_wait(_queueSemaphore, DISPATCH_TIME_FOREVER);
    dispatch_block_t logBlock = ^{
        @autoreleasepool {
            [self lt_log:logMessage];
        }
    };
    if (asyncFlag) {
        dispatch_async(_loggingQueue, logBlock);
    } else {
        dispatch_sync(_loggingQueue, logBlock);
    }
}
+ (void)log:(BOOL)asynchronous
      level:(AWSDDLogLevel)level
       flag:(AWSDDLogFlag)flag
    context:(NSInteger)context
       file:(const char *)file
   function:(const char *)function
       line:(NSUInteger)line
        tag:(id)tag
     format:(NSString *)format, ... {
    va_list args;
    if (format) {
        va_start(args, format);
        NSString *message = [[NSString alloc] initWithFormat:format arguments:args];
        va_end(args);
        va_start(args, format);
        [self log:asynchronous
          message:message
            level:level
             flag:flag
          context:context
             file:file
         function:function
             line:line
              tag:tag];
        va_end(args);
    }
}
- (void)log:(BOOL)asynchronous
      level:(AWSDDLogLevel)level
       flag:(AWSDDLogFlag)flag
    context:(NSInteger)context
       file:(const char *)file
   function:(const char *)function
       line:(NSUInteger)line
        tag:(id)tag
     format:(NSString *)format, ... {
    va_list args;
    if (format) {
        va_start(args, format);
        NSString *message = [[NSString alloc] initWithFormat:format arguments:args];
        va_end(args);
        va_start(args, format);
        [self log:asynchronous
          message:message
            level:level
             flag:flag
          context:context
             file:file
         function:function
             line:line
              tag:tag];
        va_end(args);
    }
}
+ (void)log:(BOOL)asynchronous
      level:(AWSDDLogLevel)level
       flag:(AWSDDLogFlag)flag
    context:(NSInteger)context
       file:(const char *)file
   function:(const char *)function
       line:(NSUInteger)line
        tag:(id)tag
     format:(NSString *)format
       args:(va_list)args {
    [self.sharedInstance log:asynchronous level:level flag:flag context:context file:file function:function line:line tag:tag format:format args:args];
}
- (void)log:(BOOL)asynchronous
      level:(AWSDDLogLevel)level
       flag:(AWSDDLogFlag)flag
    context:(NSInteger)context
       file:(const char *)file
   function:(const char *)function
       line:(NSUInteger)line
        tag:(id)tag
     format:(NSString *)format
       args:(va_list)args {
    if (format) {
        NSString *message = [[NSString alloc] initWithFormat:format arguments:args];
        [self log:asynchronous
          message:message
            level:level
             flag:flag
          context:context
             file:file
         function:function
             line:line
              tag:tag];
    }
}
+ (void)log:(BOOL)asynchronous
    message:(NSString *)message
      level:(AWSDDLogLevel)level
       flag:(AWSDDLogFlag)flag
    context:(NSInteger)context
       file:(const char *)file
   function:(const char *)function
       line:(NSUInteger)line
        tag:(id)tag {
    [self.sharedInstance log:asynchronous message:message level:level flag:flag context:context file:file function:function line:line tag:tag];
}
- (void)log:(BOOL)asynchronous
    message:(NSString *)message
      level:(AWSDDLogLevel)level
       flag:(AWSDDLogFlag)flag
    context:(NSInteger)context
       file:(const char *)file
   function:(const char *)function
       line:(NSUInteger)line
        tag:(id)tag {
    if(level & flag){
        AWSDDLogMessage *logMessage = [[AWSDDLogMessage alloc] initWithMessage:message
                                                                         level:level
                                                                          flag:flag
                                                                       context:context
                                                                          file:[NSString stringWithFormat:@"%s", file]
                                                                      function:[NSString stringWithFormat:@"%s", function]
                                                                          line:line
                                                                           tag:tag
                                                                       options:(AWSDDLogMessageOptions)0
                                                                     timestamp:nil];
        [self queueLogMessage:logMessage asynchronously:asynchronous];
    }
}
+ (void)log:(BOOL)asynchronous
    message:(AWSDDLogMessage *)logMessage {
    [self.sharedInstance log:asynchronous message:logMessage];
}
- (void)log:(BOOL)asynchronous
    message:(AWSDDLogMessage *)logMessage {
    [self queueLogMessage:logMessage asynchronously:asynchronous];
}
+ (void)flushLog {
    [self.sharedInstance flushLog];
}
- (void)flushLog {
    dispatch_sync(_loggingQueue, ^{ @autoreleasepool {
        [self lt_flush];
    } });
}
#pragma mark Registered Dynamic Logging
+ (BOOL)isRegisteredClass:(Class)class {
    SEL getterSel = @selector(ddLogLevel);
    SEL setterSel = @selector(ddSetLogLevel:);
#if TARGET_OS_IPHONE && !TARGET_OS_SIMULATOR
    BOOL result = NO;
    unsigned int methodCount, i;
    Method *methodList = class_copyMethodList(object_getClass(class), &methodCount);
    if (methodList != NULL) {
        BOOL getterFound = NO;
        BOOL setterFound = NO;
        for (i = 0; i < methodCount; ++i) {
            SEL currentSel = method_getName(methodList[i]);
            if (currentSel == getterSel) {
                getterFound = YES;
            } else if (currentSel == setterSel) {
                setterFound = YES;
            }
            if (getterFound && setterFound) {
                result = YES;
                break;
            }
        }
        free(methodList);
    }
    return result;
#else 
    Method getter = class_getClassMethod(class, getterSel);
    Method setter = class_getClassMethod(class, setterSel);
    if ((getter != NULL) && (setter != NULL)) {
        return YES;
    }
    return NO;
#endif 
}
+ (NSArray *)registeredClasses {
    NSUInteger numClasses = 0;
    Class *classes = NULL;
    while (numClasses == 0) {
        numClasses = (NSUInteger)MAX(objc_getClassList(NULL, 0), 0);
        NSUInteger bufferSize = numClasses;
        classes = numClasses ? (Class *)malloc(sizeof(Class) * bufferSize) : NULL;
        if (classes == NULL) {
            return @[]; 
        }
        numClasses = (NSUInteger)MAX(objc_getClassList(classes, (int)bufferSize),0);
        if (numClasses > bufferSize || numClasses == 0) {
            free(classes);
            numClasses = 0;
        }
    }
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:numClasses];
    for (NSUInteger i = 0; i < numClasses; i++) {
        Class class = classes[i];
        if ([self isRegisteredClass:class]) {
            [result addObject:class];
        }
    }
    free(classes);
    return result;
}
+ (NSArray *)registeredClassNames {
    NSArray *registeredClasses = [self registeredClasses];
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:[registeredClasses count]];
    for (Class class in registeredClasses) {
        [result addObject:NSStringFromClass(class)];
    }
    return result;
}
+ (AWSDDLogLevel)levelForClass:(Class)aClass {
    if ([self isRegisteredClass:aClass]) {
        return [aClass ddLogLevel];
    }
    return (AWSDDLogLevel)-1;
}
+ (AWSDDLogLevel)levelForClassWithName:(NSString *)aClassName {
    Class aClass = NSClassFromString(aClassName);
    return [self levelForClass:aClass];
}
+ (void)setLevel:(AWSDDLogLevel)level forClass:(Class)aClass {
    if ([self isRegisteredClass:aClass]) {
        [aClass ddSetLogLevel:level];
    }
}
+ (void)setLevel:(AWSDDLogLevel)level forClassWithName:(NSString *)aClassName {
    Class aClass = NSClassFromString(aClassName);
    [self setLevel:level forClass:aClass];
}
#pragma mark Logging Thread
- (void)lt_addLogger:(id <AWSDDLogger>)logger level:(AWSDDLogLevel)level {
    for (AWSDDLoggerNode* node in self._loggers) {
        if (node->_logger == logger
            && node->_level == level) {
            return;
        }
    }
    NSAssert(dispatch_get_specific(GlobalLoggingQueueIdentityKey),
             @"This method should only be run on the logging thread/queue");
    dispatch_queue_t loggerQueue = NULL;
    if ([logger respondsToSelector:@selector(loggerQueue)]) {
        loggerQueue = [logger loggerQueue];
    }
    if (loggerQueue == nil) {
        const char *loggerQueueName = NULL;
        if ([logger respondsToSelector:@selector(loggerName)]) {
            loggerQueueName = [[logger loggerName] UTF8String];
        }
        loggerQueue = dispatch_queue_create(loggerQueueName, NULL);
    }
    AWSDDLoggerNode *loggerNode = [AWSDDLoggerNode nodeWithLogger:logger loggerQueue:loggerQueue level:level];
    [self._loggers addObject:loggerNode];
    if ([logger respondsToSelector:@selector(didAddLoggerInQueue:)]) {
        dispatch_async(loggerNode->_loggerQueue, ^{ @autoreleasepool {
            [logger didAddLoggerInQueue:loggerNode->_loggerQueue];
        } });
    } else if ([logger respondsToSelector:@selector(didAddLogger)]) {
        dispatch_async(loggerNode->_loggerQueue, ^{ @autoreleasepool {
            [logger didAddLogger];
        } });
    }
}
- (void)lt_removeLogger:(id <AWSDDLogger>)logger {
    NSAssert(dispatch_get_specific(GlobalLoggingQueueIdentityKey),
             @"This method should only be run on the logging thread/queue");
    AWSDDLoggerNode *loggerNode = nil;
    for (AWSDDLoggerNode *node in self._loggers) {
        if (node->_logger == logger) {
            loggerNode = node;
            break;
        }
    }
    if (loggerNode == nil) {
        NSLogDebug(@"AWSDDLog: Request to remove logger which wasn't added");
        return;
    }
    if ([logger respondsToSelector:@selector(willRemoveLogger)]) {
        dispatch_async(loggerNode->_loggerQueue, ^{ @autoreleasepool {
            [logger willRemoveLogger];
        } });
    }
    [self._loggers removeObject:loggerNode];
}
- (void)lt_removeAllLoggers {
    NSAssert(dispatch_get_specific(GlobalLoggingQueueIdentityKey),
             @"This method should only be run on the logging thread/queue");
    for (AWSDDLoggerNode *loggerNode in self._loggers) {
        if ([loggerNode->_logger respondsToSelector:@selector(willRemoveLogger)]) {
            dispatch_async(loggerNode->_loggerQueue, ^{ @autoreleasepool {
                [loggerNode->_logger willRemoveLogger];
            } });
        }
    }
    [self._loggers removeAllObjects];
}
- (NSArray *)lt_allLoggers {
    NSAssert(dispatch_get_specific(GlobalLoggingQueueIdentityKey),
             @"This method should only be run on the logging thread/queue");
    NSMutableArray *theLoggers = [NSMutableArray new];
    for (AWSDDLoggerNode *loggerNode in self._loggers) {
        [theLoggers addObject:loggerNode->_logger];
    }
    return [theLoggers copy];
}
- (NSArray *)lt_allLoggersWithLevel {
    NSAssert(dispatch_get_specific(GlobalLoggingQueueIdentityKey),
             @"This method should only be run on the logging thread/queue");
    NSMutableArray *theLoggersWithLevel = [NSMutableArray new];
    for (AWSDDLoggerNode *loggerNode in self._loggers) {
        [theLoggersWithLevel addObject:[AWSDDLoggerInformation informationWithLogger:loggerNode->_logger
                                                                         andLevel:loggerNode->_level]];
    }
    return [theLoggersWithLevel copy];
}
- (void)lt_log:(AWSDDLogMessage *)logMessage {
    NSAssert(dispatch_get_specific(GlobalLoggingQueueIdentityKey),
             @"This method should only be run on the logging thread/queue");
    if (_numProcessors > 1) {
        for (AWSDDLoggerNode *loggerNode in self._loggers) {
            if (!(logMessage->_flag & loggerNode->_level)) {
                continue;
            }
            dispatch_group_async(_loggingGroup, loggerNode->_loggerQueue, ^{ @autoreleasepool {
                [loggerNode->_logger logMessage:logMessage];
            } });
        }
        dispatch_group_wait(_loggingGroup, DISPATCH_TIME_FOREVER);
    } else {
        for (AWSDDLoggerNode *loggerNode in self._loggers) {
            if (!(logMessage->_flag & loggerNode->_level)) {
                continue;
            }
            dispatch_sync(loggerNode->_loggerQueue, ^{ @autoreleasepool {
                [loggerNode->_logger logMessage:logMessage];
            } });
        }
    }
    dispatch_semaphore_signal(_queueSemaphore);
}
- (void)lt_flush {
    NSAssert(dispatch_get_specific(GlobalLoggingQueueIdentityKey),
             @"This method should only be run on the logging thread/queue");
    for (AWSDDLoggerNode *loggerNode in self._loggers) {
        if ([loggerNode->_logger respondsToSelector:@selector(flush)]) {
            dispatch_group_async(_loggingGroup, loggerNode->_loggerQueue, ^{ @autoreleasepool {
                [loggerNode->_logger flush];
            } });
        }
    }
    dispatch_group_wait(_loggingGroup, DISPATCH_TIME_FOREVER);
}
#pragma mark Utilities
NSString * __nullable AWSDDExtractFileNameWithoutExtension(const char *filePath, BOOL copy) {
    if (filePath == NULL) {
        return nil;
    }
    char *lastSlash = NULL;
    char *lastDot = NULL;
    char *p = (char *)filePath;
    while (*p != '\0') {
        if (*p == '/') {
            lastSlash = p;
        } else if (*p == '.') {
            lastDot = p;
        }
        p++;
    }
    char *subStr;
    NSUInteger subLen;
    if (lastSlash) {
        if (lastDot) {
            subStr = lastSlash + 1;
            subLen = (NSUInteger)(lastDot - subStr);
        } else {
            subStr = lastSlash + 1;
            subLen = (NSUInteger)(p - subStr);
        }
    } else {
        if (lastDot) {
            subStr = (char *)filePath;
            subLen = (NSUInteger)(lastDot - subStr);
        } else {
            subStr = (char *)filePath;
            subLen = (NSUInteger)(p - subStr);
        }
    }
    if (copy) {
        return [[NSString alloc] initWithBytes:subStr
                                        length:subLen
                                      encoding:NSUTF8StringEncoding];
    } else {
        return [[NSString alloc] initWithBytesNoCopy:subStr
                                              length:subLen
                                            encoding:NSUTF8StringEncoding
                                        freeWhenDone:NO];
    }
}
@end
#pragma mark -
@implementation AWSDDLoggerNode
- (instancetype)initWithLogger:(id <AWSDDLogger>)logger loggerQueue:(dispatch_queue_t)loggerQueue level:(AWSDDLogLevel)level {
    if ((self = [super init])) {
        _logger = logger;
        if (loggerQueue) {
            _loggerQueue = loggerQueue;
            #if !OS_OBJECT_USE_OBJC
            dispatch_retain(loggerQueue);
            #endif
        }
        _level = level;
    }
    return self;
}
+ (AWSDDLoggerNode *)nodeWithLogger:(id <AWSDDLogger>)logger loggerQueue:(dispatch_queue_t)loggerQueue level:(AWSDDLogLevel)level {
    return [[AWSDDLoggerNode alloc] initWithLogger:logger loggerQueue:loggerQueue level:level];
}
- (void)dealloc {
    #if !OS_OBJECT_USE_OBJC
    if (_loggerQueue) {
        dispatch_release(_loggerQueue);
    }
    #endif
}
@end
#pragma mark -
@implementation AWSDDLogMessage
#if TARGET_OS_IOS
static BOOL _use_dispatch_current_queue_label;
static BOOL _use_dispatch_get_current_queue;
static void _dispatch_queue_label_init_once(void * __attribute__((unused)) context)
{
    _use_dispatch_current_queue_label = (UIDevice.currentDevice.systemVersion.floatValue >= 7.0f);
    _use_dispatch_get_current_queue = (!_use_dispatch_current_queue_label && UIDevice.currentDevice.systemVersion.floatValue >= 6.1f);
}
static __inline__ __attribute__((__always_inline__)) void _dispatch_queue_label_init()
{
    static dispatch_once_t onceToken;
    dispatch_once_f(&onceToken, NULL, _dispatch_queue_label_init_once);
}
  #define USE_DISPATCH_CURRENT_QUEUE_LABEL (_dispatch_queue_label_init(), _use_dispatch_current_queue_label)
  #define USE_DISPATCH_GET_CURRENT_QUEUE   (_dispatch_queue_label_init(), _use_dispatch_get_current_queue)
#elif TARGET_OS_WATCH || TARGET_OS_TV
  #define USE_DISPATCH_CURRENT_QUEUE_LABEL YES
  #define USE_DISPATCH_GET_CURRENT_QUEUE   NO
#else
  #ifndef MAC_OS_X_VERSION_10_9
    #define MAC_OS_X_VERSION_10_9            1090
  #endif
  #if MAC_OS_X_VERSION_MIN_REQUIRED >= MAC_OS_X_VERSION_10_9 
    #define USE_DISPATCH_CURRENT_QUEUE_LABEL YES
    #define USE_DISPATCH_GET_CURRENT_QUEUE   NO
  #else
static BOOL _use_dispatch_current_queue_label;
static BOOL _use_dispatch_get_current_queue;
static void _dispatch_queue_label_init_once(void * __attribute__((unused)) context)
{
    _use_dispatch_current_queue_label = [NSTimer instancesRespondToSelector : @selector(tolerance)]; 
    _use_dispatch_get_current_queue = !_use_dispatch_current_queue_label;                            
}
static __inline__ __attribute__((__always_inline__)) void _dispatch_queue_label_init()
{
    static dispatch_once_t onceToken;
    dispatch_once_f(&onceToken, NULL, _dispatch_queue_label_init_once);
}
    #define USE_DISPATCH_CURRENT_QUEUE_LABEL (_dispatch_queue_label_init(), _use_dispatch_current_queue_label)
    #define USE_DISPATCH_GET_CURRENT_QUEUE   (_dispatch_queue_label_init(), _use_dispatch_get_current_queue)
  #endif
#endif 
#if TARGET_OS_IOS
  #ifndef kCFCoreFoundationVersionNumber_iOS_8_0
    #define kCFCoreFoundationVersionNumber_iOS_8_0 1140.10
  #endif
  #define USE_PTHREAD_THREADID_NP                (kCFCoreFoundationVersionNumber >= kCFCoreFoundationVersionNumber_iOS_8_0)
#elif TARGET_OS_WATCH || TARGET_OS_TV
  #define USE_PTHREAD_THREADID_NP                YES
#else
  #ifndef kCFCoreFoundationVersionNumber10_10
    #define kCFCoreFoundationVersionNumber10_10    1151.16
  #endif
  #define USE_PTHREAD_THREADID_NP                (kCFCoreFoundationVersionNumber >= kCFCoreFoundationVersionNumber10_10)
#endif 
- (instancetype)init {
    self = [super init];
    return self;
}
- (instancetype)initWithMessage:(NSString *)message
                          level:(AWSDDLogLevel)level
                           flag:(AWSDDLogFlag)flag
                        context:(NSInteger)context
                           file:(NSString *)file
                       function:(NSString *)function
                           line:(NSUInteger)line
                            tag:(id)tag
                        options:(AWSDDLogMessageOptions)options
                      timestamp:(NSDate *)timestamp {
    if ((self = [super init])) {
        BOOL copyMessage = (options & AWSDDLogMessageDontCopyMessage) == 0;
        _message      = copyMessage ? [message copy] : message;
        _level        = level;
        _flag         = flag;
        _context      = context;
        BOOL copyFile = (options & AWSDDLogMessageCopyFile) != 0;
        _file = copyFile ? [file copy] : file;
        BOOL copyFunction = (options & AWSDDLogMessageCopyFunction) != 0;
        _function = copyFunction ? [function copy] : function;
        _line         = line;
        _tag          = tag;
        _options      = options;
        _timestamp    = timestamp ?: [NSDate new];
        if (USE_PTHREAD_THREADID_NP) {
            __uint64_t tid;
            pthread_threadid_np(NULL, &tid);
            _threadID = [[NSString alloc] initWithFormat:@"%llu", tid];
        } else {
            _threadID = [[NSString alloc] initWithFormat:@"%x", pthread_mach_thread_np(pthread_self())];
        }
        _threadName   = NSThread.currentThread.name;
        _fileName = [_file lastPathComponent];
        NSUInteger dotLocation = [_fileName rangeOfString:@"." options:NSBackwardsSearch].location;
        if (dotLocation != NSNotFound)
        {
            _fileName = [_fileName substringToIndex:dotLocation];
        }
        if (USE_DISPATCH_CURRENT_QUEUE_LABEL) {
            _queueLabel = [[NSString alloc] initWithFormat:@"%s", dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL)];
        } else if (USE_DISPATCH_GET_CURRENT_QUEUE) {
            #pragma clang diagnostic push
            #pragma clang diagnostic ignored "-Wdeprecated-declarations"
            dispatch_queue_t currentQueue = dispatch_get_current_queue();
            #pragma clang diagnostic pop
            _queueLabel = [[NSString alloc] initWithFormat:@"%s", dispatch_queue_get_label(currentQueue)];
        } else {
            _queueLabel = @""; 
        }
    }
    return self;
}
- (id)copyWithZone:(NSZone * __attribute__((unused)))zone {
    AWSDDLogMessage *newMessage = [AWSDDLogMessage new];
    newMessage->_message = _message;
    newMessage->_level = _level;
    newMessage->_flag = _flag;
    newMessage->_context = _context;
    newMessage->_file = _file;
    newMessage->_fileName = _fileName;
    newMessage->_function = _function;
    newMessage->_line = _line;
    newMessage->_tag = _tag;
    newMessage->_options = _options;
    newMessage->_timestamp = _timestamp;
    newMessage->_threadID = _threadID;
    newMessage->_threadName = _threadName;
    newMessage->_queueLabel = _queueLabel;
    return newMessage;
}
@end
#pragma mark -
@implementation AWSDDAbstractLogger
- (instancetype)init {
    if ((self = [super init])) {
        const char *loggerQueueName = NULL;
        if ([self respondsToSelector:@selector(loggerName)]) {
            loggerQueueName = [[self loggerName] UTF8String];
        }
        _loggerQueue = dispatch_queue_create(loggerQueueName, NULL);
        void *key = (__bridge void *)self;
        void *nonNullValue = (__bridge void *)self;
        dispatch_queue_set_specific(_loggerQueue, key, nonNullValue, NULL);
    }
    return self;
}
- (void)dealloc {
    #if !OS_OBJECT_USE_OBJC
    if (_loggerQueue) {
        dispatch_release(_loggerQueue);
    }
    #endif
}
- (void)logMessage:(AWSDDLogMessage * __attribute__((unused)))logMessage {
}
- (id <AWSDDLogFormatter>)logFormatter {
    NSAssert(![self isOnGlobalLoggingQueue], @"Core architecture requirement failure");
    NSAssert(![self isOnInternalLoggerQueue], @"MUST access ivar directly, NOT via self.* syntax.");
    dispatch_queue_t globalLoggingQueue = [AWSDDLog loggingQueue];
    __block id <AWSDDLogFormatter> result;
    dispatch_sync(globalLoggingQueue, ^{
        dispatch_sync(self->_loggerQueue, ^{
            result = self->_logFormatter;
        });
    });
    return result;
}
- (void)setLogFormatter:(id <AWSDDLogFormatter>)logFormatter {
    NSAssert(![self isOnGlobalLoggingQueue], @"Core architecture requirement failure");
    NSAssert(![self isOnInternalLoggerQueue], @"MUST access ivar directly, NOT via self.* syntax.");
    dispatch_block_t block = ^{
        @autoreleasepool {
            if (self->_logFormatter != logFormatter) {
                if ([self->_logFormatter respondsToSelector:@selector(willRemoveFromLogger:)]) {
                    [self->_logFormatter willRemoveFromLogger:self];
                }
                self->_logFormatter = logFormatter;
                if ([self->_logFormatter respondsToSelector:@selector(didAddToLogger:inQueue:)]) {
                    [self->_logFormatter didAddToLogger:self inQueue:self->_loggerQueue];
                } else if ([self->_logFormatter respondsToSelector:@selector(didAddToLogger:)]) {
                    [self->_logFormatter didAddToLogger:self];
                }
            }
        }
    };
    dispatch_queue_t globalLoggingQueue = [AWSDDLog loggingQueue];
    dispatch_async(globalLoggingQueue, ^{
        dispatch_async(self->_loggerQueue, block);
    });
}
- (dispatch_queue_t)loggerQueue {
    return _loggerQueue;
}
- (NSString *)loggerName {
    return NSStringFromClass([self class]);
}
- (BOOL)isOnGlobalLoggingQueue {
    return (dispatch_get_specific(GlobalLoggingQueueIdentityKey) != NULL);
}
- (BOOL)isOnInternalLoggerQueue {
    void *key = (__bridge void *)self;
    return (dispatch_get_specific(key) != NULL);
}
@end
#pragma mark -
@interface AWSDDLoggerInformation()
{
    @public
    id <AWSDDLogger> _logger;
    AWSDDLogLevel _level;
}
@end
@implementation AWSDDLoggerInformation
- (instancetype)initWithLogger:(id <AWSDDLogger>)logger andLevel:(AWSDDLogLevel)level {
    if ((self = [super init])) {
        _logger = logger;
        _level = level;
    }
    return self;
}
+ (AWSDDLoggerInformation *)informationWithLogger:(id <AWSDDLogger>)logger andLevel:(AWSDDLogLevel)level {
    return [[AWSDDLoggerInformation alloc] initWithLogger:logger andLevel:level];
}
@end