#import "AWSNetworkingHelpers.h"
@implementation AWSNetworkingHelpers
+ (NSArray<NSURLQueryItem *> *)queryItemsFromDictionary:(NSDictionary<NSString *, id> *)requestParameters {
    NSMutableArray<NSURLQueryItem *> *queryItems = [[NSMutableArray alloc] init];
    for (NSString *key in requestParameters) {
        if ([requestParameters[key] isKindOfClass:[NSArray class]]) {
            NSArray<NSString *> *parameterValues = requestParameters[key];
            for (NSString *paramValue in parameterValues) {
                NSURLQueryItem *queryItem = [NSURLQueryItem queryItemWithName:key value:paramValue];
                [queryItems addObject:queryItem];
            }
        } else if ([requestParameters[key] isKindOfClass:[NSString class]]) {
            NSString *value = requestParameters[key];
            NSURLQueryItem *queryItem = [NSURLQueryItem queryItemWithName:key value:value];
            [queryItems addObject:queryItem];
        } else {
            @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                           reason:@"Invalid requestParameters dictionary. Supported Dictionaries include [NSString: NSString] and [NSString: NSArray<NSString>]"
                                         userInfo:nil];
        }
    }
    return queryItems;
}
@end