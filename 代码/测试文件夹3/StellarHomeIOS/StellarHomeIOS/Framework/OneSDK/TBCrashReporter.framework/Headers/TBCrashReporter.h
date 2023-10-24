#import <Foundation/Foundation.h>
#import <mach/mach_types.h>
#import <CrashReporter/CrashReporter.h>
#import <AliHAProtocol/AliHAProtocol.h>
#import <TBCrashReporter/TBCrashViewControllerInfo.h>
#import <TBCrashReporter/TBCrashReporterUtility.h>
#import <TBCrashReporter/TBCrashReporterMonitor.h>
void TBCrashReporterSetPreHandler(BOOL(*handler)(uintptr_t));
@protocol TBCrashReporterDelegate <NSObject>
@optional
- (void)uploadPLCrashReport:(NSString *)plCrashReport;
- (void)uploadCrashBackTrace:(NSString *)backTrace withReason:(NSString *)reason;
- (void)uploadMainThreadDeadlockWithBacktrace:(NSString *)backtrace;
@end
@protocol TBCrashReporterRunLoopDelegate <NSObject>
@optional
- (void)mainRunLoopStuckCallBack:(NSString *)report ExtData:(NSDictionary*)extData;
@end
@interface TBCrashReporter : NSObject <AliHAPluginProtocol>
@property (nonatomic, strong) id<AliHAContextProtocol> aliHAContext;
@property (nonatomic, assign) BOOL isFullTraceUploadEnabled;        
@property (nonatomic, assign) id<TBCrashReporterDelegate> delegate;
@property (nonatomic, assign) id<TBCrashReporterRunLoopDelegate> runLoopDelegate  __attribute__((deprecated));
@property (nonatomic, readonly) BOOL isUsingKSCrash;
+ (instancetype)sharedReporter;
- (PLCrashReporter *) getPLCrashReport;
- (void)initCrashSDK:(NSString*)appKey AppVersion:(NSString*)appVersion Channel:(NSString*)channel Usernick:(NSString*)usernick;
- (void)initCrashSDKForKSCrash:(NSString*)appKey AppVersion:(NSString*)appVersion Channel:(NSString*)channel Usernick:(NSString*)usernick;
- (void) startMainRunLoopObserver;
- (void) startMainRunLoopObserverWithBaseBlockTime:(float)blockTime;
- (void) startMainRunLoopObserverWithBaseBlockTime:(float)blockTime isCloseSampling:(BOOL)isClose;
- (void)registMainRunLoopCallBack:(id<TBCrashReporterRunLoopDelegate>)mainRunLoop;
- (void) turnOffMainRunLoopObserver;
- (void)setWhenChangeUserNick:(NSString*)usernick;
- (void)setWhenChangeAppVersion:(NSString*)appVersion;
- (void)setMergeCrashReport:(BOOL)isMerge;
- (void)checkAndUploadCrashReporter;
- (void)customError:(NSError *)error extInfo:(NSDictionary *)extInfo;
- (void)sendCatchedCrashReportWithContent:(NSString*)content  __attribute__((deprecated));
- (void)sendCatchedCrashReportWithType:(NSString*)type SubType:(NSString*)subType Content:(NSString*)content __attribute__((deprecated));
- (NSString*) generateLiveReportWithThread:(thread_t)thread;
typedef void(^SendCrashReportCallback)(BOOL success);
- (void)sendCatchedCrashReportWithContent:(NSString *)content ExtInfo:(NSDictionary *)extInfo CallBack:(SendCrashReportCallback)sendCrashReportCallback;
- (void)sendCatchedCrashReportWithContent:(NSString *)content ExtInfo:(NSDictionary *)extInfo;
- (void)sendCatchedCrashReportWithType:(NSString*)type SubType:(NSString*)subType Content:(NSString*)content ExtInfo:(NSDictionary *)extInfo CallBack:(SendCrashReportCallback)sendCrashReportCallback;
- (void)sendCatchedCrashReportWithType:(NSString*)type SubType:(NSString*)subType Content:(NSString*)content ExtInfo:(NSDictionary *)extInfo;
- (void)configBlockTime:(float)blockTime;
-(void) beforeSendInitArgsWithAppkey:(NSString*)appKey Channel:(NSString*)channel UserNick:(NSString*)usernick AppVersion:(NSString*) appVersion __attribute__((deprecated));
-(BOOL) sendLogSync:(NSObject *)aPageName eventId:(int) aEventId arg1:(NSString *) aArg1 arg2:(NSString *) aArg2 arg3:(NSString *) aArg3 args:(NSDictionary *) aArgs __attribute__((deprecated));
-(void) sendLogAsync:(NSObject *)aPageName eventId:(int) aEventId arg1:(NSString *) aArg1 arg2:(NSString *) aArg2 arg3:(NSString *) aArg3 args:(NSDictionary *) aArgs __attribute__((deprecated));
- (void)setCrashReporterModuleToMachException:(BOOL)isMachException __attribute__((deprecated));
- (void)turnOnMainThreadDeadlockMonitor __attribute__((deprecated));
- (void)turnOnMainThreadDeadlockMonitorWithDealockInterval:(NSTimeInterval)deadlockInterval __attribute__((deprecated));
- (void)turnOffMainThreadDeadlockMonitor __attribute__((deprecated));
@end