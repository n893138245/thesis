#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
@interface UIScrollView (YYAdd)
- (void)scrollToTop;
- (void)scrollToBottom;
- (void)scrollToLeft;
- (void)scrollToRight;
- (void)scrollToTopAnimated:(BOOL)animated;
- (void)scrollToBottomAnimated:(BOOL)animated;
- (void)scrollToLeftAnimated:(BOOL)animated;
- (void)scrollToRightAnimated:(BOOL)animated;
@end
NS_ASSUME_NONNULL_END