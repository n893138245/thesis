#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_4_0
#import <UIKit/UIKit.h>
#else
typedef NSUInteger UIBackgroundTaskIdentifier;
#endif
@protocol AWSTMCacheBackgroundTaskManager <NSObject>
- (UIBackgroundTaskIdentifier)beginBackgroundTask;
- (void)endBackgroundTask:(UIBackgroundTaskIdentifier)identifier;
@end