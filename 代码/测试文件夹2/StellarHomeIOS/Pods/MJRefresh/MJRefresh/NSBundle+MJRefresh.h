#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
@interface NSBundle (MJRefresh)
+ (instancetype)mj_refreshBundle;
+ (UIImage *)mj_arrowImage;
+ (NSString *)mj_localizedStringForKey:(NSString *)key value:(nullable NSString *)value;
+ (NSString *)mj_localizedStringForKey:(NSString *)key;
@end
NS_ASSUME_NONNULL_END