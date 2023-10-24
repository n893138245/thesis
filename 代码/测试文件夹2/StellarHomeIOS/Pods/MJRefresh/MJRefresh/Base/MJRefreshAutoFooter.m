#import "MJRefreshAutoFooter.h"
@interface MJRefreshAutoFooter()
@property (nonatomic) BOOL triggerByDrag;
@property (nonatomic) NSInteger leftTriggerTimes;
@end
@implementation MJRefreshAutoFooter
#pragma mark - 初始化
- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    if (newSuperview) { 
        if (self.hidden == NO) {
            self.scrollView.mj_insetB += self.mj_h;
        }
        self.mj_y = _scrollView.mj_contentH;
    } else { 
        if (self.hidden == NO) {
            self.scrollView.mj_insetB -= self.mj_h;
        }
    }
}
#pragma mark - 过期方法
- (void)setAppearencePercentTriggerAutoRefresh:(CGFloat)appearencePercentTriggerAutoRefresh
{
    self.triggerAutomaticallyRefreshPercent = appearencePercentTriggerAutoRefresh;
}
- (CGFloat)appearencePercentTriggerAutoRefresh
{
    return self.triggerAutomaticallyRefreshPercent;
}
#pragma mark - 实现父类的方法
- (void)prepare
{
    [super prepare];
    self.triggerAutomaticallyRefreshPercent = 1.0;
    self.automaticallyRefresh = YES;
    self.autoTriggerTimes = 1;
}
- (void)scrollViewContentSizeDidChange:(NSDictionary *)change
{
    [super scrollViewContentSizeDidChange:change];
    self.mj_y = self.scrollView.mj_contentH + self.ignoredScrollViewContentInsetBottom;
}
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    [super scrollViewContentOffsetDidChange:change];
    if (self.state != MJRefreshStateIdle || !self.automaticallyRefresh || self.mj_y == 0) return;
    if (_scrollView.mj_insetT + _scrollView.mj_contentH > _scrollView.mj_h) { 
        if (_scrollView.mj_offsetY >= _scrollView.mj_contentH - _scrollView.mj_h + self.mj_h * self.triggerAutomaticallyRefreshPercent + _scrollView.mj_insetB - self.mj_h) {
            CGPoint old = [change[@"old"] CGPointValue];
            CGPoint new = [change[@"new"] CGPointValue];
            if (new.y <= old.y) return;
            if (_scrollView.isDragging) {
                self.triggerByDrag = YES;
            }
            [self beginRefreshing];
        }
    }
}
- (void)scrollViewPanStateDidChange:(NSDictionary *)change
{
    [super scrollViewPanStateDidChange:change];
    if (self.state != MJRefreshStateIdle) return;
    UIGestureRecognizerState panState = _scrollView.panGestureRecognizer.state;
    switch (panState) {
        case UIGestureRecognizerStateEnded: {
            if (_scrollView.mj_insetT + _scrollView.mj_contentH <= _scrollView.mj_h) {  
                if (_scrollView.mj_offsetY >= - _scrollView.mj_insetT) { 
                    self.triggerByDrag = YES;
                    [self beginRefreshing];
                }
            } else { 
                if (_scrollView.mj_offsetY >= _scrollView.mj_contentH + _scrollView.mj_insetB - _scrollView.mj_h) {
                    self.triggerByDrag = YES;
                    [self beginRefreshing];
                }
            }
        }
            break;
        case UIGestureRecognizerStateBegan: {
            [self resetTriggerTimes];
        }
            break;
        default:
            break;
    }
}
- (BOOL)unlimitedTrigger {
    return self.leftTriggerTimes == -1;
}
- (void)beginRefreshing
{
    if (self.triggerByDrag && self.leftTriggerTimes <= 0 && !self.unlimitedTrigger) {
        return;
    }
    [super beginRefreshing];
}
- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState
    if (state == MJRefreshStateRefreshing) {
        [self executeRefreshingCallback];
    } else if (state == MJRefreshStateNoMoreData || state == MJRefreshStateIdle) {
        if (self.triggerByDrag) {
            if (!self.unlimitedTrigger) {
                self.leftTriggerTimes -= 1;
            }
            self.triggerByDrag = NO;
        }
        if (MJRefreshStateRefreshing == oldState) {
            if (self.endRefreshingCompletionBlock) {
                self.endRefreshingCompletionBlock();
            }
        }
    }
}
- (void)resetTriggerTimes {
    self.leftTriggerTimes = self.autoTriggerTimes;
}
- (void)setHidden:(BOOL)hidden
{
    BOOL lastHidden = self.isHidden;
    [super setHidden:hidden];
    if (!lastHidden && hidden) {
        self.state = MJRefreshStateIdle;
        self.scrollView.mj_insetB -= self.mj_h;
    } else if (lastHidden && !hidden) {
        self.scrollView.mj_insetB += self.mj_h;
        self.mj_y = _scrollView.mj_contentH;
    }
}
- (void)setAutoTriggerTimes:(NSInteger)autoTriggerTimes {
    _autoTriggerTimes = autoTriggerTimes;
    self.leftTriggerTimes = autoTriggerTimes;
}
@end