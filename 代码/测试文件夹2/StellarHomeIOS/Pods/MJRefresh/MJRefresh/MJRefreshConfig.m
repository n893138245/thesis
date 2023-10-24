#import "MJRefreshConfig.h"
@implementation MJRefreshConfig
static MJRefreshConfig *mj_RefreshConfig = nil;
+ (instancetype)defaultConfig {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mj_RefreshConfig = [[self alloc] init];
    });
    return mj_RefreshConfig;
}
@end