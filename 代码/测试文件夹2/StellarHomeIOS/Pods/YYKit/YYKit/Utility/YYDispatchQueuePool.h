#import <Foundation/Foundation.h>
#ifndef YYDispatchQueuePool_h
#define YYDispatchQueuePool_h
NS_ASSUME_NONNULL_BEGIN
@interface YYDispatchQueuePool : NSObject
- (instancetype)init UNAVAILABLE_ATTRIBUTE;
+ (instancetype)new UNAVAILABLE_ATTRIBUTE;
- (instancetype)initWithName:(nullable NSString *)name queueCount:(NSUInteger)queueCount qos:(NSQualityOfService)qos;
@property (nullable, nonatomic, readonly) NSString *name;
- (dispatch_queue_t)queue;
+ (instancetype)defaultPoolForQOS:(NSQualityOfService)qos;
@end
extern dispatch_queue_t YYDispatchQueueGetForQOS(NSQualityOfService qos);
NS_ASSUME_NONNULL_END
#endif