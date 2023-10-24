#import <UIKit/UIKit.h>
@class YYMemoryCache, YYDiskCache;
NS_ASSUME_NONNULL_BEGIN
typedef NS_OPTIONS(NSUInteger, YYImageCacheType) {
    YYImageCacheTypeNone   = 0,
    YYImageCacheTypeMemory = 1 << 0,
    YYImageCacheTypeDisk   = 1 << 1,
    YYImageCacheTypeAll    = YYImageCacheTypeMemory | YYImageCacheTypeDisk,
};
@interface YYImageCache : NSObject
#pragma mark - Attribute
@property (nullable, copy) NSString *name;
@property (strong, readonly) YYMemoryCache *memoryCache;
@property (strong, readonly) YYDiskCache *diskCache;
@property BOOL allowAnimatedImage;
@property BOOL decodeForDisplay;
#pragma mark - Initializer
- (instancetype)init UNAVAILABLE_ATTRIBUTE;
+ (instancetype)new UNAVAILABLE_ATTRIBUTE;
+ (instancetype)sharedCache;
- (nullable instancetype)initWithPath:(NSString *)path NS_DESIGNATED_INITIALIZER;
#pragma mark - Access Methods
- (void)setImage:(UIImage *)image forKey:(NSString *)key;
- (void)setImage:(nullable UIImage *)image
       imageData:(nullable NSData *)imageData
          forKey:(NSString *)key
        withType:(YYImageCacheType)type;
- (void)removeImageForKey:(NSString *)key;
- (void)removeImageForKey:(NSString *)key withType:(YYImageCacheType)type;
- (BOOL)containsImageForKey:(NSString *)key;
- (BOOL)containsImageForKey:(NSString *)key withType:(YYImageCacheType)type;
- (nullable UIImage *)getImageForKey:(NSString *)key;
- (nullable UIImage *)getImageForKey:(NSString *)key withType:(YYImageCacheType)type;
- (void)getImageForKey:(NSString *)key
              withType:(YYImageCacheType)type
             withBlock:(void(^)(UIImage * _Nullable image, YYImageCacheType type))block;
- (nullable NSData *)getImageDataForKey:(NSString *)key;
- (void)getImageDataForKey:(NSString *)key
                 withBlock:(void(^)(NSData * _Nullable imageData))block;
@end
NS_ASSUME_NONNULL_END