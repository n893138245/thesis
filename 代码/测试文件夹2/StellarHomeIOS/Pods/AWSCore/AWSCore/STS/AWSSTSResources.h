#import <Foundation/Foundation.h>
@interface AWSSTSResources : NSObject
+ (instancetype)sharedInstance;
- (NSDictionary *)JSONObject;
@end