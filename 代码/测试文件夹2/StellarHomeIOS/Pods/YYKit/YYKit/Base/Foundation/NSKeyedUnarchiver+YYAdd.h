#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN
@interface NSKeyedUnarchiver (YYAdd)
+ (nullable id)unarchiveObjectWithData:(NSData *)data
                             exception:(NSException *_Nullable *_Nullable)exception;
+ (nullable id)unarchiveObjectWithFile:(NSString *)path
                             exception:(NSException *_Nullable *_Nullable)exception;
@end
NS_ASSUME_NONNULL_END