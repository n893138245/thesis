#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
@interface UIScreen (YYAdd)
+ (CGFloat)screenScale;
- (CGRect)currentBounds NS_EXTENSION_UNAVAILABLE_IOS("");
- (CGRect)boundsForOrientation:(UIInterfaceOrientation)orientation;
@property (nonatomic, readonly) CGSize sizeInPixel;
@property (nonatomic, readonly) CGFloat pixelsPerInch;
@end
NS_ASSUME_NONNULL_END