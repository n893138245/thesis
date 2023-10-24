#import "QPUtilities.h"
#import "getgateway.h"
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>
#include <arpa/inet.h>
#import <ifaddrs.h>
#import <netinet/in.h>
#import <sys/socket.h>
#import <SystemConfiguration/CaptiveNetwork.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <sys/utsname.h>
//阿里
#import <AlicloudCrash/AlicloudCrashProvider.h>
#import <AlicloudHAUtil/AlicloudHAProvider.h>
#import <AlicloudAPM/AlicloudAPMProvider.h>

@implementation QPUtilities

+ (NSString *)broadcastIP {
  return @"255.255.255.255";

//    return @"192.168.2.255";
  NSString *address = @"error";
  struct ifaddrs *interfaces = NULL;
  struct ifaddrs *temp_addr = NULL;
  int success = 0;

  // retrieve the current interfaces - returns 0 on success
  success = getifaddrs(&interfaces);
  if (success == 0) {
    // Loop through linked list of interfaces
    temp_addr = interfaces;
    while (temp_addr != NULL) {
      if (temp_addr->ifa_addr->sa_family == AF_INET) {
        // Check if interface is en0 which is the wifi connection on the iPhone
        if ([[NSString stringWithUTF8String:temp_addr->ifa_name]
                isEqualToString:@"en0"]) {
          // Get NSString from C String //ifa_addr
          address = [NSString
              stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)
                                                  temp_addr->ifa_dstaddr)
                                                 ->sin_addr)];
        }
      }

      temp_addr = temp_addr->ifa_next;
    }
  }

  // Free memory
  freeifaddrs(interfaces);

    NSLog(@"nxs broadcast ip: %@", address);
  return address;
}

+ (NSString *)myIP {
  NSString *address = @"error";
  struct ifaddrs *interfaces = NULL;
  struct ifaddrs *temp_addr = NULL;
  int success = 0;

  // retrieve the current interfaces - returns 0 on success
  success = getifaddrs(&interfaces);
  if (success == 0) {
    // Loop through linked list of interfaces
    temp_addr = interfaces;
    while (temp_addr != NULL) {
      if (temp_addr->ifa_addr->sa_family == AF_INET) {
        // Check if interface is en0 which is the wifi connection on the iPhone
        if ([[NSString stringWithUTF8String:temp_addr->ifa_name]
                isEqualToString:@"en0"]) {
          // Get NSString from C String
          address =
              [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)
                                                            temp_addr->ifa_addr)
                                                           ->sin_addr)];
        }
      }

      temp_addr = temp_addr->ifa_next;
    }
  }

  // Free memory
  freeifaddrs(interfaces);

  return address;
}

+ (NSString *)gatewayIP {
  NSString *address = @"error";
  struct in_addr gatewayaddr;
  int r = getdefaultgateway(&(gatewayaddr.s_addr));
  if (r >= 0) {
    NSString *ipString =
        [NSString stringWithFormat:@"%s", inet_ntoa(gatewayaddr)];
    address = ipString;
  } else {
    NSLog(@"getdefaultgateway() failed");
  }
  return address;
}

+ (NSString *)SSID {
    NSArray *interfaceNames = CFBridgingRelease(CNCopySupportedInterfaces());
    NSLog(@"%s: Supported interfaces: %@", __func__, interfaceNames);

    NSDictionary *SSIDInfo;
    for (NSString *interfaceName in interfaceNames) {
        SSIDInfo = CFBridgingRelease(
                                     CNCopyCurrentNetworkInfo((__bridge CFStringRef)interfaceName));
        NSLog(@"%s: %@ => %@", __func__, interfaceName, SSIDInfo);

        BOOL isNotEmpty = (SSIDInfo.count > 0);
        if (isNotEmpty) {
            break;
        }
    }
    NSString *SSID = SSIDInfo[@"SSID"];
    return SSID;
}

+ (NSString *)randomStringWithLength:(NSUInteger)len {
  static NSString *letters =
      @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
  NSMutableString *randomString = [NSMutableString stringWithCapacity:len];
  for (NSUInteger i = 0; i < len; i++) {
    [randomString
        appendFormat:@"%C",
                     [letters
                         characterAtIndex:arc4random_uniform(
                                              (u_int32_t)[letters length])]];
  }
  return randomString;
}

+ (NSString *)randomIPv4Address {
  return [NSString stringWithFormat:@"%d.%d.%d.%d", arc4random() % UINT8_MAX,
                                    arc4random() % UINT8_MAX,
                                    arc4random() % UINT8_MAX,
                                    arc4random() % UINT8_MAX];
}

+ (NSString *)hexStringWithData:(unsigned char *)data ofLength:(NSUInteger)len {
  NSMutableString *tmp = [NSMutableString string];
  for (NSUInteger i = 0; i < len; i++)
    [tmp appendFormat:@"%02x", data[i]];
  return [NSString stringWithString:tmp];
}

+ (NSData *)RC4Encrypt:(NSData *)srcData withKey:(NSString *)key {
  char keyPtr[kCCKeySizeMaxRC4 + 1]; // room for terminator (unused)
  bzero(keyPtr, sizeof(keyPtr));     // fill with zeroes (for padding)

  // fetch key data
  [key getCString:keyPtr
        maxLength:sizeof(keyPtr)
         encoding:NSUTF8StringEncoding];

  NSUInteger dataLength = [srcData length];

  // See the doc: For block ciphers, the output size will always be less than or
  // equal to the input size plus the size of one block.
  // That's why we need to add the size of one block here
  size_t bufferSize = dataLength + kCCKeySizeMaxRC4;
  void *buffer = malloc(bufferSize);

  size_t numBytesEncrypted = 0;
  CCCryptorStatus cryptStatus = CCCrypt(
      kCCEncrypt, kCCAlgorithmRC4, kCCOptionPKCS7Padding | kCCOptionECBMode,
      keyPtr, kCCKeySizeMaxRC4, NULL /* initialization vector (optional) */,
      [srcData bytes], dataLength, /* input */
      buffer, bufferSize,          /* output */
      &numBytesEncrypted);
  if (cryptStatus == kCCSuccess) {
    // the returned NSData takes ownership of the buffer and will free it on
    // deallocation
    return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
  }

  free(buffer); // free the buffer;
  return nil;
}

+ (UIColor *) colorWithHexString:(NSString *)color alpha:(float)alpha {
    NSString * cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];

    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6) {
        NSLog(@"输入的16进制有误，不足6位！");
        return [UIColor clearColor];
    }

    NSRange range;
    range.location = 0;
    range.length = 2;

    // r
    NSString * rString = [cString substringWithRange:range];

    // g
    range.location = 2;
    NSString * gString = [cString substringWithRange:range];

    // b
    range.location = 4;
    NSString * bString = [cString substringWithRange:range];

    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];

    return [UIColor colorWithRed:((float)r / 255.0f)
                           green:((float)g / 255.0f)
                            blue:((float)b / 255.0f)
                           alpha:alpha];
} /* colorWithHexString */


+ (BOOL)validateEmail:(NSString *)candidate {
  NSString *emailRegex =
      @"(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"
      @"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
      @"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"
      @"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"
      @"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
      @"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
      @"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";
  NSPredicate *emailTest =
      [NSPredicate predicateWithFormat:@"SELF MATCHES[c] %@", emailRegex];

  return [emailTest evaluateWithObject:candidate];
}

#pragma 正则匹配手机号
+ (BOOL)validateNumber:(NSString *) telNumber
{
    NSString *pattern = @"^1+[3578]+\\d{9}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:telNumber];
    return isMatch;
}


+ (NSData *)cryptoRC4:(NSData *)data
                  key:(const char *)key
               keylen:(NSUInteger)keylen
            isEncrypt:(BOOL)isEncrypt {
  NSUInteger length = [data length];
  Byte *bytes = (Byte *)[data bytes];
  Byte outBytes[1024] = {0};
  size_t outSize = 0;

  CCCryptorRef refer = nil;
  CCCryptorCreate((isEncrypt ? kCCEncrypt : kCCDecrypt), kCCAlgorithmRC4,
                  kCCOptionPKCS7Padding, key, keylen, NULL, &refer);
  if (!refer) {
    [NSException raise:@"error occured when encrypt"
                format:@"error occured when encrypt"];
  }

  CCCryptorUpdate(refer, bytes, length, outBytes, sizeof(outBytes), &outSize);
  CCCryptorRelease(refer);
  return [NSData dataWithBytes:outBytes length:outSize];
}

+ (NSData *)getBcdDate {
  return [QPUtilities getBcdDate:[NSDate date]];
}

+ (NSData *)getBcdDate:(NSDate *)d {

  // Get that weekday value
  NSCalendar *gregorian = [[NSCalendar alloc]
      initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
  unsigned unitFlags = NSCalendarUnitWeekday;
  NSDateComponents *weekdayComponents =
      [gregorian components:unitFlags fromDate:d];
  uint8_t weekday = (uint8_t)[weekdayComponents weekday];
  weekday = weekday == 1 ? 7 : weekday - 1; // Mon = 1, Sun = 7
  NSString *weekdayString = [NSString stringWithFormat:@"%u", weekday];

  // Get the rest of fields
  NSDateFormatter *formatter;
  NSMutableString *dateString;

  formatter = [[NSDateFormatter alloc] init];
  [formatter setDateFormat:@"yyyyMMddeeHHmmss"];

  dateString = [[formatter stringFromDate:d] mutableCopy];
  //  NSLog(@"Date string = %@", dateString);

  // Replace weekday char
  NSRange weekdayRange = {9, 1};
  [dateString replaceCharactersInRange:weekdayRange withString:weekdayString];
  //  NSLog(@"Date string after weekday replacement = %@", dateString);

  NSData *bcdDate = [NSData dataFromHexString:dateString];

  //  NSLog(@"Date in BCD format:%@", bcdDate);

  return bcdDate;
}

#pragma mark - UIImage

+ (UIImage *)imageWithColor:(UIColor *)color {
  CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
  UIGraphicsBeginImageContext(rect.size);
  CGContextRef context = UIGraphicsGetCurrentContext();

  CGContextSetFillColorWithColor(context, [color CGColor]);
  CGContextFillRect(context, rect);

  UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();

  return image;
}

+ (NSString *)networkingStatesFromStatebar {
    // 状态栏是由当前app控制的，首先获取当前app
    UIApplication *app = [UIApplication sharedApplication];

    NSArray *children = [[[app valueForKeyPath:@"statusBar"] valueForKeyPath:@"foregroundView"] subviews];

    int type = 0;
    for (id child in children) {
        if ([child isKindOfClass:[NSClassFromString(@"UIStatusBarDataNetworkItemView") class]]) {
            type = [[child valueForKeyPath:@"dataNetworkType"] intValue];
        }
    }

    NSString *stateString = @"wifi";

    switch (type) {
        case 0:
            stateString = @"notReachable";
            break;

        case 1:
            stateString = @"2G";
            break;

        case 2:
            stateString = @"3G";
            break;

        case 3:
            stateString = @"4G";
            break;

        case 4:
            stateString = @"LTE";
            break;

        case 5:
            stateString = @"wifi";
            break;
            
        default:
            break;
    }
    
    return stateString;
}

/**
 *  压缩图片
 *
 *  @param image       需要压缩的图片
 *  @param fImageKBytes 希望压缩后的大小(以KB为单位)
 *
 */
+ (void)compressedImageFiles:(UIImage *)image
                     imageKB:(CGFloat)fImageKBytes
                  imageBlock:(void(^)(UIImage *image))block {

    __block UIImage *imageCope = image;
    CGFloat fImageBytes = fImageKBytes * 1024;//需要压缩的字节Byte

    __block NSData *uploadImageData = nil;

    uploadImageData = UIImagePNGRepresentation(imageCope);
    NSLog(@"图片压前缩成 %fKB",uploadImageData.length/1024.0);
    CGSize size = imageCope.size;
    CGFloat imageWidth = size.width;
    CGFloat imageHeight = size.height;

    if (uploadImageData.length > fImageBytes && fImageBytes >0) {

        dispatch_async(dispatch_queue_create("CompressedImage", DISPATCH_QUEUE_SERIAL), ^{

            /* 宽高的比例 **/
            CGFloat ratioOfWH = imageWidth/imageHeight;
            /* 压缩率 **/
            CGFloat compressionRatio = fImageBytes/uploadImageData.length;
            /* 宽度或者高度的压缩率 **/
            CGFloat widthOrHeightCompressionRatio = sqrt(compressionRatio);

            CGFloat dWidth   = imageWidth *widthOrHeightCompressionRatio;
            CGFloat dHeight  = imageHeight*widthOrHeightCompressionRatio;
            if (ratioOfWH >0) { /* 宽 > 高,说明宽度的压缩相对来说更大些 **/
                dHeight = dWidth/ratioOfWH;
            }else {
                dWidth  = dHeight*ratioOfWH;
            }

            imageCope = [self drawWithWithImage:imageCope width:dWidth height:dHeight];
            uploadImageData = UIImagePNGRepresentation(imageCope);

            NSLog(@"当前的图片已经压缩成 %fKB",uploadImageData.length/1024.0);
            //微调
            NSInteger compressCount = 0;
            /* 控制在 1M 以内**/
            while (fabs(uploadImageData.length - fImageBytes) > 1024) {
                /* 再次压缩的比例**/
                CGFloat nextCompressionRatio = 0.9;

                if (uploadImageData.length > fImageBytes) {
                    dWidth = dWidth*nextCompressionRatio;
                    dHeight= dHeight*nextCompressionRatio;
                }else {
                    dWidth = dWidth/nextCompressionRatio;
                    dHeight= dHeight/nextCompressionRatio;
                }

                imageCope = [QPUtilities drawWithWithImage:imageCope width:dWidth height:dHeight];
                uploadImageData = UIImagePNGRepresentation(imageCope);

                /*防止进入死循环**/
                compressCount ++;
                if (compressCount == 10) {
                    break;
                }

            }

            NSLog(@"图片已经压缩成 %fKB",uploadImageData.length/1024.0);
            imageCope = [[UIImage alloc] initWithData:uploadImageData];

            dispatch_sync(dispatch_get_main_queue(), ^{
                block(imageCope);
            });
        });
    }
    else
    {
        block(imageCope);
    }
}

/* 根据 dWidth dHeight 返回一个新的image**/
+ (UIImage *)drawWithWithImage:(UIImage *)imageCope width:(CGFloat)dWidth height:(CGFloat)dHeight{

    UIGraphicsBeginImageContext(CGSizeMake(dWidth, dHeight));
    [imageCope drawInRect:CGRectMake(0, 0, dWidth, dHeight)];
    imageCope = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageCope;
    
}


+ (NSString*)iphoneType {

    //需要导入头文件：#import <sys/utsname.h>

    struct utsname systemInfo;

    uname(&systemInfo);

    NSString*platform = [NSString stringWithCString: systemInfo.machine encoding:NSASCIIStringEncoding];
    if([platform isEqualToString:@"iPhone1,1"])
        return@"iPhone 2G";
    if([platform isEqualToString:@"iPhone1,2"])
        return@"iPhone 3G";

    if([platform isEqualToString:@"iPhone2,1"])
        return@"iPhone 3GS";

    if([platform isEqualToString:@"iPhone3,1"])
        return@"iPhone 4";

    if([platform isEqualToString:@"iPhone3,2"])
        return@"iPhone 4";
    if([platform isEqualToString:@"iPhone3,3"])
        return@"iPhone 4";

    if([platform isEqualToString:@"iPhone4,1"])
        return@"iPhone 4S";

    if([platform isEqualToString:@"iPhone5,1"])
        return@"iPhone 5";

    if([platform isEqualToString:@"iPhone5,2"])
        return@"iPhone 5";

    if([platform isEqualToString:@"iPhone5,3"])
        return@"iPhone 5c";

    if([platform isEqualToString:@"iPhone5,4"])
        return@"iPhone 5c";

    if([platform isEqualToString:@"iPhone6,1"])
        return@"iPhone 5s";

    if([platform isEqualToString:@"iPhone6,2"])
        return@"iPhone 5s";

    if([platform isEqualToString:@"iPhone7,1"])
        return@"iPhone 6 Plus";

    if([platform isEqualToString:@"iPhone7,2"])
        return@"iPhone 6";

    if([platform isEqualToString:@"iPhone8,1"])
        return@"iPhone 6s";

    if([platform isEqualToString:@"iPhone8,2"])
        return@"iPhone 6s Plus";

    if([platform isEqualToString:@"iPhone8,4"])
        return@"iPhone SE";

    if([platform isEqualToString:@"iPhone9,1"])
        return@"iPhone 7";

    if([platform isEqualToString:@"iPhone9,2"])
        return@"iPhone 7 Plus";

    if([platform isEqualToString:@"iPhone10,1"])
        return@"iPhone 8";

    if([platform isEqualToString:@"iPhone10,4"])
        return@"iPhone 8";

    if([platform isEqualToString:@"iPhone10,2"])
        return@"iPhone 8 Plus";

    if([platform isEqualToString:@"iPhone10,5"])
        return@"iPhone 8 Plus";

    if([platform isEqualToString:@"iPhone10,3"])
        return@"iPhone X";

    if([platform isEqualToString:@"iPhone10,6"])
        return@"iPhone X";

    if([platform isEqualToString:@"iPod1,1"])
        return@"iPod Touch 1G";

    if([platform isEqualToString:@"iPod2,1"])
        return@"iPod Touch 2G";

    if([platform isEqualToString:@"iPod3,1"])
        return@"iPod Touch 3G";

    if([platform isEqualToString:@"iPod4,1"])
        return@"iPod Touch 4G";

    if([platform isEqualToString:@"iPod5,1"])
        return@"iPod Touch 5G";

    if([platform isEqualToString:@"iPad1,1"])
        return@"iPad 1G";

    if([platform isEqualToString:@"iPad2,1"])
        return@"iPad 2";

    if([platform isEqualToString:@"iPad2,2"])
        return@"iPad 2";

    if([platform isEqualToString:@"iPad2,3"])
        return@"iPad 2";

    if([platform isEqualToString:@"iPad2,4"])
        return@"iPad 2";

    if([platform isEqualToString:@"iPad2,5"])
        return@"iPad Mini 1G";

    if([platform isEqualToString:@"iPad2,6"])
        return@"iPad Mini 1G";

    if([platform isEqualToString:@"iPad2,7"])
        return@"iPad Mini 1G";

    if([platform isEqualToString:@"iPad3,1"])
        return@"iPad 3";

    if([platform isEqualToString:@"iPad3,2"])
        return@"iPad 3";

    if([platform isEqualToString:@"iPad3,3"])
        return@"iPad 3";

    if([platform isEqualToString:@"iPad3,4"])
        return@"iPad 4";

    if([platform isEqualToString:@"iPad3,5"])
        return@"iPad 4";

    if([platform isEqualToString:@"iPad3,6"])
        return@"iPad 4";

    if([platform isEqualToString:@"iPad4,1"])
        return@"iPad Air";

    if([platform isEqualToString:@"iPad4,2"])
        return@"iPad Air";

    if([platform isEqualToString:@"iPad4,3"])
        return@"iPad Air";

    if([platform isEqualToString:@"iPad4,4"])
        return@"iPad Mini 2G";

    if([platform isEqualToString:@"iPad4,5"])
        return@"iPad Mini 2G";

    if([platform isEqualToString:@"iPad4,6"])
        return@"iPad Mini 2G";

    if([platform isEqualToString:@"iPad4,7"])
        return@"iPad Mini 3";

    if([platform isEqualToString:@"iPad4,8"])
        return@"iPad Mini 3";

    if([platform isEqualToString:@"iPad4,9"])
        return@"iPad Mini 3";

    if([platform isEqualToString:@"iPad5,1"])
        return@"iPad Mini 4";

    if([platform isEqualToString:@"iPad5,2"])
        return@"iPad Mini 4";

    if([platform isEqualToString:@"iPad5,3"])
        return@"iPad Air 2";

    if([platform isEqualToString:@"iPad5,4"])
        return@"iPad Air 2";

    if([platform isEqualToString:@"iPad6,3"])
        return@"iPad Pro 9.7";

    if([platform isEqualToString:@"iPad6,4"])
        return@"iPad Pro 9.7";

    if([platform isEqualToString:@"iPad6,7"])
        return@"iPad Pro 12.9";

    if([platform isEqualToString:@"iPad6,8"])
        return@"iPad Pro 12.9";

    if([platform isEqualToString:@"i386"])
        return@"iPhone Simulator";

    if([platform isEqualToString:@"x86_64"])
        return@"iPhone Simulator";

    return platform;

}


+ (void)showNormalAlertWithTitle:(NSString *)title
                         message:(NSString *)message
                       doneTitle:(NSString*)doneTitle
                     cancelTitle:(nullable NSString * )cancelTitle
                          target:(UIViewController *)tagetVC
                      doneAction:(nullable void (^)(void))doneActionBlock{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:doneTitle style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        if (doneActionBlock != nil){
            doneActionBlock();
        }
    }]];
    if (cancelTitle != nil) {
        [alert addAction:[UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:nil]];
    }
    [tagetVC presentViewController:alert animated:YES completion:nil];

}


+ (void)initializeAliSDK{
//    let appVersion = "\(AppAssistance.appVersion())(\(AppAssistance.appBuildVersion())"
    
//    AlicloudCrashProvider.init().autoInit(withAppVersion: appVersion, channel: "ios", nick: "")
//    AlicloudAPMProvider.init().autoInit(withAppVersion: appVersion, channel: "ios", nick: "")
//    AlicloudHAProvider.start()
    
    NSString * appV = [NSString stringWithFormat:@"%@(%@)", NSBundle.mainBundle.infoDictionary[@"CFBundleShortVersionString"], NSBundle.mainBundle.infoDictionary[@"CFBundleVersion"]];

    [[AlicloudCrashProvider alloc] autoInitWithAppVersion:appV channel:@"ios" nick:@"test"];
    [[AlicloudAPMProvider alloc] autoInitWithAppVersion:appV channel:@"ios" nick:@"test"];
    [AlicloudHAProvider start];
}



@end
