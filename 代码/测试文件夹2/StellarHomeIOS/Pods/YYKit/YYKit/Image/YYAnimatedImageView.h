#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
@interface YYAnimatedImageView : UIImageView
@property (nonatomic) BOOL autoPlayAnimatedImage;
@property (nonatomic) NSUInteger currentAnimatedImageIndex;
@property (nonatomic, readonly) BOOL currentIsPlayingAnimation;
@property (nonatomic, copy) NSString *runloopMode;
@property (nonatomic) NSUInteger maxBufferSize;
@end
@protocol YYAnimatedImage <NSObject>
@required
- (NSUInteger)animatedImageFrameCount;
- (NSUInteger)animatedImageLoopCount;
- (NSUInteger)animatedImageBytesPerFrame;
- (nullable UIImage *)animatedImageFrameAtIndex:(NSUInteger)index;
- (NSTimeInterval)animatedImageDurationAtIndex:(NSUInteger)index;
@optional
- (CGRect)animatedImageContentsRectAtIndex:(NSUInteger)index;
@end
NS_ASSUME_NONNULL_END