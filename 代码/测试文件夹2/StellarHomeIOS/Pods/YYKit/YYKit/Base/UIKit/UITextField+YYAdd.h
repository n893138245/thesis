#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
@interface UITextField (YYAdd)
- (void)selectAllText;
- (void)setSelectedRange:(NSRange)range;
@end
NS_ASSUME_NONNULL_END