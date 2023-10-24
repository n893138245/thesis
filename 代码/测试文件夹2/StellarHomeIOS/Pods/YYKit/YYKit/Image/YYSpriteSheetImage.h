#import <UIKit/UIKit.h>
#if __has_include(<YYKit/YYKit.h>)
#import <YYKit/YYAnimatedImageView.h>
#else
#import "YYAnimatedImageView.h"
#endif
NS_ASSUME_NONNULL_BEGIN
@interface YYSpriteSheetImage : UIImage <YYAnimatedImage>
- (nullable instancetype)initWithSpriteSheetImage:(UIImage *)image
                                     contentRects:(NSArray<NSValue *> *)contentRects
                                   frameDurations:(NSArray<NSNumber *> *)frameDurations
                                        loopCount:(NSUInteger)loopCount;
@property (nonatomic, readonly) NSArray<NSValue *> *contentRects;
@property (nonatomic, readonly) NSArray<NSValue *> *frameDurations;
@property (nonatomic, readonly) NSUInteger loopCount;
- (CGRect)contentsRectForCALayerAtIndex:(NSUInteger)index;
@end
NS_ASSUME_NONNULL_END