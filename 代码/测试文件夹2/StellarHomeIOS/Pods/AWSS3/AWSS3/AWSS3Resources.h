#import <Foundation/Foundation.h>
@interface AWSS3Resources : NSObject
+ (instancetype)sharedInstance;
- (NSDictionary *)JSONObject;
@end