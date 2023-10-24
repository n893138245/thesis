#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
@interface UIBezierPath (YYAdd)
+ (nullable UIBezierPath *)bezierPathWithText:(NSString *)text font:(UIFont *)font;
@end
NS_ASSUME_NONNULL_END