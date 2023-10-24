#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
@interface SSDKDataModel : NSObject<NSCoding>
- (instancetype)initWithDict:(NSDictionary *)dict;
- (NSDictionary *)dictionaryValue;
@end
NS_ASSUME_NONNULL_END