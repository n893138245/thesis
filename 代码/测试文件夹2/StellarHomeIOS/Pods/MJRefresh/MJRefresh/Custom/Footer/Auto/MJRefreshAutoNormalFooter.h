#import "MJRefreshAutoStateFooter.h"
NS_ASSUME_NONNULL_BEGIN
@interface MJRefreshAutoNormalFooter : MJRefreshAutoStateFooter
@property (weak, nonatomic, readonly) UIActivityIndicatorView *loadingView;
@property (assign, nonatomic) UIActivityIndicatorViewStyle activityIndicatorViewStyle __attribute__((deprecated("first deprecated in 3.2.2 - Use `loadingView` property")));
@end
NS_ASSUME_NONNULL_END