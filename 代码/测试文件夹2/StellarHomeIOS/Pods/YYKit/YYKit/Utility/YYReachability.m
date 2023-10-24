#import "YYReachability.h"
#import <objc/message.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
static YYReachabilityStatus YYReachabilityStatusFromFlags(SCNetworkReachabilityFlags flags, BOOL allowWWAN) {
    if ((flags & kSCNetworkReachabilityFlagsReachable) == 0) {
        return YYReachabilityStatusNone;
    }
    if ((flags & kSCNetworkReachabilityFlagsConnectionRequired) &&
        (flags & kSCNetworkReachabilityFlagsTransientConnection)) {
        return YYReachabilityStatusNone;
    }
    if ((flags & kSCNetworkReachabilityFlagsIsWWAN) && allowWWAN) {
        return YYReachabilityStatusWWAN;
    }
    return YYReachabilityStatusWiFi;
}
static void YYReachabilityCallback(SCNetworkReachabilityRef target, SCNetworkReachabilityFlags flags, void *info) {
    YYReachability *self = ((__bridge YYReachability *)info);
    if (self.notifyBlock) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.notifyBlock(self);
        });
    }
}
@interface YYReachability ()
@property (nonatomic, assign) SCNetworkReachabilityRef ref;
@property (nonatomic, assign) BOOL scheduled;
@property (nonatomic, assign) BOOL allowWWAN;
@property (nonatomic, strong) CTTelephonyNetworkInfo *networkInfo;
@end
@implementation YYReachability
+ (dispatch_queue_t)sharedQueue {
    static dispatch_queue_t queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        queue = dispatch_queue_create("com.ibireme.yykit.reachability", DISPATCH_QUEUE_SERIAL);
    });
    return queue;
}
- (instancetype)init {
    struct sockaddr_in zero_addr;
    bzero(&zero_addr, sizeof(zero_addr));
    zero_addr.sin_len = sizeof(zero_addr);
    zero_addr.sin_family = AF_INET;
    SCNetworkReachabilityRef ref = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, (const struct sockaddr *)&zero_addr);
    return [self initWithRef:ref];
}
- (instancetype)initWithRef:(SCNetworkReachabilityRef)ref {
    if (!ref) return nil;
    self = super.init;
    if (!self) return nil;
    _ref = ref;
    _allowWWAN = YES;
    if (NSFoundationVersionNumber >= NSFoundationVersionNumber_iOS_7_0) {
        _networkInfo = [CTTelephonyNetworkInfo new];
    }
    return self;
}
- (void)dealloc {
    self.notifyBlock = nil;
    self.scheduled = NO;
    CFRelease(self.ref);
}
- (void)setScheduled:(BOOL)scheduled {
    if (_scheduled == scheduled) return;
    _scheduled = scheduled;
    if (scheduled) {
        SCNetworkReachabilityContext context = { 0, (__bridge void *)self, NULL, NULL, NULL };
        SCNetworkReachabilitySetCallback(self.ref, YYReachabilityCallback, &context);
        SCNetworkReachabilitySetDispatchQueue(self.ref, [self.class sharedQueue]);
    } else {
        SCNetworkReachabilitySetDispatchQueue(self.ref, NULL);
    }
}
- (SCNetworkReachabilityFlags)flags {
    SCNetworkReachabilityFlags flags = 0;
    SCNetworkReachabilityGetFlags(self.ref, &flags);
    return flags;
}
- (YYReachabilityStatus)status {
    return YYReachabilityStatusFromFlags(self.flags, self.allowWWAN);
}
- (YYReachabilityWWANStatus)wwanStatus {
    if (!self.networkInfo) return YYReachabilityWWANStatusNone;
    NSString *status = self.networkInfo.currentRadioAccessTechnology;
    if (!status) return YYReachabilityWWANStatusNone;
    static NSDictionary *dic;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dic = @{CTRadioAccessTechnologyGPRS : @(YYReachabilityWWANStatus2G),  
                CTRadioAccessTechnologyEdge : @(YYReachabilityWWANStatus2G),  
                CTRadioAccessTechnologyWCDMA : @(YYReachabilityWWANStatus3G), 
                CTRadioAccessTechnologyHSDPA : @(YYReachabilityWWANStatus3G), 
                CTRadioAccessTechnologyHSUPA : @(YYReachabilityWWANStatus3G), 
                CTRadioAccessTechnologyCDMA1x : @(YYReachabilityWWANStatus3G), 
                CTRadioAccessTechnologyCDMAEVDORev0 : @(YYReachabilityWWANStatus3G),
                CTRadioAccessTechnologyCDMAEVDORevA : @(YYReachabilityWWANStatus3G),
                CTRadioAccessTechnologyCDMAEVDORevB : @(YYReachabilityWWANStatus3G),
                CTRadioAccessTechnologyeHRPD : @(YYReachabilityWWANStatus3G),
                CTRadioAccessTechnologyLTE : @(YYReachabilityWWANStatus4G)}; 
    });
    NSNumber *num = dic[status];
    if (num) return num.unsignedIntegerValue;
    else return YYReachabilityWWANStatusNone;
}
- (BOOL)isReachable {
    return self.status != YYReachabilityStatusNone;
}
+ (instancetype)reachability {
    return self.new;
}
+ (instancetype)reachabilityForLocalWifi {
    struct sockaddr_in localWifiAddress;
    bzero(&localWifiAddress, sizeof(localWifiAddress));
    localWifiAddress.sin_len = sizeof(localWifiAddress);
    localWifiAddress.sin_family = AF_INET;
    localWifiAddress.sin_addr.s_addr = htonl(IN_LINKLOCALNETNUM);
    YYReachability *one = [self reachabilityWithAddress:(const struct sockaddr *)&localWifiAddress];
    one.allowWWAN = NO;
    return one;
}
+ (instancetype)reachabilityWithHostname:(NSString *)hostname {
    SCNetworkReachabilityRef ref = SCNetworkReachabilityCreateWithName(NULL, [hostname UTF8String]);
    return [[self alloc] initWithRef:ref];
}
+ (instancetype)reachabilityWithAddress:(const struct sockaddr *)hostAddress {
    SCNetworkReachabilityRef ref = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, (const struct sockaddr *)hostAddress);
    return [[self alloc] initWithRef:ref];
}
- (void)setNotifyBlock:(void (^)(YYReachability *reachability))notifyBlock {
    _notifyBlock = [notifyBlock copy];
    self.scheduled = (self.notifyBlock != nil);
}
@end