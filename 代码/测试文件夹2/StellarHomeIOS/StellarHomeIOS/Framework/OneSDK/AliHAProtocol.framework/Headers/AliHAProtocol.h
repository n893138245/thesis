#ifndef AliHAProtocol_h
#define AliHAProtocol_h
#import <Foundation/Foundation.h>
#import "AliHADefine.h"
#import "RemoteDebugProtocol.h"
#define NOW_TIME_STAMP [[NSDate date] timeIntervalSince1970] * 1000
extern const uint16_t kTraceTypeStartupBegin;
extern const uint16_t kTraceTypeForeground;
extern const uint16_t kTraceTypeBackground;
extern const uint16_t kTraceTypeBecomeActive;
extern const uint16_t kTraceTypeResignActive;
extern const uint16_t kTraceTypeMemoryWarning;
extern const uint16_t kTraceTypeAppTerminate;
extern const uint16_t kTraceTypeApplicationOpenFromUrl;
extern const uint16_t kTraceTypeVCViewDidLoad;
extern const uint16_t kTraceTypeVCViewWillAppear;
extern const uint16_t kTraceTypeVCViewDidAppear;
extern const uint16_t kTraceTypeVCViewWillDisappear;
extern const uint16_t kTraceTypeVCViewDidDisappear;
extern const uint16_t kTraceTypeVCViewDidLayoutSubviews;
extern const uint16_t kTraceTypePageRenderFinished;
extern const uint16_t kTraceTypeMainThreadHeartbeat;
extern const uint16_t kTraceTypeTapEvent;
extern const uint16_t kTraceTypeSwipeEvent;
extern const uint16_t kTraceTypeStartupEnd;
extern const uint16_t kTraceTypeOpenPage;
extern const uint16_t kTraceTypeOpenPageEnd;
extern const uint16_t kTraceTypeMemoryUsage;
extern const uint16_t kTraceTypeCPUUsage;
extern const uint16_t kTraceTypeFPS;
extern const uint16_t kTraceTypeLoadWebView;
extern const uint16_t kTraceTypeBigMalloc;
extern const uint16_t kTraceTypeMemoryLeakRetainCycle;
extern const uint16_t kTraceTypeMemoryLeakAliveObject;
extern const uint16_t kTraceTypeJankEvent;
extern const uint16_t kTraceTypeCrashEvent;
extern const uint16_t kTraceTypeRuntimeTaskBegin;
extern const uint16_t kTraceTypeRuntimeTaskEnd;
extern const uint16_t kTraceTypeCustomEvent;
#pragma logger protocol
@protocol AliHALoggerProtocol <NSObject>
- (void)append:(uint16_t)type time:(uint64_t)time;
- (void)append:(uint16_t)type time:(uint64_t)time params:(float[]) params paramSize:(uint16_t)paramSize;
- (void)append:(uint16_t)type time:(uint64_t)time data:(NSString *)data;
- (void)append:(uint16_t)type time:(uint64_t)time data:(NSString *)data params:(float[])params paramSize:(uint16_t)paramSize;
- (void)append:(uint16_t)type time:(uint64_t)time data:(NSString *)data desc:(NSString *)desc;
- (void)append:(uint16_t)type time:(uint64_t)time data:(NSString *)data desc:(NSString *)desc params:(float[])params paramSize:(uint16_t)paramSize;
@end
#pragma config protocol
@protocol AliHAConfigProtocol <NSObject>
- (NSDictionary *)getConfigs;
@end
#pragma app lifecycle call back protocol
@protocol AliHAAppLifeProtocol <NSObject>
@required
- (void)onApplicationEnterForeground;
- (void)onApplicationEnterBackground;
- (void)onApplicationBecomeActive;
- (void)onApplicationResignActive;
@optional
- (void)onApplicationOpenFromURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication;
- (void)onReceiveMemoryWarning;
- (void)onApplicationTerminate;
@end
typedef NS_ENUM(NSInteger, PageChangeType) {
    PageChangeTypePush = 0,
    PageChangeTypePop,
    PageChangeTypeTab,
};
#pragma HA vc lifecycle protocol
@protocol AliHAVCLifeProtocol <NSObject>
@required
- (void)onPageChange:(PageChangeType)pageChangeType
              fromVC:(UIViewController*)fromVC
                toVC:(UIViewController*)toVC
                args:(NSDictionary*)args;
- (void)onViewDidAppear:(BOOL)animated viewController:(UIViewController*)viewController;
- (void)onViewDidLayoutSubviews:(UIViewController*)viewController;
- (void)onViewDidDisappear:(BOOL)animated viewController:(UIViewController*)viewController;
@optional
- (void)onViewDidLoad:(UIViewController *)viewController;
- (void)onViewWillExit:(UIViewController*)viewController;
- (void)onViewWillAppear:(BOOL)animated viewController:(UIViewController*)viewController;
- (void)onViewWillDisappear:(BOOL)animated viewController:(UIViewController*)viewController;
- (void)onNavigationDidEndTransitionFromView:(UIView*)view toView:(UIView*)toView;
- (void)onUIViewLayoutSubviews;
@end
@protocol AliHAUserEventProtocol <NSObject>
- (void)onUserEvent;
- (void)onUserTap;
- (void)onUserSwipe;
@end
#pragma AliHA runtime task protocol
@protocol AliHARuntimeTaskProtocol <NSObject>
- (void)onTaskBegin:(NSString *)taskName thread:(NSString *)thread;
- (void)onTaskEnd:(NSString *)taskName;
@end
#pragma HA util protocol
@protocol AliHAPageResolverProtocol <NSObject>
- (NSString*)getRealPageNameByVC:(UIViewController*)toVC;
- (NSDictionary*)getPageParamsByVC:(UIViewController *)toVC;
- (BOOL)isVaildViewController:(UIViewController*)viewController;
- (UIViewController*)getRealUIViewController:(UIViewController*)viewController;
@end
#pragma HA context protocol
@protocol AliHAContextProtocol <NSObject>
- (void)registerAppLifeListener:(id<AliHAAppLifeProtocol>)listener;
- (void)registerVCLifeListener:(id<AliHAVCLifeProtocol>)listener;
- (void)registerUserEventListener:(id<AliHAUserEventProtocol>)listener;
- (void)registerCustomizedTaskListener:(id<AliHARuntimeTaskProtocol>)listener;
- (id<AliHAConfigProtocol>)getConfigDelegate;
- (id<AliHALoggerProtocol>)getLogger;
- (id<AliHAPageResolverProtocol>)getPageResolver;
- (NSString *)appKey;
- (NSString *)appVersion;
- (NSString *)channel;
- (NSString *)nick;
- (NSString *)utdid;
- (BOOL)isAppFirstLaunch;
- (BOOL)isReleaseVersion;
- (uint64_t)getAppStartupTimestamp;
- (NSString *)curPageName;
- (UIViewController *)curViewController;
- (NSString *)getAliHASession;
- (NSString *)getAliHAFileBySession:(NSString *)session;
@end
#pragma HA plugin protocol
@protocol AliHAPluginProtocol <NSObject>
- (void)onPluginInit:(id<AliHAContextProtocol>)context;
- (void)onPluginDestory;
@end
@interface AliHAProtocol : NSObject
+ (NSDictionary *)getTypeDescriptors;
@end
#endif 