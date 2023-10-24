#import <TargetConditionals.h>
#if TARGET_OS_OSX
#import <CocoaLumberjack/CLIColor.h>
@interface CLIColor () {
    CGFloat _red, _green, _blue, _alpha;
}
@end
@implementation CLIColor
+ (instancetype)colorWithCalibratedRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha {
    CLIColor *color = [CLIColor new];
    color->_red     = red;
    color->_green   = green;
    color->_blue    = blue;
    color->_alpha   = alpha;
    return color;
}
- (void)getRed:(CGFloat *)red green:(CGFloat *)green blue:(CGFloat *)blue alpha:(CGFloat *)alpha {
    if (red) {
        *red    = _red;
    }
    if (green) {
        *green  = _green;
    }
    if (blue) {
        *blue   = _blue;
    }
    if (alpha) {
        *alpha  = _alpha;
    }
}
@end
#endif