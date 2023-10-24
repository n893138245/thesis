#import <UIKit/UIKit.h>
#import <AWSCore/AWSCore.h>
NS_ASSUME_NONNULL_BEGIN
@class AWSIdentityManager;
typedef NS_ENUM(NSInteger, AWSIdentityManagerAuthState) {
    AWSIdentityManagerAuthStateAuthenticated,
    AWSIdentityManagerAuthStateUnauthenticated,
    AWSIdentityManagerAuthStateUnknown,
};
@protocol AWSSignInProvider <AWSIdentityProvider>
@property (nonatomic, readonly, getter=isLoggedIn) BOOL loggedIn;
- (void)login:(void (^)(id _Nullable result, NSError * _Nullable error))completionHandler;
- (void)logout;
- (void)reloadSession;
@end
NS_ASSUME_NONNULL_END