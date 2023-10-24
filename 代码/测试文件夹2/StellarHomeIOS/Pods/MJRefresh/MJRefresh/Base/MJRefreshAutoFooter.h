#import "MJRefreshFooter.h"
NS_ASSUME_NONNULL_BEGIN
@interface MJRefreshAutoFooter : MJRefreshFooter
@property (assign, nonatomic, getter=isAutomaticallyRefresh) BOOL automaticallyRefresh;
@property (assign, nonatomic) CGFloat appearencePercentTriggerAutoRefresh MJRefreshDeprecated("请使用triggerAutomaticallyRefreshPercent属性");
@property (assign, nonatomic) CGFloat triggerAutomaticallyRefreshPercent;
@property (nonatomic) NSInteger autoTriggerTimes;
@end
NS_ASSUME_NONNULL_END