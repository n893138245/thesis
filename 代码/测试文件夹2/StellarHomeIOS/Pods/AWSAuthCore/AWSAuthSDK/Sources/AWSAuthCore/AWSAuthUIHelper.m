#import "AWSAuthUIHelper.h"
@implementation AWSAuthUIHelper
static id<AWSUIConfiguration> awsUIConfiguration;
+ (void) setUpFormShadowForView:(UIView *)view {
    view.layer.shadowColor = [UIColor blackColor].CGColor;
    view.layer.shadowOffset = CGSizeZero;
    view.layer.shadowOpacity = 0.25;
    view.layer.shadowRadius = 6;
    view.layer.cornerRadius = 10.0;
    view.layer.borderColor = [[UIColor grayColor] colorWithAlphaComponent:0.7].CGColor;
    view.layer.borderWidth = 0.5;
    view.layer.masksToBounds = NO;
}
+ (UIColor *) getBackgroundColor:(id<AWSUIConfiguration>)config {
    if (config != nil && config.backgroundColor != nil) {
        return config.backgroundColor;
    } else if (@available(iOS 13.0, *)) {
        return [UIColor systemBackgroundColor];
    }
    return [UIColor whiteColor];
}
+ (UIColor *) getSecondaryBackgroundColor {
    if (@available(iOS 13.0, *)) {
        return [UIColor secondarySystemBackgroundColor];
    }
    return [UIColor colorWithRed:0.95 green:0.95 blue:0.97 alpha:1.0];
}
+ (void) applyPrimaryColorFromConfig:(id<AWSUIConfiguration>)config
                              toView:(UIView *) view {
    [self applyPrimaryColorFromConfig:config toView:view background:YES];
}
+ (void) applyPrimaryColorFromConfig:(id<AWSUIConfiguration>)config
                              toView:(UIView *) view
                          background:(BOOL) background {
    if (config.primaryColor) {
        if (background) {
            view.backgroundColor = config.primaryColor;
        } else {
            view.tintColor = config.primaryColor;
        }
    }
}
+ (UIFont *) getFont:(id<AWSUIConfiguration>)config {
    if (config != nil && config.font != nil) {
        return config.font;
    }
    return nil;
}
+ (BOOL) isBackgroundColorFullScreen:(id<AWSUIConfiguration>)config {
    if (config != nil) {
        return config.isBackgroundColorFullScreen;
    }
    return false;
}
+ (BOOL) isDarkColor:(UIColor *) color {
    const CGFloat *componentColors = CGColorGetComponents(color.CGColor);
    CGFloat colorBrightness = (
                               (componentColors[0] * 299) +
                               (componentColors[1] * 587) +
                               (componentColors[2] * 114)
                              ) / 1000;
    return colorBrightness < 0.5;
}
+ (UIColor *) getTextColor:(id<AWSUIConfiguration>)config {
    if (@available(iOS 13.0, *)) {
        return [UIColor labelColor];
    } else if ([self isDarkColor:[self getBackgroundColor:config]]) {
        return [UIColor whiteColor];
    }
    return [UIColor darkTextColor];
}
+ (void) setAWSUIConfiguration:(id<AWSUIConfiguration>)config {
    awsUIConfiguration = config;
}
+ (id<AWSUIConfiguration>) getAWSUIConfiguration {
    return awsUIConfiguration;
}
@end