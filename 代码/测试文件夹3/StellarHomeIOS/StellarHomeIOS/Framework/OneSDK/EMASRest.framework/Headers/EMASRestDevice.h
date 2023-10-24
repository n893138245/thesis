#ifndef EMASRestDevice_h
#define EMASRestDevice_h
#import <sys/socket.h>
#import <sys/sysctl.h>
#import <net/if.h>
#import <net/if_dl.h>
#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>
#import "EMASRestDeviceInfo.h"
@interface EMASRestDevice : NSObject
+ (EMASRestDeviceInfo *)getDevice;
+ (NSString *)macAddress;
@end
#endif