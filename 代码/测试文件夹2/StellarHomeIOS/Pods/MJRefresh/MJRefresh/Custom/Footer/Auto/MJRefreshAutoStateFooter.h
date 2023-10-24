#import "MJRefreshAutoFooter.h"
NS_ASSUME_NONNULL_BEGIN
@interface MJRefreshAutoStateFooter : MJRefreshAutoFooter
@property (assign, nonatomic) CGFloat labelLeftInset;
@property (weak, nonatomic, readonly) UILabel *stateLabel;
- (void)setTitle:(NSString *)title forState:(MJRefreshState)state;
@property (assign, nonatomic, getter=isRefreshingTitleHidden) BOOL refreshingTitleHidden;
@end
NS_ASSUME_NONNULL_END