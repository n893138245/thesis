#import "AWSCancellationTokenRegistration.h"
#import "AWSCancellationToken.h"
NS_ASSUME_NONNULL_BEGIN
@interface AWSCancellationTokenRegistration ()
@property (nonatomic, weak) AWSCancellationToken *token;
@property (nullable, nonatomic, strong) AWSCancellationBlock cancellationObserverBlock;
@property (nonatomic, strong) NSObject *lock;
@property (nonatomic) BOOL disposed;
@end
@interface AWSCancellationToken (AWSCancellationTokenRegistration)
- (void)unregisterRegistration:(AWSCancellationTokenRegistration *)registration;
@end
@implementation AWSCancellationTokenRegistration
+ (instancetype)registrationWithToken:(AWSCancellationToken *)token delegate:(AWSCancellationBlock)delegate {
    AWSCancellationTokenRegistration *registration = [AWSCancellationTokenRegistration new];
    registration.token = token;
    registration.cancellationObserverBlock = delegate;
    return registration;
}
- (instancetype)init {
    self = [super init];
    if (!self) return self;
    _lock = [NSObject new];
    return self;
}
- (void)dispose {
    @synchronized(self.lock) {
        if (self.disposed) {
            return;
        }
        self.disposed = YES;
    }
    AWSCancellationToken *token = self.token;
    if (token != nil) {
        [token unregisterRegistration:self];
        self.token = nil;
    }
    self.cancellationObserverBlock = nil;
}
- (void)notifyDelegate {
    @synchronized(self.lock) {
        [self throwIfDisposed];
        self.cancellationObserverBlock();
    }
}
- (void)throwIfDisposed {
    NSAssert(!self.disposed, @"Object already disposed");
}
@end
NS_ASSUME_NONNULL_END