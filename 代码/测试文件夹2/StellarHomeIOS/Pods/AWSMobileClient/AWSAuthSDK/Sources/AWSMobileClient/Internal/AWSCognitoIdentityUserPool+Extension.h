#ifndef AWSCognitoIdentityUserPool_Extension_h
#define AWSCognitoIdentityUserPool_Extension_h
#import <AWSCognitoIdentityProvider/AWSCognitoIdentityProvider.h>
@interface AWSCognitoIdentityUserPool (Internal)
@property (nonatomic, assign) BOOL isCustomAuth;
@end
@protocol AWSCognitoUserPoolInternalDelegate
-(id<AWSCognitoIdentityCustomAuthentication>) startCustomAuthentication_v2;
@end
#endif 