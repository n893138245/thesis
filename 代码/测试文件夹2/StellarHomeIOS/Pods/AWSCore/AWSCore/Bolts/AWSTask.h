#import <Foundation/Foundation.h>
#import "AWSCancellationToken.h"
#import "AWSGeneric.h"
NS_ASSUME_NONNULL_BEGIN
extern NSString *const AWSTaskErrorDomain;
extern NSInteger const kAWSMultipleErrorsError;
extern NSString *const AWSTaskMultipleErrorsUserInfoKey;
@class AWSExecutor;
@class AWSTask;
@interface AWSTask<__covariant ResultType> : NSObject
typedef __nullable id(^AWSContinuationBlock)(AWSTask<ResultType> *t);
+ (instancetype)taskWithResult:(nullable ResultType)result;
+ (instancetype)taskWithError:(NSError *)error;
+ (instancetype)cancelledTask;
+ (instancetype)taskForCompletionOfAllTasks:(nullable NSArray<AWSTask *> *)tasks;
+ (instancetype)taskForCompletionOfAllTasksWithResults:(nullable NSArray<AWSTask *> *)tasks;
+ (instancetype)taskForCompletionOfAnyTask:(nullable NSArray<AWSTask *> *)tasks;
+ (AWSTask<AWSVoid> *)taskWithDelay:(int)millis;
+ (AWSTask<AWSVoid> *)taskWithDelay:(int)millis cancellationToken:(nullable AWSCancellationToken *)token;
+ (instancetype)taskFromExecutor:(AWSExecutor *)executor withBlock:(nullable id (^)(void))block;
@property (nullable, nonatomic, strong, readonly) ResultType result;
@property (nullable, nonatomic, strong, readonly) NSError *error;
@property (nonatomic, assign, readonly, getter=isCancelled) BOOL cancelled;
@property (nonatomic, assign, readonly, getter=isFaulted) BOOL faulted;
@property (nonatomic, assign, readonly, getter=isCompleted) BOOL completed;
- (AWSTask *)continueWithBlock:(AWSContinuationBlock)block NS_SWIFT_NAME(continueWith(block:));
- (AWSTask *)continueWithBlock:(AWSContinuationBlock)block
            cancellationToken:(nullable AWSCancellationToken *)cancellationToken NS_SWIFT_NAME(continueWith(block:cancellationToken:));
- (AWSTask *)continueWithExecutor:(AWSExecutor *)executor
                       withBlock:(AWSContinuationBlock)block NS_SWIFT_NAME(continueWith(executor:block:));
- (AWSTask *)continueWithExecutor:(AWSExecutor *)executor
                           block:(AWSContinuationBlock)block
               cancellationToken:(nullable AWSCancellationToken *)cancellationToken
NS_SWIFT_NAME(continueWith(executor:block:cancellationToken:));
- (AWSTask *)continueWithSuccessBlock:(AWSContinuationBlock)block NS_SWIFT_NAME(continueOnSuccessWith(block:));
- (AWSTask *)continueWithSuccessBlock:(AWSContinuationBlock)block
                   cancellationToken:(nullable AWSCancellationToken *)cancellationToken
NS_SWIFT_NAME(continueOnSuccessWith(block:cancellationToken:));
- (AWSTask *)continueWithExecutor:(AWSExecutor *)executor
                withSuccessBlock:(AWSContinuationBlock)block NS_SWIFT_NAME(continueOnSuccessWith(executor:block:));
- (AWSTask *)continueWithExecutor:(AWSExecutor *)executor
                    successBlock:(AWSContinuationBlock)block
               cancellationToken:(nullable AWSCancellationToken *)cancellationToken
NS_SWIFT_NAME(continueOnSuccessWith(executor:block:cancellationToken:));
- (void)waitUntilFinished;
@end
NS_ASSUME_NONNULL_END