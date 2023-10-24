#import "MJRefreshBackFooter.h"
NS_ASSUME_NONNULL_BEGIN
@interface MJRefreshBackStateFooter : MJRefreshBackFooter
@property (assign, nonatomic) CGFloat labelLeftInset;
@property (weak, nonatomic, readonly) UILabel *stateLabel;
- (void)setTitle:(NSString *)title forState:(MJRefreshState)state;
- (NSString *)titleForState:(MJRefreshState)state;
@end
NS_ASSUME_NONNULL_END