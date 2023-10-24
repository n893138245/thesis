#ifndef EMASRestConfiguration_h
#define EMASRestConfiguration_h
#import <Foundation/Foundation.h>
@protocol EMASRestReservesProviderProtocol <NSObject>
- (NSDictionary<NSString*, NSString*>*)reserveInfoDictionary;
@end
@interface EMASRestConfiguration : NSObject
@property(nonatomic, copy) NSString * channel;
@property(nonatomic, copy) NSString * appkey;
@property(nonatomic, copy) NSString * secret;
@property(nonatomic, copy) NSString * userId;
@property(nonatomic, copy) NSString * usernick;
@property(nonatomic, copy) NSString * appVersion;
@property(nonatomic, copy) NSString * country;
@property(nonatomic, copy) NSString * dataUploadScheme;     
@property(nonatomic, copy) NSString * dataUploadHost;       
@end
#endif 