#import <Foundation/Foundation.h>
#import "AWSNetworking.h"
@interface AWSURLRequestRetryHandler : NSObject <AWSURLRequestRetryHandler>
@property (nonatomic, assign) uint32_t maxRetryCount;
- (instancetype)initWithMaximumRetryCount:(uint32_t)maxRetryCount;
@end