#import <UIKit/UIKit.h>
#import "MJRefreshConst.h"
#import "UIView+MJExtension.h"
#import "UIScrollView+MJExtension.h"
#import "UIScrollView+MJRefresh.h"
#import "NSBundle+MJRefresh.h"
NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, MJRefreshState) {
    MJRefreshStateIdle = 1,
    MJRefreshStatePulling,
    MJRefreshStateRefreshing,
    MJRefreshStateWillRefresh,
    MJRefreshStateNoMoreData
};
typedef void (^MJRefreshComponentRefreshingBlock)(void);
typedef void (^MJRefreshComponentBeginRefreshingCompletionBlock)(void);
typedef void (^MJRefreshComponentEndRefreshingCompletionBlock)(void);
@interface MJRefreshComponent : UIView
{
    UIEdgeInsets _scrollViewOriginalInset;
    __weak UIScrollView *_scrollView;
}
#pragma mark - 刷新回调
@property (copy, nonatomic, nullable) MJRefreshComponentRefreshingBlock refreshingBlock;
- (void)setRefreshingTarget:(id)target refreshingAction:(SEL)action;
@property (weak, nonatomic) id refreshingTarget;
@property (assign, nonatomic) SEL refreshingAction;
- (void)executeRefreshingCallback;
#pragma mark - 刷新状态控制
- (void)beginRefreshing;
- (void)beginRefreshingWithCompletionBlock:(void (^)(void))completionBlock;
@property (copy, nonatomic, nullable) MJRefreshComponentBeginRefreshingCompletionBlock beginRefreshingCompletionBlock;
@property (copy, nonatomic, nullable) MJRefreshComponentEndRefreshingCompletionBlock endRefreshingAnimateCompletionBlock;
@property (copy, nonatomic, nullable) MJRefreshComponentEndRefreshingCompletionBlock endRefreshingCompletionBlock;
- (void)endRefreshing;
- (void)endRefreshingWithCompletionBlock:(void (^)(void))completionBlock;
@property (assign, nonatomic, readonly, getter=isRefreshing) BOOL refreshing;
@property (assign, nonatomic) MJRefreshState state;
#pragma mark - 交给子类去访问
@property (assign, nonatomic, readonly) UIEdgeInsets scrollViewOriginalInset;
@property (weak, nonatomic, readonly) UIScrollView *scrollView;
#pragma mark - 交给子类们去实现
- (void)prepare NS_REQUIRES_SUPER;
- (void)placeSubviews NS_REQUIRES_SUPER;
- (void)scrollViewContentOffsetDidChange:(nullable NSDictionary *)change NS_REQUIRES_SUPER;
- (void)scrollViewContentSizeDidChange:(nullable NSDictionary *)change NS_REQUIRES_SUPER;
- (void)scrollViewPanStateDidChange:(nullable NSDictionary *)change NS_REQUIRES_SUPER;
#pragma mark - 其他
@property (assign, nonatomic) CGFloat pullingPercent;
@property (assign, nonatomic, getter=isAutoChangeAlpha) BOOL autoChangeAlpha MJRefreshDeprecated("请使用automaticallyChangeAlpha属性");
@property (assign, nonatomic, getter=isAutomaticallyChangeAlpha) BOOL automaticallyChangeAlpha;
@end
@interface UILabel(MJRefresh)
+ (instancetype)mj_label;
- (CGFloat)mj_textWidth;
@end
NS_ASSUME_NONNULL_END