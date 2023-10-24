#import <Foundation/Foundation.h>
@class SSERestoreScene;
@protocol ISSERestoreSceneDelegate <NSObject>
@optional
- (void)ISSEWillRestoreScene:(SSERestoreScene *)scene error:(NSError *)error;
- (void)ISSEWillAlertCommand:(NSDictionary *)parameters error:(NSError *)error;
- (void)ISSEWillAlertVideoInfo:(NSDictionary *)parameters;
- (void)ISSEWillRestoreScene:(SSERestoreScene *)scene Restore:(void (^)(BOOL isRestore))restoreHandler __deprecated_msg("Discard form v4.3.2");
- (void)ISSECompleteRestoreScene:(SSERestoreScene *)scene __deprecated_msg("Discard form v4.3.2");
- (void)ISSENotFoundScene:(SSERestoreScene *)scene __deprecated_msg("Discard form v4.3.2");
@end