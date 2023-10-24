#ifndef AlicloudHTTPDNSMini_h
#define AlicloudHTTPDNSMini_h
#define HTTPDNSMINI_RESOLVED_NOTIFY @"HTTPDNSMiniResolvedNotify"
@interface AlicloudHTTPDNSMini : NSObject
+ (AlicloudHTTPDNSMini *)sharedInstance;
- (NSArray *)getIpsByHostAsync:(NSString *)host;
- (void)setPreResolveHosts:(NSArray *)hosts;
@end
#endif 