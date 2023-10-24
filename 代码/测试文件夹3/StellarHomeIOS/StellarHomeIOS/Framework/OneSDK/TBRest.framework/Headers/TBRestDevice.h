#ifndef TBRestDevice_h
#define TBRestDevice_h
#import <sys/socket.h>
#import <sys/sysctl.h>
#import <net/if.h>
#import <net/if_dl.h>
#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>
#import "TBRestDeviceInfo.h"
@interface TBRestDevice : NSObject
+ (TBRestDeviceInfo *)getDevice;
+ (NSString *)macAddress;
@end
#endif