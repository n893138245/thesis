#ifndef TBRestConfiguration_h
#define TBRestConfiguration_h
#import <Foundation/Foundation.h>
@protocol TBRestReservesProviderProtocol <NSObject>
- (NSDictionary<NSString*, NSString*>*)reserveInfoDictionary;
@end
@interface TBRestConfiguration : NSObject
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