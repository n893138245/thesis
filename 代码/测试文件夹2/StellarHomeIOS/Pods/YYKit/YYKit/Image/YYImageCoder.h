#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger, YYImageType) {
    YYImageTypeUnknown = 0, 
    YYImageTypeJPEG,        
    YYImageTypeJPEG2000,    
    YYImageTypeTIFF,        
    YYImageTypeBMP,         
    YYImageTypeICO,         
    YYImageTypeICNS,        
    YYImageTypeGIF,         
    YYImageTypePNG,         
    YYImageTypeWebP,        
    YYImageTypeOther,       
};
typedef NS_ENUM(NSUInteger, YYImageDisposeMethod) {
    YYImageDisposeNone = 0,
    YYImageDisposeBackground,
    YYImageDisposePrevious,
};
typedef NS_ENUM(NSUInteger, YYImageBlendOperation) {
    YYImageBlendNone = 0,
    YYImageBlendOver,
};
@interface YYImageFrame : NSObject <NSCopying>
@property (nonatomic) NSUInteger index;    
@property (nonatomic) NSUInteger width;    
@property (nonatomic) NSUInteger height;   
@property (nonatomic) NSUInteger offsetX;  
@property (nonatomic) NSUInteger offsetY;  
@property (nonatomic) NSTimeInterval duration;          
@property (nonatomic) YYImageDisposeMethod dispose;     
@property (nonatomic) YYImageBlendOperation blend;      
@property (nullable, nonatomic, strong) UIImage *image; 
+ (instancetype)frameWithImage:(UIImage *)image;
@end
#pragma mark - Decoder
@interface YYImageDecoder : NSObject
@property (nullable, nonatomic, readonly) NSData *data;    
@property (nonatomic, readonly) YYImageType type;          
@property (nonatomic, readonly) CGFloat scale;             
@property (nonatomic, readonly) NSUInteger frameCount;     
@property (nonatomic, readonly) NSUInteger loopCount;      
@property (nonatomic, readonly) NSUInteger width;          
@property (nonatomic, readonly) NSUInteger height;         
@property (nonatomic, readonly, getter=isFinalized) BOOL finalized;
- (instancetype)initWithScale:(CGFloat)scale NS_DESIGNATED_INITIALIZER;
- (BOOL)updateData:(nullable NSData *)data final:(BOOL)final;
+ (nullable instancetype)decoderWithData:(NSData *)data scale:(CGFloat)scale;
- (nullable YYImageFrame *)frameAtIndex:(NSUInteger)index decodeForDisplay:(BOOL)decodeForDisplay;
- (NSTimeInterval)frameDurationAtIndex:(NSUInteger)index;
- (nullable NSDictionary *)framePropertiesAtIndex:(NSUInteger)index;
- (nullable NSDictionary *)imageProperties;
@end
#pragma mark - Encoder
@interface YYImageEncoder : NSObject
@property (nonatomic, readonly) YYImageType type; 
@property (nonatomic) NSUInteger loopCount;       
@property (nonatomic) BOOL lossless;              
@property (nonatomic) CGFloat quality;            
- (instancetype)init UNAVAILABLE_ATTRIBUTE;
+ (instancetype)new UNAVAILABLE_ATTRIBUTE;
- (nullable instancetype)initWithType:(YYImageType)type NS_DESIGNATED_INITIALIZER;
- (void)addImage:(UIImage *)image duration:(NSTimeInterval)duration;
- (void)addImageWithData:(NSData *)data duration:(NSTimeInterval)duration;
- (void)addImageWithFile:(NSString *)path duration:(NSTimeInterval)duration;
- (nullable NSData *)encode;
- (BOOL)encodeToFile:(NSString *)path;
+ (nullable NSData *)encodeImage:(UIImage *)image type:(YYImageType)type quality:(CGFloat)quality;
+ (nullable NSData *)encodeImageWithDecoder:(YYImageDecoder *)decoder type:(YYImageType)type quality:(CGFloat)quality;
@end
#pragma mark - UIImage
@interface UIImage (YYImageCoder)
- (instancetype)imageByDecoded;
@property (nonatomic) BOOL isDecodedForDisplay;
- (void)saveToAlbumWithCompletionBlock:(nullable void(^)(NSURL * _Nullable assetURL, NSError * _Nullable error))completionBlock;
- (nullable NSData *)imageDataRepresentation;
@end
#pragma mark - Helper
CG_EXTERN YYImageType YYImageDetectType(CFDataRef data);
CG_EXTERN CFStringRef _Nullable YYImageTypeToUTType(YYImageType type);
CG_EXTERN YYImageType YYImageTypeFromUTType(CFStringRef uti);
CG_EXTERN NSString *_Nullable YYImageTypeGetExtension(YYImageType type);
CG_EXTERN CGColorSpaceRef YYCGColorSpaceGetDeviceRGB();
CG_EXTERN CGColorSpaceRef YYCGColorSpaceGetDeviceGray();
CG_EXTERN BOOL YYCGColorSpaceIsDeviceRGB(CGColorSpaceRef space);
CG_EXTERN BOOL YYCGColorSpaceIsDeviceGray(CGColorSpaceRef space);
CG_EXTERN UIImageOrientation YYUIImageOrientationFromEXIFValue(NSInteger value);
CG_EXTERN NSInteger YYUIImageOrientationToEXIFValue(UIImageOrientation orientation);
CG_EXTERN CGImageRef _Nullable YYCGImageCreateDecodedCopy(CGImageRef imageRef, BOOL decodeForDisplay);
CG_EXTERN CGImageRef _Nullable YYCGImageCreateCopyWithOrientation(CGImageRef imageRef,
                                                                  UIImageOrientation orientation,
                                                                  CGBitmapInfo destBitmapInfo);
CG_EXTERN CGImageRef _Nullable YYCGImageCreateAffineTransformCopy(CGImageRef imageRef,
                                                                  CGAffineTransform transform,
                                                                  CGSize destSize,
                                                                  CGBitmapInfo destBitmapInfo);
CG_EXTERN CFDataRef _Nullable YYCGImageCreateEncodedData(CGImageRef imageRef, YYImageType type, CGFloat quality);
CG_EXTERN BOOL YYImageWebPAvailable();
CG_EXTERN NSUInteger YYImageGetWebPFrameCount(CFDataRef webpData);
CG_EXTERN CGImageRef _Nullable YYCGImageCreateWithWebPData(CFDataRef webpData,
                                                           BOOL decodeForDisplay,
                                                           BOOL useThreads,
                                                           BOOL bypassFiltering,
                                                           BOOL noFancyUpsampling);
typedef NS_ENUM(NSUInteger, YYImagePreset) {
    YYImagePresetDefault = 0,  
    YYImagePresetPicture,      
    YYImagePresetPhoto,        
    YYImagePresetDrawing,      
    YYImagePresetIcon,         
    YYImagePresetText          
};
CG_EXTERN CFDataRef _Nullable YYCGImageCreateEncodedWebPData(CGImageRef imageRef,
                                                             BOOL lossless,
                                                             CGFloat quality,
                                                             int compressLevel,
                                                             YYImagePreset preset);
NS_ASSUME_NONNULL_END