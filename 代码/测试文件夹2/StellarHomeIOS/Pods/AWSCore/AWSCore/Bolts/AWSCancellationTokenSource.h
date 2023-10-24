#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN
@class AWSCancellationToken;
@interface AWSCancellationTokenSource : NSObject
+ (instancetype)cancellationTokenSource;
@property (nonatomic, strong, readonly) AWSCancellationToken *token;
@property (nonatomic, assign, readonly, getter=isCancellationRequested) BOOL cancellationRequested;
- (void)cancel;
- (void)cancelAfterDelay:(int)millis;
- (void)dispose;
@end
NS_ASSUME_NONNULL_END