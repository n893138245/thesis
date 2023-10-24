#import <Foundation/Foundation.h>
@interface MOBFJson : NSObject
+ (id)objectFromJSONString:(NSString *)jsonString;
+ (id)objectFromJSONData:(NSData *)jsonData;
+ (NSString *)jsonStringFromObject:(id)object;
+ (NSString *)jsonStringFromObject:(id)object serializeUnsupportedClassesUsingBlock:(id(^)(id object))block;
+ (NSData *)jsonDataFromObject:(id)object;
+ (NSData *)jsonDataFromObject:(id)object serializeUnsupportedClassesUsingBlock:(id(^)(id object))block;
@end