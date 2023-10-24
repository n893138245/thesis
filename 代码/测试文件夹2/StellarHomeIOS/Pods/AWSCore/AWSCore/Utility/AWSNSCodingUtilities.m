#import "AWSCocoaLumberjack.h"
#import "AWSNSCodingUtilities.h"
@implementation AWSNSCodingUtilities
#pragma mark - Archive
+ (nullable NSData *)versionSafeArchivedDataWithRootObject:(id)obj
                                     requiringSecureCoding:(BOOL)requireSecureCoding
                                                     error:(NSError *__autoreleasing *)error {
    NSData *archivedData;
    if (@available(iOS 11, *)) {
        archivedData = [NSKeyedArchiver archivedDataWithRootObject:obj
                                             requiringSecureCoding:requireSecureCoding
                                                             error:error];
        if (error && *error) {
            AWSDDLogError(@"Error archiving object: %@", *error);
            return nil;
        }
    } else {
        archivedData = [NSKeyedArchiver archivedDataWithRootObject:obj];
    }
    return archivedData;
}
#pragma mark - Unarchive
+ (nullable id)versionSafeUnarchivedObjectOfClass:(Class)cls
                                         fromData:(NSData *)data
                                            error:(NSError *__autoreleasing *)error {
    id returnValue;
    if (@available(iOS 11, *)) {
        returnValue = [NSKeyedUnarchiver unarchivedObjectOfClass:cls
                                                        fromData:data
                                                           error:error];
        if (error && *error) {
            AWSDDLogError(@"Error unarchiving class `%@`: %@", cls, *error);
            return nil;
        }
    } else {
        returnValue = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    return returnValue;
}
+ (nullable id)versionSafeUnarchivedObjectOfClasses:(NSSet<Class> *)classes
                                           fromData:(NSData *)data
                                              error:(NSError *__autoreleasing *)error {
    id returnValue;
    if (@available(iOS 11, *)) {
        returnValue = [NSKeyedUnarchiver unarchivedObjectOfClasses:classes
                                                          fromData:data
                                                             error:error];
        if (error && *error) {
            AWSDDLogError(@"Error unarchiving data into allowed classes `%@`: %@", classes, *error);
            return nil;
        }
    } else {
        returnValue = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    return returnValue;
}
+ (NSMutableDictionary *)versionSafeMutableDictionaryFromData:(NSData *)data
                                                        error:(NSError *__autoreleasing *)error {
    NSMutableDictionary *returnValue;
    if (@available(iOS 11, *)) {
        NSSet *allowableClasses = [[NSSet alloc] initWithObjects:[NSMutableString class],
                                   [NSDictionary class],
                                   nil];
        NSDictionary *immutableDict = [AWSNSCodingUtilities versionSafeUnarchivedObjectOfClasses:allowableClasses
                                                                                        fromData:data
                                                                                           error:error];
        if (error && *error) {
            AWSDDLogError(@"Error unarchiving data into allowed classes `%@`: %@", allowableClasses, *error);
            return nil;
        }
        returnValue = [immutableDict mutableCopy];
    } else {
        returnValue = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    return returnValue;
}
@end