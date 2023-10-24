#import "MJRefreshStateHeader.h"
NS_ASSUME_NONNULL_BEGIN
@interface MJRefreshNormalHeader : MJRefreshStateHeader
@property (weak, nonatomic, readonly) UIImageView *arrowView;
@property (weak, nonatomic, readonly) UIActivityIndicatorView *loadingView;
@property (assign, nonatomic) UIActivityIndicatorViewStyle activityIndicatorViewStyle __attribute__((deprecated("first deprecated in 3.2.2 - Use `loadingView` property")));
@end
NS_ASSUME_NONNULL_END