#import <Foundation/Foundation.h>
@protocol CrashViewControllerInfoDelegate <NSObject>
@optional
- (NSString *)crashReporterViewControlerInfo;
@end
@interface TBCrashViewControllerInfo : NSObject
+ (instancetype)sharedInstance;
- (NSString *)crashReportCallBackViewControllerInfo;
- (void)registerCrashViewControllerInfo:(id<CrashViewControllerInfoDelegate>)viewControlInfo;
@end