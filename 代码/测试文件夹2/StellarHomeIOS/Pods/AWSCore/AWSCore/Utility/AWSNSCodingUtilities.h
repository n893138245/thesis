#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN
@interface AWSNSCodingUtilities: NSObject
#pragma mark - Archive
+ (nullable NSData *)versionSafeArchivedDataWithRootObject:(id)obj
                                     requiringSecureCoding:(BOOL)requireSecureCoding
                                                     error:(NSError *__autoreleasing *)error;
#pragma mark - Unarchive
+ (nullable id)versionSafeUnarchivedObjectOfClass:(Class)cls
                                         fromData:(NSData *)data
                                            error:(NSError *__autoreleasing *)error;
+ (nullable id)versionSafeUnarchivedObjectOfClasses:(NSSet<Class> *)classes
                                           fromData:(NSData *)data
                                              error:(NSError *__autoreleasing *)error;
+ (nullable NSMutableDictionary *)versionSafeMutableDictionaryFromData:(NSData *)data
                                                                 error:(NSError *__autoreleasing *)error;
@end
NS_ASSUME_NONNULL_END