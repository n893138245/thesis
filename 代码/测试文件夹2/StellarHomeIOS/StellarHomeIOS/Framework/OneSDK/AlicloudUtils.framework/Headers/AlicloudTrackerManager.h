#ifndef AlicloudTrackerManager_h
#define AlicloudTrackerManager_h
#import "AlicloudTracker.h"
@interface AlicloudTrackerManager : NSObject
+ (instancetype)getInstance;
- (AlicloudTracker *)getTrackerBySdkId:(NSString *)sdkId version:(NSString *)version;
@end
#endif 