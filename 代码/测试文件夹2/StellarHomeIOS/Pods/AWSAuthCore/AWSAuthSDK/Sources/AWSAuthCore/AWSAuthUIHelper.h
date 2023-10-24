#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AWSUIConfiguration.h"
NS_ASSUME_NONNULL_BEGIN
@interface AWSAuthUIHelper : NSObject
+ (void) setUpFormShadowForView:(UIView *)view;
+ (UIColor *) getBackgroundColor:(id<AWSUIConfiguration>)config;
+ (UIColor *) getSecondaryBackgroundColor;
+ (void) applyPrimaryColorFromConfig:(id<AWSUIConfiguration>)config
                              toView:(UIView *) view
                          background:(BOOL) background;
+ (void) applyPrimaryColorFromConfig:(id<AWSUIConfiguration>)config
                              toView:(UIView *) view;
+ (UIFont *) getFont:(id<AWSUIConfiguration>)config;
+ (BOOL) isBackgroundColorFullScreen:(id<AWSUIConfiguration>)config;
+ (UIColor *) getTextColor:(id<AWSUIConfiguration>)config;
+ (void) setAWSUIConfiguration:(id<AWSUIConfiguration>)config;
+ (id<AWSUIConfiguration>) getAWSUIConfiguration;
@end
NS_ASSUME_NONNULL_END