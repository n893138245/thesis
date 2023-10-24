#import <UIKit/UIKit.h>
@interface UIViewController (AliHA)
- (BOOL)aliha_isMainLinkController;
- (void)aliha_setMainLinkController:(BOOL)yesOrNo;
- (BOOL)aliha_isControllerWillExited;
- (void)aliha_setControllerWillExited:(BOOL)yesOrNo;
- (void)aliha_willExitController;
- (size_t)aliha_currentMemoryUsage;
- (void)aliha_setCurrentMemoryUsage:(size_t)usage;
- (size_t)aliha_forecastMemoryUsage;
- (void)aliha_setForecastMemoryUsage:(size_t)usage;
- (int)aliha_forecastMemoryWarnLevel;
- (void)aliha_setForecastMemoryWarnLevel:(int)level;
@end