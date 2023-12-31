#import "AWSTaskCompletionSource.h"
#import "AWSTask.h"
NS_ASSUME_NONNULL_BEGIN
@interface AWSTask (AWSTaskCompletionSource)
- (BOOL)trySetResult:(nullable id)result;
- (BOOL)trySetError:(NSError *)error;
- (BOOL)trySetCancelled;
@end
@implementation AWSTaskCompletionSource
#pragma mark - Initializer
+ (instancetype)taskCompletionSource {
    return [[self alloc] init];
}
- (instancetype)init {
    self = [super init];
    if (!self) return self;
    _task = [[AWSTask alloc] init];
    return self;
}
#pragma mark - Custom Setters/Getters
- (void)setResult:(nullable id)result {
    if (![self.task trySetResult:result]) {
        [NSException raise:NSInternalInconsistencyException
                    format:@"Cannot set the result on a completed task."];
    }
}
- (void)setError:(NSError *)error {
    if (![self.task trySetError:error]) {
        [NSException raise:NSInternalInconsistencyException
                    format:@"Cannot set the error on a completed task."];
    }
}
- (void)cancel {
    if (![self.task trySetCancelled]) {
        [NSException raise:NSInternalInconsistencyException
                    format:@"Cannot cancel a completed task."];
    }
}
- (BOOL)trySetResult:(nullable id)result {
    return [self.task trySetResult:result];
}
- (BOOL)trySetError:(NSError *)error {
    return [self.task trySetError:error];
}
- (BOOL)trySetCancelled {
    return [self.task trySetCancelled];
}
@end
NS_ASSUME_NONNULL_END