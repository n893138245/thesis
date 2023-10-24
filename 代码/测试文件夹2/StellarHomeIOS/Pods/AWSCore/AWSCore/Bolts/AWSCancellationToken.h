#import <Foundation/Foundation.h>
#import "AWSCancellationTokenRegistration.h"
NS_ASSUME_NONNULL_BEGIN
typedef void(^AWSCancellationBlock)(void);
@interface AWSCancellationToken : NSObject
@property (nonatomic, assign, readonly, getter=isCancellationRequested) BOOL cancellationRequested;
- (AWSCancellationTokenRegistration *)registerCancellationObserverWithBlock:(AWSCancellationBlock)block;
@end
NS_ASSUME_NONNULL_END