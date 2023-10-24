#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN
@interface AWSCognitoIdentityASF : NSObject
+ (NSString *)userContextData: (int) minTarget build: (NSString *) build userPoolId: (NSString*) userPoolId username: (NSString *) username deviceId: ( NSString * _Nullable ) deviceId userPoolClientId: (NSString *) userPoolClientId;
@end
NS_ASSUME_NONNULL_END