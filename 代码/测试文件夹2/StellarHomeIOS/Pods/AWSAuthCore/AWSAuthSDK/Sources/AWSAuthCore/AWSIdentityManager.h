#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <AWSCore/AWSCore.h>
#import "AWSSignInProvider.h"
#import "AWSSignInProviderApplicationIntercept.h"
NS_ASSUME_NONNULL_BEGIN
@interface AWSIdentityManager : NSObject<AWSIdentityProviderManager>
@property (nonatomic, readonly, nullable) NSString *identityId;
@property (nonatomic, readonly, strong) AWSCognitoCredentialsProvider *credentialsProvider;
-(AWSIdentityManagerAuthState)authState;
+ (instancetype)defaultIdentityManager;
@end
NS_ASSUME_NONNULL_END