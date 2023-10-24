#import <Foundation/Foundation.h>
@interface MOBFDataService : NSObject
+ (MOBFDataService *)sharedInstance;
- (void)setSharedData:(id)data forKey:(NSString *)key;
- (id)sharedDataForKey:(NSString *)key;
- (void)beginCacheDataTransForDomain:(NSString *)domain;
- (void)endCacheDataTransForDomain:(NSString *)domain;
- (void)setCacheData:(id)data forKey:(NSString *)key domain:(NSString *)domain;
- (id)cacheDataForKey:(NSString *)key domain:(NSString *)domain;
- (void)beginSecureDataTrans;
- (void)endSecureDataTrans;
- (void)setSecureData:(id)data forKey:(NSString *)key;
- (id)secureDataForKey:(NSString *)key;
@end