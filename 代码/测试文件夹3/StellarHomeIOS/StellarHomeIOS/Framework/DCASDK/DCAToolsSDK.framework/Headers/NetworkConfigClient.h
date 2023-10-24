#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class CBPeripheral;
@class BleLinkManager;
typedef NS_ENUM(NSUInteger, NetConfigResultCode) {
    NetConfigSuccess                     = 0,
    NetConfigUnableConnectToRemoteDevice = 1,
    NetConfigUnableMatchProtocol         = 2,
};
extern NSString *const EXTRA_PID;
extern NSString *const EXTRA_DSN;
@protocol NetworkConfigDelegate <NSObject>
@required
- (void)onNetworkConfigResult:(NetConfigResultCode)resultCode data:(NSString *)data;
@end
@interface NetworkConfigClient : NSObject
+ (NSString *)resultCodeToString:(NetConfigResultCode)resultCode;
- (instancetype)initWithLinkManager:(BleLinkManager *)linkManager delegate:(id<NetworkConfigDelegate>)delegate;
- (BOOL)configNetworkWithPeripheral:(CBPeripheral *)peripheral ssid:(NSString *)ssid psk:(NSString *)psk date:(NSString *)date targetViewController:(UIViewController *)targetViewController;
@end