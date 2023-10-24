#import <UIKit/UIKit.h>
typedef enum : NSUInteger {
    TZOscillatoryAnimationToBigger,
    TZOscillatoryAnimationToSmaller,
} TZOscillatoryAnimationType;
@interface UIView (TZLayout)
@property (nonatomic) CGFloat tz_left;        
@property (nonatomic) CGFloat tz_top;         
@property (nonatomic) CGFloat tz_right;       
@property (nonatomic) CGFloat tz_bottom;      
@property (nonatomic) CGFloat tz_width;       
@property (nonatomic) CGFloat tz_height;      
@property (nonatomic) CGFloat tz_centerX;     
@property (nonatomic) CGFloat tz_centerY;     
@property (nonatomic) CGPoint tz_origin;      
@property (nonatomic) CGSize  tz_size;        
+ (void)showOscillatoryAnimationWithLayer:(CALayer *)layer type:(TZOscillatoryAnimationType)type;
@end