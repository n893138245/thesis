#import "AWSS3RequestRetryHandler.h"
#import <AWSCore/AWSService.h>
@implementation AWSS3RequestRetryHandler
- (AWSNetworkingRetryType)shouldRetry:(uint32_t)currentRetryCount
                      originalRequest:(AWSNetworkingRequest *)originalRequest
                             response:(NSHTTPURLResponse *)response
                                 data:(NSData *)data
                                error:(NSError *)error {
    AWSNetworkingRetryType retryType = [super shouldRetry:currentRetryCount
                                          originalRequest:(AWSNetworkingRequest *)originalRequest
                                                 response:response
                                                     data:data
                                                    error:error];
    if(retryType == AWSNetworkingRetryTypeShouldNotRetry
       && currentRetryCount < self.maxRetryCount) {
        if (response.statusCode == 200
            && error
            && error.code != NSURLErrorCancelled) {
            retryType = AWSNetworkingRetryTypeShouldRetry;
        }
    }
    if (currentRetryCount < self.maxRetryCount
        && [error.domain isEqualToString:AWSServiceErrorDomain]) {
        switch (error.code) {
            case AWSServiceErrorSignatureDoesNotMatch:
                retryType = AWSNetworkingRetryTypeShouldRetry;
                break;
            default:
                break;
        }
    }
    return retryType;
}
@end