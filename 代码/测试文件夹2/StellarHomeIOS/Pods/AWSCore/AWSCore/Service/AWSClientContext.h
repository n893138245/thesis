#import <Foundation/Foundation.h>
FOUNDATION_EXPORT NSString *const AWSClientContextVersion;
FOUNDATION_EXPORT NSString *const AWSClientContextHeader;
FOUNDATION_EXPORT NSString *const AWSClientContextHeaderEncoding;
@interface AWSClientContext : NSObject
#pragma mark - App Details
@property (nonatomic, strong, readonly) NSString *installationId;
@property (nonatomic, strong) NSString *appVersion;
@property (nonatomic, strong) NSString *appBuild;
@property (nonatomic, strong) NSString *appPackageName;
@property (nonatomic, strong) NSString *appName;
#pragma mark - Device Details
@property (nonatomic, strong) NSString *devicePlatformVersion;
@property (nonatomic, strong) NSString *devicePlatform;
@property (nonatomic, strong) NSString *deviceManufacturer;
@property (nonatomic, strong) NSString *deviceModel;
@property (nonatomic, strong) NSString *deviceModelVersion;
@property (nonatomic, strong) NSString *deviceLocale;
#pragma mark - Custom Attributes
@property (nonatomic, strong) NSDictionary *customAttributes;
#pragma mark - Service Details
@property (nonatomic, strong, readonly) NSDictionary *serviceDetails;
- (instancetype)init;
- (NSDictionary *)dictionaryRepresentation;
- (NSString *)JSONString;
- (NSString *)base64EncodedJSONString;
- (void)setDetails:(id)details
        forService:(NSString *)service;
@end