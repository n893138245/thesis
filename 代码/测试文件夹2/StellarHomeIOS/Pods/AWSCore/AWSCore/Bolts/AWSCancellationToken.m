#import "AWSCancellationToken.h"
#import "AWSCancellationTokenRegistration.h"
NS_ASSUME_NONNULL_BEGIN
@interface AWSCancellationToken ()
@property (nullable, nonatomic, strong) NSMutableArray *registrations;
@property (nonatomic, strong) NSObject *lock;
@property (nonatomic) BOOL disposed;
@end
@interface AWSCancellationTokenRegistration (AWSCancellationToken)
+ (instancetype)registrationWithToken:(AWSCancellationToken *)token delegate:(AWSCancellationBlock)delegate;
- (void)notifyDelegate;
@end
@implementation AWSCancellationToken
@synthesize cancellationRequested = _cancellationRequested;
#pragma mark - Initializer
- (instancetype)init {
    self = [super init];
    if (!self) return self;
    _registrations = [NSMutableArray array];
    _lock = [NSObject new];
    return self;
}
#pragma mark - Custom Setters/Getters
- (BOOL)isCancellationRequested {
    @synchronized(self.lock) {
        [self throwIfDisposed];
        return _cancellationRequested;
    }
}
- (void)cancel {
    NSArray *registrations;
    @synchronized(self.lock) {
        [self throwIfDisposed];
        if (_cancellationRequested) {
            return;
        }
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(cancelPrivate) object:nil];
        _cancellationRequested = YES;
        registrations = [self.registrations copy];
    }
    [self notifyCancellation:registrations];
}
- (void)notifyCancellation:(NSArray *)registrations {
    for (AWSCancellationTokenRegistration *registration in registrations) {
        [registration notifyDelegate];
    }
}
- (AWSCancellationTokenRegistration *)registerCancellationObserverWithBlock:(AWSCancellationBlock)block {
    @synchronized(self.lock) {
        AWSCancellationTokenRegistration *registration = [AWSCancellationTokenRegistration registrationWithToken:self delegate:[block copy]];
        [self.registrations addObject:registration];
        return registration;
    }
}
- (void)unregisterRegistration:(AWSCancellationTokenRegistration *)registration {
    @synchronized(self.lock) {
        [self throwIfDisposed];
        [self.registrations removeObject:registration];
    }
}
- (void)cancelPrivate {
    [self cancel];
}
- (void)cancelAfterDelay:(int)millis {
    [self throwIfDisposed];
    if (millis < -1) {
        [NSException raise:NSInvalidArgumentException format:@"Delay must be >= -1"];
    }
    if (millis == 0) {
        [self cancel];
        return;
    }
    @synchronized(self.lock) {
        [self throwIfDisposed];
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(cancelPrivate) object:nil];
        if (self.cancellationRequested) {
            return;
        }
        if (millis != -1) {
            double delay = (double)millis / 1000;
            [self performSelector:@selector(cancelPrivate) withObject:nil afterDelay:delay];
        }
    }
}
- (void)dispose {
    @synchronized(self.lock) {
        if (self.disposed) {
            return;
        }
        [self.registrations makeObjectsPerformSelector:@selector(dispose)];
        self.registrations = nil;
        self.disposed = YES;
    }
}
- (void)throwIfDisposed {
    if (self.disposed) {
        [NSException raise:NSInternalInconsistencyException format:@"Object already disposed"];
    }
}
@end
NS_ASSUME_NONNULL_END