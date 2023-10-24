#import <JDYThreadTrace/JDYThreadTracer.h>
#import <mach/mach.h>
@interface JDYThreadTracer (Backtrace)
+ (NSArray <NSNumber *>*)backtraceThread:(thread_t)thread;
+ (BOOL)isTraceFrame:(uintptr_t)framePtr inImage:(NSString *)imageName;
+ (NSArray <NSString *>*)symbolicateBacktrace:(NSArray <NSNumber *>*)stacks;
+ (NSArray <NSString *>*)symbolicateBacktrace:(NSArray <NSNumber *>*)stacks showAddress:(BOOL)showAddress;
+ (NSArray <NSString *>*)backtraceAndSymbolicateThread:(thread_t)thread;
+ (dispatch_queue_t)queueForThread:(thread_t)thread;
+ (NSString*)queueNameForThread:(thread_t)thread;
+ (NSString*)threadNameForThread:(thread_t)thread;
+ (void)disableSuspendMainThread;
+ (void)enableSuspendMainThread;
+ (void)setMainThreadId:(thread_t)mainThreadId;
@end