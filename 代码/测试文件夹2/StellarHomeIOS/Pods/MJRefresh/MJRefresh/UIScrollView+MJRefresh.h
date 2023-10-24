#import <UIKit/UIKit.h>
#import "MJRefreshConst.h"
@class MJRefreshHeader, MJRefreshFooter;
NS_ASSUME_NONNULL_BEGIN
@interface UIScrollView (MJRefresh)
@property (strong, nonatomic, nullable) MJRefreshHeader *mj_header;
@property (strong, nonatomic, nullable) MJRefreshHeader *header MJRefreshDeprecated("使用mj_header");
@property (strong, nonatomic, nullable) MJRefreshFooter *mj_footer;
@property (strong, nonatomic, nullable) MJRefreshFooter *footer MJRefreshDeprecated("使用mj_footer");
#pragma mark - other
- (NSInteger)mj_totalDataCount;
@end
NS_ASSUME_NONNULL_END