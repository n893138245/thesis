#import <Foundation/Foundation.h>
#import "AWSNetworking.h"
@interface AWSURLSessionManager : NSObject <NSURLSessionDelegate, NSURLSessionDataDelegate>
@property (nonatomic, strong) AWSNetworkingConfiguration *configuration;
- (instancetype)initWithConfiguration:(AWSNetworkingConfiguration *)configuration;
- (AWSTask *)dataTaskWithRequest:(AWSNetworkingRequest *)request;
@end