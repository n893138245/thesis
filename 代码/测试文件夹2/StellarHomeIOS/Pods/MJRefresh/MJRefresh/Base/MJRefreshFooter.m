#import "MJRefreshFooter.h"
#include "UIScrollView+MJRefresh.h"
@interface MJRefreshFooter()
@end
@implementation MJRefreshFooter
#pragma mark - 构造方法
+ (instancetype)footerWithRefreshingBlock:(MJRefreshComponentRefreshingBlock)refreshingBlock
{
    MJRefreshFooter *cmp = [[self alloc] init];
    cmp.refreshingBlock = refreshingBlock;
    return cmp;
}
+ (instancetype)footerWithRefreshingTarget:(id)target refreshingAction:(SEL)action
{
    MJRefreshFooter *cmp = [[self alloc] init];
    [cmp setRefreshingTarget:target refreshingAction:action];
    return cmp;
}
#pragma mark - 重写父类的方法
- (void)prepare
{
    [super prepare];
    self.mj_h = MJRefreshFooterHeight;
}
#pragma mark - 公共方法
- (void)endRefreshingWithNoMoreData
{
    MJRefreshDispatchAsyncOnMainQueue(self.state = MJRefreshStateNoMoreData;)
}
- (void)noticeNoMoreData
{
    [self endRefreshingWithNoMoreData];
}
- (void)resetNoMoreData
{
    MJRefreshDispatchAsyncOnMainQueue(self.state = MJRefreshStateIdle;)
}
- (void)setAutomaticallyHidden:(BOOL)automaticallyHidden
{
    _automaticallyHidden = automaticallyHidden;
}
@end