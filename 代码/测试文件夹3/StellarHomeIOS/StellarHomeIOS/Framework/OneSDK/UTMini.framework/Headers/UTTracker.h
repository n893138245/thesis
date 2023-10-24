#import <Foundation/Foundation.h>
@class UTDSDKInfo;
typedef enum _UTPageStatus{
    UT_H5_IN_WebView
} UTPageStatus;
@interface UTTracker : NSObject
@property (readonly,copy) UTDSDKInfo * mSdkinfo;
-(id) initWithTrackId:(NSString *) pTrackId __deprecated;
-(id) initWithAppKey:(NSString *) pAppkey
           appsecret:(NSString *) pAppSecret
            authcode:(NSString *) pAuthCode
        securitySign:(BOOL) securitySign;
-(id) initWithTracker:(UTTracker *) pTracker trackid:(NSString *) pTrackId;
-(NSString *) getAppKey;
-(void) setGlobalProperty:(NSString *) pKey value:(NSString *) pValue;
-(void) removeGlobalProperty:(NSString *) pKey;
-(NSString *) getGlobalProperty:(NSString *) pKey;
-(void) send:(NSDictionary *) pLogDict;
#pragma mark 页面埋点
-(void) pageAppear:(id) pPageObject;
-(void) pageAppear:(id) pPageObject withPageName:(NSString *) pPageName;
-(void) pageDisAppear:(id) pPageObject;
-(void) updatePageProperties:(id) pPageObject properties:(NSDictionary *) pProperties;
-(void) updateNextPageProperties:(NSDictionary *) pProperties;
#pragma  mark 页面埋点的辅助函数
-(void) updatePageName:(id) pPageObject pageName:(NSString *) pPageName;
-(void) updatePageUrl:(id) pPageObject url:(NSURL *) pUrl;
-(void) updatePageStatus:(id) pPageObject status:(UTPageStatus) aStatus;
-(void) skipPage:(id) pPageObject;
- (void) ctrlClicked:(NSString *)controlName onPage:(NSObject *) pageName args:(NSDictionary *) dict;
@end