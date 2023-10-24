#import <Foundation/Foundation.h>
#import "EMASRestConfiguration.h"
NS_ASSUME_NONNULL_BEGIN
@interface EMASRestCacheConfig : NSObject
@property (nonatomic, assign) int memoryCacheSizeLimit; 
@property (nonatomic, assign) int memoryCacheCountLimit; 
@property (nonatomic, assign) BOOL memoryCacheSwitch; 
@property (nonatomic, assign) BOOL diskCacheSwitch; 
@property (nonatomic, strong) NSString *cacheName; 
@property (nonatomic, strong) NSString *cacheKey;
@property (nonatomic, strong) EMASRestConfiguration *restConfig;
- (BOOL)isValid;
@end
NS_ASSUME_NONNULL_END