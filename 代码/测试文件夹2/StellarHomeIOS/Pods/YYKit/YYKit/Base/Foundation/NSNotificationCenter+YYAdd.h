#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN
@interface NSNotificationCenter (YYAdd)
- (void)postNotificationOnMainThread:(NSNotification *)notification;
- (void)postNotificationOnMainThread:(NSNotification *)notification
                       waitUntilDone:(BOOL)wait;
- (void)postNotificationOnMainThreadWithName:(NSString *)name
                                      object:(nullable id)object;
- (void)postNotificationOnMainThreadWithName:(NSString *)name
                                      object:(nullable id)object
                                    userInfo:(nullable NSDictionary *)userInfo;
- (void)postNotificationOnMainThreadWithName:(NSString *)name
                                      object:(nullable id)object
                                    userInfo:(nullable NSDictionary *)userInfo
                               waitUntilDone:(BOOL)wait;
@end
NS_ASSUME_NONNULL_END