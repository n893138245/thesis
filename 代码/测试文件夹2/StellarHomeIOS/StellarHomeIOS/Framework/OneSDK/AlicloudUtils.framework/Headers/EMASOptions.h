#ifndef EMASOptions_h
#define EMASOptions_h
@interface EMASOptionSDKServiceItem : NSObject
@property (nonatomic, copy) NSString *sdkId;
@property (nonatomic, copy) NSString *version;
@property (nonatomic, assign) NSNumber *status;
@end
@interface EMASOptions : NSObject
@property (nonatomic, copy, readonly) NSString *emasAppKey;
@property (nonatomic, copy, readonly) NSString *emasAppSecret;
@property (nonatomic, copy, readonly) NSString *emasBundleId;
@property (nonatomic, copy, readonly) NSString *hotfixIdSecret;
@property (nonatomic, copy, readonly) NSString *hotfixRsaSecret;
@property (nonatomic, copy, readonly) NSString *tlogRsaSecret;
@property (nonatomic, copy, readonly) NSString *appmonitorRsaSecret;
@property (nonatomic, copy, readonly) NSString *httpdnsAccountId;
@property (nonatomic, copy, readonly) NSString *httpdnsSecretKey;
+ (EMASOptions *)defaultOptions;
- (NSString *)optionByConfigKey:(NSString *)key;
- (EMASOptionSDKServiceItem *)sdkServiceItemForSdkId:(NSString *)sdkId;
@end
#endif 