#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN
@interface AWSNetworkingHelpers : NSObject
+ (NSArray<NSURLQueryItem *> * _Nonnull)queryItemsFromDictionary:(NSDictionary<NSString *, id> * _Nonnull)requestParameters;
@end
NS_ASSUME_NONNULL_END