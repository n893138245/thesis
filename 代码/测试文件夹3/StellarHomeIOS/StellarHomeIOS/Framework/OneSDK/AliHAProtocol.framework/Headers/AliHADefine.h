#ifndef AliPerformanceDefine_h
#define AliPerformanceDefine_h
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#define kAliHAIsTraceFileEnabled                          @"isTraceFileEnabled" 
#define kAliHAIsPerformanceMonitorEnabled                 @"isPerformanceMonitorEnabled" 
#define kAliHAIsRetainCycleDetectorEnabled                @"isRetainCycleDetectorEnabled" 
#define kAliHAIsBigMallocDetectorEnabled                  @"isBigMallocDetectorEnabled" 
#define kAliHAIsTraceFileUploadEnabled                    @"isTraceFileUploadEnabled" 
#define kAliHAIsMemoryMonitorEnabled                      @"isMemoryMonitorEnabled" 
#define kAliHAIsSmartRecoveryEnabled                      @"isSmartRecoveryEnabled" 
#define kAliHAIsSmartRecoveryImageMemoryManagerEnabled                      @"isSmartRecoveryImageMemoryManagerEnabled" 
#define kAliHAMonitorVCDidAppear                          @"isMonitorVCDidAppear" 
#define kAliHAMonitorVCLayoutSubview                      @"isMonitorVCLayoutSubview" 
#define kAliHAMonitorUIViewLayoutSubview                  @"isMonitorUIViewLayoutSubview" 
#define kAliHAMonitorTransitionFromView                   @"isMonitorTransitionFromView" 
#define kAliPerformanceConfigDisableFPS                @"fpsSampleDisable"          
#define kAliPerformanceConfigDisableNet                @"netSampleDisable"
#define kAliPerformanceConfigDisablePageLoad           @"pageLoadSampleDisable"
#define kAliPerformanceCurPageName                    @"pageName"          
#define kAliPerformanceVaildPageChange                @"vaildPageChange"
#define kAliPerformanceCurRealVC                      @"curRealVC"
static NSString * const AliPerformancePageNameKey = @"AliPPageNameKey";
#endif 