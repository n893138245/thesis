#import "AWSExecutor.h"
#import <pthread.h>
NS_ASSUME_NONNULL_BEGIN
__attribute__((noinline)) static size_t remaining_stack_size(size_t *restrict totalSize) {
    pthread_t currentThread = pthread_self();
    uint8_t *endStack = pthread_get_stackaddr_np(currentThread);
    *totalSize = pthread_get_stacksize_np(currentThread);
    uint8_t *frameAddr = __builtin_frame_address(0);
    return (*totalSize) - (size_t)(endStack - frameAddr);
}
@interface AWSExecutor ()
@property (nonatomic, copy) void(^block)(void(^block)(void));
@end
@implementation AWSExecutor
#pragma mark - Executor methods
+ (instancetype)defaultExecutor {
    static AWSExecutor *defaultExecutor = NULL;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultExecutor = [self executorWithBlock:^void(void(^block)(void)) {
            size_t totalStackSize = 0;
            size_t remainingStackSize = remaining_stack_size(&totalStackSize);
            if (remainingStackSize < (totalStackSize / 10)) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block);
            } else {
                @autoreleasepool {
                    block();
                }
            }
        }];
    });
    return defaultExecutor;
}
+ (instancetype)immediateExecutor {
    static AWSExecutor *immediateExecutor = NULL;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        immediateExecutor = [self executorWithBlock:^void(void(^block)(void)) {
            block();
        }];
    });
    return immediateExecutor;
}
+ (instancetype)mainThreadExecutor {
    static AWSExecutor *mainThreadExecutor = NULL;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mainThreadExecutor = [self executorWithBlock:^void(void(^block)(void)) {
            if (![NSThread isMainThread]) {
                dispatch_async(dispatch_get_main_queue(), block);
            } else {
                @autoreleasepool {
                    block();
                }
            }
        }];
    });
    return mainThreadExecutor;
}
+ (instancetype)executorWithBlock:(void(^)(void(^block)(void)))block {
    return [[self alloc] initWithBlock:block];
}
+ (instancetype)executorWithDispatchQueue:(dispatch_queue_t)queue {
    return [self executorWithBlock:^void(void(^block)(void)) {
        dispatch_async(queue, block);
    }];
}
+ (instancetype)executorWithOperationQueue:(NSOperationQueue *)queue {
    return [self executorWithBlock:^void(void(^block)(void)) {
        [queue addOperation:[NSBlockOperation blockOperationWithBlock:block]];
    }];
}
#pragma mark - Initializer
- (instancetype)initWithBlock:(void(^)(void(^block)(void)))block {
    self = [super init];
    if (!self) return self;
    _block = block;
    return self;
}
#pragma mark - Execution
- (void)execute:(void(^)(void))block {
    self.block(block);
}
@end
NS_ASSUME_NONNULL_END