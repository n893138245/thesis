#import <UIKit/UIKit.h>
#if __has_include(<YYKit/YYKit.h>)
#import <YYKit/YYTextMagnifier.h>
#import <YYKit/YYTextSelectionView.h>
#else
#import "YYTextMagnifier.h"
#import "YYTextSelectionView.h"
#endif
NS_ASSUME_NONNULL_BEGIN
@interface YYTextEffectWindow : UIWindow
+ (nullable instancetype)sharedWindow;
- (void)showMagnifier:(YYTextMagnifier *)mag;
- (void)moveMagnifier:(YYTextMagnifier *)mag;
- (void)hideMagnifier:(YYTextMagnifier *)mag;
- (void)showSelectionDot:(YYTextSelectionView *)selection;
- (void)hideSelectionDot:(YYTextSelectionView *)selection;
@end
NS_ASSUME_NONNULL_END