#import <Foundation/Foundation.h>
#if OS_OBJECT_USE_OBJC
    #define DISPATCH_QUEUE_REFERENCE_TYPE strong
#else
    #define DISPATCH_QUEUE_REFERENCE_TYPE assign
#endif
@class AWSDDLogMessage;
@class AWSDDLoggerInformation;
@protocol AWSDDLogger;
@protocol AWSDDLogFormatter;
typedef NS_OPTIONS(NSUInteger, AWSDDLogFlag){
    AWSDDLogFlagError      = (1 << 0),
    AWSDDLogFlagWarning    = (1 << 1),
    AWSDDLogFlagInfo       = (1 << 2),
    AWSDDLogFlagDebug      = (1 << 3),
    AWSDDLogFlagVerbose    = (1 << 4)
};
typedef NS_ENUM(NSUInteger, AWSDDLogLevel){
    AWSDDLogLevelOff       = 0,
    AWSDDLogLevelError     = (AWSDDLogFlagError),
    AWSDDLogLevelWarning   = (AWSDDLogLevelError   | AWSDDLogFlagWarning),
    AWSDDLogLevelInfo      = (AWSDDLogLevelWarning | AWSDDLogFlagInfo),
    AWSDDLogLevelDebug     = (AWSDDLogLevelInfo    | AWSDDLogFlagDebug),
    AWSDDLogLevelVerbose   = (AWSDDLogLevelDebug   | AWSDDLogFlagVerbose),
    AWSDDLogLevelAll       = NSUIntegerMax
};
NS_ASSUME_NONNULL_BEGIN
NSString * __nullable AWSDDExtractFileNameWithoutExtension(const char *filePath, BOOL copy);
#ifndef THIS_FILE
    #define THIS_FILE         (AWSDDExtractFileNameWithoutExtension(__FILE__, NO))
#endif
#define AWS_THIS_FILE         (AWSDDExtractFileNameWithoutExtension(__FILE__, NO))
#define THIS_METHOD       NSStringFromSelector(_cmd)
#pragma mark -
@interface AWSDDLog : NSObject
@property (class, nonatomic, strong, readonly) AWSDDLog *sharedInstance;
@property (nonatomic, assign) AWSDDLogLevel logLevel;
@property (class, nonatomic, DISPATCH_QUEUE_REFERENCE_TYPE, readonly) dispatch_queue_t loggingQueue;
+ (void)log:(BOOL)asynchronous
      level:(AWSDDLogLevel)level
       flag:(AWSDDLogFlag)flag
    context:(NSInteger)context
       file:(const char *)file
   function:(const char *)function
       line:(NSUInteger)line
        tag:(id __nullable)tag
     format:(NSString *)format, ... NS_FORMAT_FUNCTION(9,10);
- (void)log:(BOOL)asynchronous
      level:(AWSDDLogLevel)level
       flag:(AWSDDLogFlag)flag
    context:(NSInteger)context
       file:(const char *)file
   function:(const char *)function
       line:(NSUInteger)line
        tag:(id __nullable)tag
     format:(NSString *)format, ... NS_FORMAT_FUNCTION(9,10);
+ (void)log:(BOOL)asynchronous
      level:(AWSDDLogLevel)level
       flag:(AWSDDLogFlag)flag
    context:(NSInteger)context
       file:(const char *)file
   function:(const char *)function
       line:(NSUInteger)line
        tag:(id __nullable)tag
     format:(NSString *)format
       args:(va_list)argList NS_SWIFT_NAME(log(asynchronous:level:flag:context:file:function:line:tag:format:arguments:));
- (void)log:(BOOL)asynchronous
      level:(AWSDDLogLevel)level
       flag:(AWSDDLogFlag)flag
    context:(NSInteger)context
       file:(const char *)file
   function:(const char *)function
       line:(NSUInteger)line
        tag:(id __nullable)tag
     format:(NSString *)format
       args:(va_list)argList NS_SWIFT_NAME(log(asynchronous:level:flag:context:file:function:line:tag:format:arguments:));
+ (void)log:(BOOL)asynchronous
    message:(AWSDDLogMessage *)logMessage NS_SWIFT_NAME(log(asynchronous:message:));
- (void)log:(BOOL)asynchronous
    message:(AWSDDLogMessage *)logMessage NS_SWIFT_NAME(log(asynchronous:message:));
+ (void)flushLog;
- (void)flushLog;
+ (void)addLogger:(id <AWSDDLogger>)logger;
- (void)addLogger:(id <AWSDDLogger>)logger;
+ (void)addLogger:(id <AWSDDLogger>)logger withLevel:(AWSDDLogLevel)level;
- (void)addLogger:(id <AWSDDLogger>)logger withLevel:(AWSDDLogLevel)level;
+ (void)removeLogger:(id <AWSDDLogger>)logger;
- (void)removeLogger:(id <AWSDDLogger>)logger;
+ (void)removeAllLoggers;
- (void)removeAllLoggers;
@property (class, nonatomic, copy, readonly) NSArray<id<AWSDDLogger>> *allLoggers;
@property (nonatomic, copy, readonly) NSArray<id<AWSDDLogger>> *allLoggers;
@property (class, nonatomic, copy, readonly) NSArray<AWSDDLoggerInformation *> *allLoggersWithLevel;
@property (nonatomic, copy, readonly) NSArray<AWSDDLoggerInformation *> *allLoggersWithLevel;
@property (class, nonatomic, copy, readonly) NSArray<Class> *registeredClasses;
@property (class, nonatomic, copy, readonly) NSArray<NSString*> *registeredClassNames;
+ (AWSDDLogLevel)levelForClass:(Class)aClass;
+ (AWSDDLogLevel)levelForClassWithName:(NSString *)aClassName;
+ (void)setLevel:(AWSDDLogLevel)level forClass:(Class)aClass;
+ (void)setLevel:(AWSDDLogLevel)level forClassWithName:(NSString *)aClassName;
@end
#pragma mark -
@protocol AWSDDLogger <NSObject>
- (void)logMessage:(AWSDDLogMessage *)logMessage NS_SWIFT_NAME(log(message:));
@property (nonatomic, strong) id <AWSDDLogFormatter> logFormatter;
@optional
- (void)didAddLogger;
- (void)didAddLoggerInQueue:(dispatch_queue_t)queue;
- (void)willRemoveLogger;
- (void)flush;
@property (nonatomic, DISPATCH_QUEUE_REFERENCE_TYPE, readonly) dispatch_queue_t loggerQueue;
@property (nonatomic, readonly) NSString *loggerName;
@end
#pragma mark -
@protocol AWSDDLogFormatter <NSObject>
@required
- (NSString * __nullable)formatLogMessage:(AWSDDLogMessage *)logMessage NS_SWIFT_NAME(format(message:));
@optional
- (void)didAddToLogger:(id <AWSDDLogger>)logger;
- (void)didAddToLogger:(id <AWSDDLogger>)logger inQueue:(dispatch_queue_t)queue;
- (void)willRemoveFromLogger:(id <AWSDDLogger>)logger;
@end
#pragma mark -
@protocol AWSDDRegisteredDynamicLogging
@property (class, nonatomic, readwrite, setter=ddSetLogLevel:) AWSDDLogLevel ddLogLevel;
@end
#pragma mark -
#ifndef NS_DESIGNATED_INITIALIZER
    #define NS_DESIGNATED_INITIALIZER
#endif
typedef NS_OPTIONS(NSInteger, AWSDDLogMessageOptions){
    AWSDDLogMessageCopyFile        = 1 << 0,
    AWSDDLogMessageCopyFunction    = 1 << 1,
    AWSDDLogMessageDontCopyMessage = 1 << 2
};
@interface AWSDDLogMessage : NSObject <NSCopying>
{
    @public
    NSString *_message;
    AWSDDLogLevel _level;
    AWSDDLogFlag _flag;
    NSInteger _context;
    NSString *_file;
    NSString *_fileName;
    NSString *_function;
    NSUInteger _line;
    id _tag;
    AWSDDLogMessageOptions _options;
    NSDate *_timestamp;
    NSString *_threadID;
    NSString *_threadName;
    NSString *_queueLabel;
}
- (instancetype)init NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithMessage:(NSString *)message
                          level:(AWSDDLogLevel)level
                           flag:(AWSDDLogFlag)flag
                        context:(NSInteger)context
                           file:(NSString *)file
                       function:(NSString * __nullable)function
                           line:(NSUInteger)line
                            tag:(id __nullable)tag
                        options:(AWSDDLogMessageOptions)options
                      timestamp:(NSDate * __nullable)timestamp NS_DESIGNATED_INITIALIZER;
@property (readonly, nonatomic) NSString *message;
@property (readonly, nonatomic) AWSDDLogLevel level;
@property (readonly, nonatomic) AWSDDLogFlag flag;
@property (readonly, nonatomic) NSInteger context;
@property (readonly, nonatomic) NSString *file;
@property (readonly, nonatomic) NSString *fileName;
@property (readonly, nonatomic) NSString * __nullable function;
@property (readonly, nonatomic) NSUInteger line;
@property (readonly, nonatomic) id __nullable tag;
@property (readonly, nonatomic) AWSDDLogMessageOptions options;
@property (readonly, nonatomic) NSDate *timestamp;
@property (readonly, nonatomic) NSString *threadID; 
@property (readonly, nonatomic) NSString *threadName;
@property (readonly, nonatomic) NSString *queueLabel;
@end
#pragma mark -
@interface AWSDDAbstractLogger : NSObject <AWSDDLogger>
{
    @public
    id <AWSDDLogFormatter> _logFormatter;
    dispatch_queue_t _loggerQueue;
}
@property (nonatomic, strong, nullable) id <AWSDDLogFormatter> logFormatter;
@property (nonatomic, DISPATCH_QUEUE_REFERENCE_TYPE) dispatch_queue_t loggerQueue;
@property (nonatomic, readonly, getter=isOnGlobalLoggingQueue)  BOOL onGlobalLoggingQueue;
@property (nonatomic, readonly, getter=isOnInternalLoggerQueue) BOOL onInternalLoggerQueue;
@end
#pragma mark -
@interface AWSDDLoggerInformation : NSObject
@property (nonatomic, readonly) id <AWSDDLogger> logger;
@property (nonatomic, readonly) AWSDDLogLevel level;
+ (AWSDDLoggerInformation *)informationWithLogger:(id <AWSDDLogger>)logger
                           andLevel:(AWSDDLogLevel)level;
@end
NS_ASSUME_NONNULL_END