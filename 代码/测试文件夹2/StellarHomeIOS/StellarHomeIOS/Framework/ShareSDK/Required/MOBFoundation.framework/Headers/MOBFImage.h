#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, MOBFOvalType)
{
    MOBFOvalTypeNone = 0x00,
    MOBFOvalTypeLeftTop = 0x01,
    MOBFOvalTypeLeftBottom = 0x02,
    MOBFOvalTypeRightTop = 0x04,
    MOBFOvalTypeRightBottom = 0x08,
    MOBFOvalTypeAll = MOBFOvalTypeLeftTop | MOBFOvalTypeLeftBottom | MOBFOvalTypeRightTop | MOBFOvalTypeRightBottom
};
@interface MOBFImage : NSObject
+ (UIImage *)clipImage:(UIImage *)image withRect:(CGRect)rect;
+ (UIImage *)roundRectImage:(UIImage *)image
                   withSize:(CGSize)size
                  ovalWidth:(CGFloat)ovalWidth
                 ovalHeight:(CGFloat)ovalHeight
                   ovalType:(MOBFOvalType)ovalType;
+ (UIImage *)scaleImage:(UIImage *)image withSize:(CGSize)size;
+ (UIImage *)imageName:(NSString *)name bundle:(NSBundle *)bundle;
+ (UIImage *)imageByView:(UIView *)view;
+ (UIImage *)imageByView:(UIView *)view opaque:(BOOL)opaque;
@end