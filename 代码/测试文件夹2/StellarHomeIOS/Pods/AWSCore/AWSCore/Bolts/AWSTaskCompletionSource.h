#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN
@class AWSTask<__covariant ResultType>;
@interface AWSTaskCompletionSource<__covariant ResultType> : NSObject
+ (instancetype)taskCompletionSource;
@property (nonatomic, strong, readonly) AWSTask<ResultType> *task;
- (void)setResult:(nullable ResultType)result NS_SWIFT_NAME(set(result:));
- (void)setError:(NSError *)error NS_SWIFT_NAME(set(error:));
- (void)cancel;
- (BOOL)trySetResult:(nullable ResultType)result NS_SWIFT_NAME(trySet(result:));
- (BOOL)trySetError:(NSError *)error NS_SWIFT_NAME(trySet(error:));
- (BOOL)trySetCancelled;
@end
NS_ASSUME_NONNULL_END