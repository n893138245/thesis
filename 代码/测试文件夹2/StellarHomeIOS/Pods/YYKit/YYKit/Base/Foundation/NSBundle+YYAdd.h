#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN
@interface NSBundle (YYAdd)
+ (NSArray<NSNumber *> *)preferredScales;
+ (nullable NSString *)pathForScaledResource:(NSString *)name
                                      ofType:(nullable NSString *)ext
                                 inDirectory:(NSString *)bundlePath;
- (nullable NSString *)pathForScaledResource:(NSString *)name ofType:(nullable NSString *)ext;
- (nullable NSString *)pathForScaledResource:(NSString *)name
                                      ofType:(nullable NSString *)ext
                                 inDirectory:(nullable NSString *)subpath;
@end
NS_ASSUME_NONNULL_END