#import "MJRefreshComponent.h"
NS_ASSUME_NONNULL_BEGIN
@interface MJRefreshHeader : MJRefreshComponent
+ (instancetype)headerWithRefreshingBlock:(MJRefreshComponentRefreshingBlock)refreshingBlock;
+ (instancetype)headerWithRefreshingTarget:(id)target refreshingAction:(SEL)action;
@property (copy, nonatomic) NSString *lastUpdatedTimeKey;
@property (strong, nonatomic, readonly, nullable) NSDate *lastUpdatedTime;
@property (assign, nonatomic) CGFloat ignoredScrollViewContentInsetTop;
@end
NS_ASSUME_NONNULL_END