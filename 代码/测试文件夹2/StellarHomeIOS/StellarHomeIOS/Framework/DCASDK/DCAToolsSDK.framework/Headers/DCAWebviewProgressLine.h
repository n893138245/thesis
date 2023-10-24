#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
@interface DCAWebviewProgressLine : UIView
@property (nonatomic,strong) UIColor  *lineColor;
-(void)startLoadingAnimation;
-(void)endLoadingAnimation;
-(UIColor *) colorWithHexString: (NSString *)hexString;
@end
NS_ASSUME_NONNULL_END