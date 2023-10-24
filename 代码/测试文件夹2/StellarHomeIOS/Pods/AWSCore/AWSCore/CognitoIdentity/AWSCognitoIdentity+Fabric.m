#import "AWSCognitoIdentity+Fabric.h"
@implementation AWSCognitoIdentity (Fabric)
#pragma mark - Fabric
+ (NSString *)bundleIdentifier {
    return @"com.amazonaws.sdk.ios.AWSCognitoIdentity";
}
+ (NSString *)kitDisplayVersion {
    return AWSiOSSDKVersion;
}
+ (void)internalInitializeIfNeeded {
    Class fabricClass = NSClassFromString(@"Fabric");
    if (fabricClass
        && [fabricClass respondsToSelector:@selector(configurationDictionaryForKitClass:)]) {
        NSDictionary *configurationDictionary = [fabricClass configurationDictionaryForKitClass:[AWSCognitoIdentity class]];
        NSString *defaultRegionTypeString = configurationDictionary[@"AWSDefaultRegionType"];
        AWSRegionType defaultRegionType = [defaultRegionTypeString aws_regionTypeValue];
        NSString *cognitoIdentityRegionTypeString = configurationDictionary[@"AWSCognitoIdentityRegionType"];
        AWSRegionType cognitoIdentityRegionType = [cognitoIdentityRegionTypeString aws_regionTypeValue];
        NSString *cognitoIdentityPoolId = configurationDictionary[@"AWSCognitoIdentityPoolId"];
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            if (cognitoIdentityPoolId
                && defaultRegionType != AWSRegionUnknown
                && cognitoIdentityRegionType != AWSRegionUnknown) {
                AWSCognitoCredentialsProvider *credentialsProvider = [[AWSCognitoCredentialsProvider alloc] initWithRegionType:cognitoIdentityRegionType
                                                                                                                identityPoolId:cognitoIdentityPoolId];
                AWSServiceConfiguration *configuration = [[AWSServiceConfiguration alloc] initWithRegion:defaultRegionType
                                                                                     credentialsProvider:credentialsProvider];
                [configuration addUserAgentProductToken:@"fabric"];
                AWSServiceManager.defaultServiceManager.defaultServiceConfiguration = configuration;
                AWSDDLogInfo(@"The default Cognito credentials provider and service configuration were successfully initialized.");
            } else {
                AWSDDLogWarn(@"Could not find valid 'AWSDefaultRegionType', 'AWSCognitoRegionType', and 'AWSCognitoIdentityPoolId' values in info.plist. Unable to set the default Cognito credentials provider and service configuration. Please follow the instructions on this website and manually set up the AWS Mobile SDK for iOS. http:
            }
        });
    } else {
        AWSDDLogError(@"Fabric is not available.");
    }
}
@end