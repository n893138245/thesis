#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
@interface UIBarButtonItem (YYAdd)
@property (nullable, nonatomic, copy) void (^actionBlock)(id);
@end
NS_ASSUME_NONNULL_END