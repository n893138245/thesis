#import <Foundation/Foundation.h>
@interface AliHAPubCenter : NSObject
+ (void)publish:(NSString*)bizId properties:(NSDictionary<NSString*, NSString*>*)properties;
+ (void)publishABTest:(NSString*)bizId properties:(NSDictionary<NSString*, NSString*>*)properties;
@end