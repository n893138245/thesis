#import <Foundation/Foundation.h>
#import "AWSSignInProvider.h"
#import "AWSSignInManager.h"
NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, AWSSignInButtonStyle) {
    AWSSignInButtonStyleSmall,
    AWSSignInButtonStyleLarge
};
@protocol AWSSignInButtonView<NSObject>
@property (nonatomic, weak) id<AWSSignInDelegate> delegate;
@property (nonatomic) AWSSignInButtonStyle buttonStyle;
- (void)setSignInProvider:(id<AWSSignInProvider>)signInProvider;
@end
NS_ASSUME_NONNULL_END