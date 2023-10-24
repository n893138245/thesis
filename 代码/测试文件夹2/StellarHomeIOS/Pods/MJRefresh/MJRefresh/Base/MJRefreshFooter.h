#import "MJRefreshComponent.h"
NS_ASSUME_NONNULL_BEGIN
@interface MJRefreshFooter : MJRefreshComponent
+ (instancetype)footerWithRefreshingBlock:(MJRefreshComponentRefreshingBlock)refreshingBlock;
+ (instancetype)footerWithRefreshingTarget:(id)target refreshingAction:(SEL)action;
- (void)endRefreshingWithNoMoreData;
- (void)noticeNoMoreData MJRefreshDeprecated("使用endRefreshingWithNoMoreData");
- (void)resetNoMoreData;
@property (assign, nonatomic) CGFloat ignoredScrollViewContentInsetBottom;
@property (assign, nonatomic, getter=isAutomaticallyHidden) BOOL automaticallyHidden MJRefreshDeprecated("已废弃此属性，开发者请自行控制footer的显示和隐藏");
@end
NS_ASSUME_NONNULL_END