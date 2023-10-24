#import <Foundation/Foundation.h>
#import "MOBFImageServiceTypeDef.h"
@interface MOBFImageCachePolicy : NSObject
@property (nonatomic, copy) NSString *cacheName;
@property (nonatomic, strong) MOBFImageGetterCacheHandler cacheHandler;
+ (instancetype)defaultCachePolicy;
@end