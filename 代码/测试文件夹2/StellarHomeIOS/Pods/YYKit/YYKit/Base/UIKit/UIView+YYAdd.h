#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
@interface UIView (YYAdd)
- (nullable UIImage *)snapshotImage;
- (nullable UIImage *)snapshotImageAfterScreenUpdates:(BOOL)afterUpdates;
- (nullable NSData *)snapshotPDF;
- (void)setLayerShadow:(nullable UIColor*)color offset:(CGSize)offset radius:(CGFloat)radius;
- (void)removeAllSubviews;
@property (nullable, nonatomic, readonly) UIViewController *viewController;
@property (nonatomic, readonly) CGFloat visibleAlpha;
- (CGPoint)convertPoint:(CGPoint)point toViewOrWindow:(nullable UIView *)view;
- (CGPoint)convertPoint:(CGPoint)point fromViewOrWindow:(nullable UIView *)view;
- (CGRect)convertRect:(CGRect)rect toViewOrWindow:(nullable UIView *)view;
- (CGRect)convertRect:(CGRect)rect fromViewOrWindow:(nullable UIView *)view;
@property (nonatomic) CGFloat left;        
@property (nonatomic) CGFloat top;         
@property (nonatomic) CGFloat right;       
@property (nonatomic) CGFloat bottom;      
@property (nonatomic) CGFloat width;       
@property (nonatomic) CGFloat height;      
@property (nonatomic) CGFloat centerX;     
@property (nonatomic) CGFloat centerY;     
@property (nonatomic) CGPoint origin;      
@property (nonatomic) CGSize  size;        
@end
NS_ASSUME_NONNULL_END