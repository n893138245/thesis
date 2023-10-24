#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN
typedef NS_OPTIONS (NSUInteger, YYFileHashType) {
    YYFileHashTypeMD2     = 1 << 0, 
    YYFileHashTypeMD4     = 1 << 1, 
    YYFileHashTypeMD5     = 1 << 2, 
    YYFileHashTypeSHA1    = 1 << 3, 
    YYFileHashTypeSHA224  = 1 << 4, 
    YYFileHashTypeSHA256  = 1 << 5, 
    YYFileHashTypeSHA384  = 1 << 6, 
    YYFileHashTypeSHA512  = 1 << 7, 
    YYFileHashTypeCRC32   = 1 << 8, 
    YYFileHashTypeAdler32 = 1 << 9, 
};
@interface YYFileHash : NSObject
+ (nullable YYFileHash *)hashForFile:(NSString *)filePath types:(YYFileHashType)types;
+ (nullable YYFileHash *)hashForFile:(NSString *)filePath
                               types:(YYFileHashType)types
                          usingBlock:(nullable void (^)(UInt64 totalSize, UInt64 processedSize, BOOL *stop))block;
@property (nonatomic, readonly) YYFileHashType types; 
@property (nullable, nonatomic, strong, readonly) NSString *md2String; 
@property (nullable, nonatomic, strong, readonly) NSString *md4String; 
@property (nullable, nonatomic, strong, readonly) NSString *md5String; 
@property (nullable, nonatomic, strong, readonly) NSString *sha1String; 
@property (nullable, nonatomic, strong, readonly) NSString *sha224String; 
@property (nullable, nonatomic, strong, readonly) NSString *sha256String; 
@property (nullable, nonatomic, strong, readonly) NSString *sha384String; 
@property (nullable, nonatomic, strong, readonly) NSString *sha512String; 
@property (nullable, nonatomic, strong, readonly) NSString *crc32String; 
@property (nullable, nonatomic, strong, readonly) NSString *adler32String; 
@property (nullable, nonatomic, strong, readonly) NSData *md2Data; 
@property (nullable, nonatomic, strong, readonly) NSData *md4Data; 
@property (nullable, nonatomic, strong, readonly) NSData *md5Data; 
@property (nullable, nonatomic, strong, readonly) NSData *sha1Data; 
@property (nullable, nonatomic, strong, readonly) NSData *sha224Data; 
@property (nullable, nonatomic, strong, readonly) NSData *sha256Data; 
@property (nullable, nonatomic, strong, readonly) NSData *sha384Data; 
@property (nullable, nonatomic, strong, readonly) NSData *sha512Data; 
@property (nonatomic, readonly) uint32_t crc32; 
@property (nonatomic, readonly) uint32_t adler32; 
@end
NS_ASSUME_NONNULL_END