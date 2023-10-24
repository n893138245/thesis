#import <Foundation/Foundation.h>
typedef void (^ABSBoolCompletionHandler)(BOOL succeeded, NSError *error);
typedef void (^ABSRepairBlock)(ABSBoolCompletionHandler completionHandler);
typedef void (^ABSReportBlock)(NSUInteger crashCounts);
typedef NS_ENUM(NSInteger, ABSBootingProtectionStatus) {
    ABSBootingProtectionStatusNormal,  
    ABSBootingProtectionStatusNormalChecking,  
    ABSBootingProtectionStatusNeedFix, 
    ABSBootingProtectionStatusFixing,   
};
@interface ABSBootingProtection : NSObject
- (void)launchContinuousCrashProtect;
@property (nonatomic, assign, readonly) ABSBootingProtectionStatus bootingProtectionStatus;
@property (nonatomic, assign, readonly) NSUInteger continuousCrashOnLaunchNeedToReport;
@property (nonatomic, assign, readonly) NSUInteger continuousCrashOnLaunchNeedToFix;
@property (nonatomic, assign, readonly) NSTimeInterval crashOnLaunchTimeIntervalThreshold;
@property (nonatomic, copy, readonly) NSString *context;
- (instancetype)initWithContinuousCrashOnLaunchNeedToReport:(NSUInteger)continuousCrashOnLaunchNeedToReport
                           continuousCrashOnLaunchNeedToFix:(NSUInteger)continuousCrashOnLaunchNeedToFix
                         crashOnLaunchTimeIntervalThreshold:(NSTimeInterval)crashOnLaunchTimeIntervalThreshold
                                                    context:(NSString *)context;
+ (ABSBootingProtectionStatus)bootingProtectionStatusWithContext:(NSString *)context continuousCrashOnLaunchNeedToFix:(NSUInteger)continuousCrashOnLaunchNeedToFix;
- (void)setReportBlock:(ABSReportBlock)reportBlock;
- (void)setRepairBlock:(ABSRepairBlock)repairtBlock;
@end