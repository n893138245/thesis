#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface MOBFColor : NSObject
+ (UIColor *)colorWithRGB:(NSUInteger)rgb;
+ (UIColor *)colorWithARGB:(NSUInteger)argb;
@end