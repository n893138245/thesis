#import <UIKit/UIKit.h>
#if __has_include(<YYKit/YYKit.h>)
#import <YYKit/YYTextAttribute.h>
#else
#import "YYTextAttribute.h"
#endif
NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, YYTextMagnifierType) {
    YYTextMagnifierTypeCaret,  
    YYTextMagnifierTypeRanged, 
};
@interface YYTextMagnifier : UIView
+ (id)magnifierWithType:(YYTextMagnifierType)type;
@property (nonatomic, readonly) YYTextMagnifierType type;  
@property (nonatomic, readonly) CGSize fitSize;            
@property (nonatomic, readonly) CGSize snapshotSize;       
@property (nullable, nonatomic, strong) UIImage *snapshot; 
@property (nullable, nonatomic, weak) UIView *hostView;   
@property (nonatomic) CGPoint hostCaptureCenter;          
@property (nonatomic) CGPoint hostPopoverCenter;          
@property (nonatomic) BOOL hostVerticalForm;              
@property (nonatomic) BOOL captureDisabled;               
@property (nonatomic) BOOL captureFadeAnimation;          
@end
NS_ASSUME_NONNULL_END