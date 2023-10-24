#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN
@interface MJRefreshConfig : NSObject
@property (copy, nonatomic, nullable) NSString *languageCode;
+ (instancetype)defaultConfig;
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
@end
NS_ASSUME_NONNULL_END