#import <UIKit/UIKit.h>
#if __has_include(<YYKit/YYKit.h>)
#import <YYKit/YYAnimatedImageView.h>
#import <YYKit/YYImageCoder.h>
#else
#import "YYAnimatedImageView.h"
#import "YYImageCoder.h"
#endif
NS_ASSUME_NONNULL_BEGIN
@interface YYImage : UIImage <YYAnimatedImage>
+ (nullable YYImage *)imageNamed:(NSString *)name; 
+ (nullable YYImage *)imageWithContentsOfFile:(NSString *)path;
+ (nullable YYImage *)imageWithData:(NSData *)data;
+ (nullable YYImage *)imageWithData:(NSData *)data scale:(CGFloat)scale;
@property (nonatomic, readonly) YYImageType animatedImageType;
@property (nullable, nonatomic, readonly) NSData *animatedImageData;
@property (nonatomic, readonly) NSUInteger animatedImageMemorySize;
@property (nonatomic) BOOL preloadAllAnimatedImageFrames;
@end
NS_ASSUME_NONNULL_END