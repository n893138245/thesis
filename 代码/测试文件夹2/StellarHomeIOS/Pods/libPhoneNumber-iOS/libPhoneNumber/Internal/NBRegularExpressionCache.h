#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN
@interface NBRegularExpressionCache : NSObject
+ (instancetype)sharedInstance;
- (nullable NSRegularExpression *)regularExpressionForPattern:(NSString *)pattern
                                                        error:(NSError * _Nullable *)error;
@end
NS_ASSUME_NONNULL_END