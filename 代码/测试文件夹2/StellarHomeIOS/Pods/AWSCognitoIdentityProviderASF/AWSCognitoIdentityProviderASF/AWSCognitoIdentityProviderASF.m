#import "AWSCognitoIdentityProviderASF.h"
#import "AWSCognitoIdentityASF.h"
@implementation AWSCognitoIdentityProviderASF
+ (NSString *)userContextData: (NSString*) userPoolId username: (NSString * _Nullable) username deviceId: ( NSString * _Nullable ) deviceId userPoolClientId: (NSString *) userPoolClientId {
    NSString * build = @"release";
#ifdef DEBUG
    build = @"debug";
#endif
    return [AWSCognitoIdentityASF userContextData:  __IPHONE_OS_VERSION_MIN_REQUIRED
                                            build:build userPoolId: userPoolId username:username deviceId:deviceId userPoolClientId:userPoolClientId];
}
@end