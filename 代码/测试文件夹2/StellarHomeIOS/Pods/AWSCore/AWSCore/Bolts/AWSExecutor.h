#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN
@interface AWSExecutor : NSObject
+ (instancetype)defaultExecutor;
+ (instancetype)immediateExecutor;
+ (instancetype)mainThreadExecutor;
+ (instancetype)executorWithBlock:(void(^)(void(^block)(void)))block;
+ (instancetype)executorWithDispatchQueue:(dispatch_queue_t)queue;
+ (instancetype)executorWithOperationQueue:(NSOperationQueue *)queue;
- (void)execute:(void(^)(void))block;
@end
NS_ASSUME_NONNULL_END