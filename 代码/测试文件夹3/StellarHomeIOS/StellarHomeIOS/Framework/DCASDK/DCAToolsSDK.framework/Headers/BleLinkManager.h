#import <Foundation/Foundation.h>
@class CBPeripheral;
@protocol BleLinkManagerDelegate <NSObject>
@required
- (void)didPowerOn:(BOOL)isOn;
- (void)didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary <NSString *, id> *)advertisementData RSSI:(NSNumber *)RSSI;
@end
@interface BleLinkManager : NSObject
@property (weak, nonatomic) id <BleLinkManagerDelegate> delegate;
+ (instancetype)sharedInstance;
- (BOOL)startDiscover;
- (BOOL)stopDiscover;
- (BOOL)connectPeripheral:(CBPeripheral *)peripheral;
- (int)read:(char *)buffer size:(int)size;
- (BOOL)write:(const char *)buffer size:(int)size;
- (BOOL)disconnect;
@end