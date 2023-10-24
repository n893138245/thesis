#import "AWSCancellationTokenSource.h"
#import "AWSCancellationToken.h"
NS_ASSUME_NONNULL_BEGIN
@interface AWSCancellationToken (AWSCancellationTokenSource)
- (void)cancel;
- (void)cancelAfterDelay:(int)millis;
- (void)dispose;
- (void)throwIfDisposed;
@end
@implementation AWSCancellationTokenSource
#pragma mark - Initializer
- (instancetype)init {
    self = [super init];
    if (!self) return self;
    _token = [AWSCancellationToken new];
    return self;
}
+ (instancetype)cancellationTokenSource {
    return [AWSCancellationTokenSource new];
}
#pragma mark - Custom Setters/Getters
- (BOOL)isCancellationRequested {
    return _token.isCancellationRequested;
}
- (void)cancel {
    [_token cancel];
}
- (void)cancelAfterDelay:(int)millis {
    [_token cancelAfterDelay:millis];
}
- (void)dispose {
    [_token dispose];
}
@end
NS_ASSUME_NONNULL_END