#import <Foundation/Foundation.h>
#import "UTTracker.h"
#import "UTIRequestAuthentication.h"
#import "UTICrashCaughtListener.h"
@interface UTAnalytics : NSObject
+ (void) turnOnDev2;
+(UTAnalytics *) getInstance;
- (void)setAppKey:(NSString *)appKey secret:(NSString *)secret;
- (void)setAppKey4APP:(NSString *)appKey authcode:(NSString *)authcode;
- (void)setAppKey4SDK:(NSString *)appKey secret:(NSString *)secret;
- (void)setAppKey4SDK:(NSString *)appKey authcode:(NSString *)authcode;
+ (void)setDailyEnvironment  __deprecated;
-(void) setAppVersion:(NSString *) pAppVersion;
-(void) setChannel:(NSString *) pChannel;
-(void) updateUserAccount:(NSString *) pNick userid:(NSString *) pUserId;
-(void) userRegister:(NSString *) pUsernick;
-(void) updateSessionProperties:(NSDictionary *) pDict;
-(UTTracker *) getDefaultTracker;
-(UTTracker *) getTracker:(NSString *)  pTrackId;
-(UTTracker *) getTracker4SDK:(NSString *) pAppkey;
-(void) turnOnDebug;
-(void) turnOnDev;
-(void) setRequestAuthentication:(id<UTIRequestAuthentication>) pRequestAuth __deprecated;
- (void)onCrashHandler;
-(void) turnOffCrashHandler;
-(void) setCrashCaughtListener:(id<UTICrashCaughtListener>) aListener;
@end