#ifndef AlicloudIPv6Adapter_h
#define AlicloudIPv6Adapter_h
#import <Foundation/Foundation.h>
@interface AlicloudIPv6Adapter : NSObject
+ (instancetype)getInstance;
- (BOOL)isIPv6OnlyNetwork;
- (BOOL)reResolveIPv6OnlyStatus;
- (NSString *)handleIpv4Address:(NSString *)addr;
- (BOOL)isIPv4Address:(NSString *)addr;
- (BOOL)isIPv6Address:(NSString *)addr;
@end
#endif 