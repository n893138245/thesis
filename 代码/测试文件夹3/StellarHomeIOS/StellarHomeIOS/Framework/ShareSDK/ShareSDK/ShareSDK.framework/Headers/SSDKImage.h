#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
extern NSString *const SSDKImageFormatJpeg;
extern NSString *const SSDKImageFormatPng;
extern NSString *const SSDKImageSettingQualityKey;
@interface SSDKImage : NSObject
@property (strong, nonatomic) NSURL *URL;
+ (instancetype)imageWithObject:(id)object;
- (id)initWithURL:(NSURL *)URL;
- (id)initWithImage:(UIImage *)image format:(NSString *)format settings:(NSDictionary *)settings;
- (void)getNativeImage:(void(^)(UIImage *image))handler;
- (void)getNativeImageData:(void(^)(NSData *imageData))handler;
+ (void)getImage:(NSString *)imagePath
  thumbImagePath:(NSString *)thumbImagePath
          result:(void(^)(NSData *thumbImage, NSData *image))handler;
+ (NSData *)checkThumbImageSize:(NSData *)thumbImageData;
@end