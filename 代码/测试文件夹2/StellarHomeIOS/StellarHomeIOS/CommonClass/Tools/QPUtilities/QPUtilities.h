#import "NSData+CRC32.h"
#import "NSData+Conversion.h"
#import "NSData+NSData_AES.h"
#import <Foundation/Foundation.h>
#import <TargetConditionals.h>
#if TARGET_OS_IPHONE
#import "UIColor+Expanded.h"
#endif
@interface QPUtilities : NSObject
#pragma mark - Wi-Fi
+ (NSString *)broadcastIP;
+ (NSString *)gatewayIP;
+ (NSString *)myIP;
+ (NSString *)networkingStatesFromStatebar;
+ (NSString*)iphoneType;
+ (NSString *)SSID;
#pragma mark - NSString
+ (NSString *)randomStringWithLength:(NSUInteger)len;
+ (NSString *)randomIPv4Address;
+ (NSString *)hexStringWithData:(unsigned char *)data ofLength:(NSUInteger)len;
+ (BOOL)validateEmail:(NSString *)candidate;
+ (BOOL)validateNumber:(NSString *) telNumber;
#pragma mark - Crypto
+ (NSData *)cryptoRC4:(NSData *)data
                  key:(const char *)key
               keylen:(NSUInteger)keylen
            isEncrypt:(BOOL)isEncrypt;
+ (NSData *)getBcdDate;
+ (NSData *)getBcdDate:(NSDate *)d;
#pragma mark - UIImage
+ (UIImage *)imageWithColor:(UIColor *)color;
+ (UIImage *)drawWithWithImage:(UIImage *)imageCope width:(CGFloat)dWidth height:(CGFloat)dHeight;
+ (void)compressedImageFiles:(UIImage *)image
                     imageKB:(CGFloat)fImageKBytes
                  imageBlock:(void(^)(UIImage *image))block;
#pragma mark - UIColor
+ (UIColor *) colorWithHexString:(NSString *)color alpha:(float)alpha;
#pragma mark - Alert
+ (void)showNormalAlertWithTitle:(NSString *)title
                         message:(NSString *)message
                       doneTitle:(NSString*)doneTitle
                     cancelTitle:(nullable NSString * )cancelTitle
                          target:(UIViewController *)tagetVC
                      doneAction:(nullable void (^)(void))doneActionBlock;
+ (void)initializeAliSDK;
@end