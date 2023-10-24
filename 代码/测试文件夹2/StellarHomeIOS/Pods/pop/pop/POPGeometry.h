#import <Foundation/Foundation.h>
#if TARGET_OS_IPHONE
#import <UIKit/UIGeometry.h>
#endif
#if !TARGET_OS_IPHONE
@interface NSValue (POP)
+ (NSValue *)valueWithCGPoint:(CGPoint)point;
+ (NSValue *)valueWithCGSize:(CGSize)size;
+ (NSValue *)valueWithCGRect:(CGRect)rect;
+ (NSValue *)valueWithCFRange:(CFRange)range;
+ (NSValue *)valueWithCGAffineTransform:(CGAffineTransform)transform;
- (CGPoint)CGPointValue;
- (CGSize)CGSizeValue;
- (CGRect)CGRectValue;
- (CFRange)CFRangeValue;
- (CGAffineTransform)CGAffineTransformValue;
@end
#endif