#import <Foundation/Foundation.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <netinet/in.h>
NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger, YYReachabilityStatus) {
    YYReachabilityStatusNone  = 0, 
    YYReachabilityStatusWWAN  = 1, 
    YYReachabilityStatusWiFi  = 2, 
};
typedef NS_ENUM(NSUInteger, YYReachabilityWWANStatus) {
    YYReachabilityWWANStatusNone  = 0, 
    YYReachabilityWWANStatus2G = 2, 
    YYReachabilityWWANStatus3G = 3, 
    YYReachabilityWWANStatus4G = 4, 
};
@interface YYReachability : NSObject
@property (nonatomic, readonly) SCNetworkReachabilityFlags flags;                           
@property (nonatomic, readonly) YYReachabilityStatus status;                                
@property (nonatomic, readonly) YYReachabilityWWANStatus wwanStatus NS_AVAILABLE_IOS(7_0);  
@property (nonatomic, readonly, getter=isReachable) BOOL reachable;                         
@property (nullable, nonatomic, copy) void (^notifyBlock)(YYReachability *reachability);
+ (instancetype)reachability;
+ (instancetype)reachabilityForLocalWifi DEPRECATED_MSG_ATTRIBUTE("unnecessary and potentially harmful");
+ (nullable instancetype)reachabilityWithHostname:(NSString *)hostname;
+ (nullable instancetype)reachabilityWithAddress:(const struct sockaddr *)hostAddress;
@end
NS_ASSUME_NONNULL_END