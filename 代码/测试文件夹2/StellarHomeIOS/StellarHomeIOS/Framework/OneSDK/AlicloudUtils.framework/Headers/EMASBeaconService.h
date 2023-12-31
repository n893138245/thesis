#ifndef EMASBeaconService_h
#define EMASBeaconService_h
@interface EMASBeaconConfiguration : NSObject
- (instancetype)initWithData:(NSData *)data;
- (id)getConfigureItemByKey:(NSString *)key;
@end
typedef void (^AlicloudBeaconCallbackHandler)(BOOL res, NSError *error);
@interface EMASBeaconService : NSObject
- (instancetype)initWithAppKey:(NSString *)appKey
                     appSecret:(NSString *)appSecret
                    SDKVersion:(NSString *)SDKVersion
                         SDKID:(NSString *)SDKID;
- (instancetype)initWithAppKey:(NSString *)appKey
                     appSecret:(NSString *)appSecret
                    SDKVersion:(NSString *)SDKVersion
                         SDKID:(NSString *)SDKID
                     extension:(NSDictionary *)extension;
- (void)enableLog:(BOOL)enabled;
- (BOOL)isLogEnabled;
- (void)getBeaconConfigStringByKey:(NSString *)key
           completionHandler:(void(^)(NSString *result, NSError *error))completionHandler;
@end
#endif 