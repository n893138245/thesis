#import <Foundation/Foundation.h>
@class YYKeychainItem;
NS_ASSUME_NONNULL_BEGIN
@interface YYKeychain : NSObject
#pragma mark - Convenience method for keychain
+ (nullable NSString *)getPasswordForService:(NSString *)serviceName
                                     account:(NSString *)account
                                       error:(NSError **)error;
+ (nullable NSString *)getPasswordForService:(NSString *)serviceName
                                     account:(NSString *)account;
+ (BOOL)deletePasswordForService:(NSString *)serviceName account:(NSString *)account error:(NSError **)error;
+ (BOOL)deletePasswordForService:(NSString *)serviceName account:(NSString *)account;
+ (BOOL)setPassword:(NSString *)password
         forService:(NSString *)serviceName
            account:(NSString *)account
              error:(NSError **)error;
+ (BOOL)setPassword:(NSString *)password
         forService:(NSString *)serviceName
            account:(NSString *)account;
#pragma mark - Full query for keychain (SQL-like)
+ (BOOL)insertItem:(YYKeychainItem *)item error:(NSError **)error;
+ (BOOL)insertItem:(YYKeychainItem *)item;
+ (BOOL)updateItem:(YYKeychainItem *)item error:(NSError **)error;
+ (BOOL)updateItem:(YYKeychainItem *)item;
+ (BOOL)deleteItem:(YYKeychainItem *)item error:(NSError **)error;
+ (BOOL)deleteItem:(YYKeychainItem *)item;
+ (nullable YYKeychainItem *)selectOneItem:(YYKeychainItem *)item error:(NSError **)error;
+ (nullable YYKeychainItem *)selectOneItem:(YYKeychainItem *)item;
+ (nullable NSArray<YYKeychainItem *> *)selectItems:(YYKeychainItem *)item error:(NSError **)error;
+ (nullable NSArray<YYKeychainItem *> *)selectItems:(YYKeychainItem *)item;
@end
#pragma mark - Const
typedef NS_ENUM (NSUInteger, YYKeychainErrorCode) {
    YYKeychainErrorUnimplemented = 1, 
    YYKeychainErrorIO, 
    YYKeychainErrorOpWr, 
    YYKeychainErrorParam, 
    YYKeychainErrorAllocate, 
    YYKeychainErrorUserCancelled, 
    YYKeychainErrorBadReq, 
    YYKeychainErrorInternalComponent, 
    YYKeychainErrorNotAvailable, 
    YYKeychainErrorDuplicateItem, 
    YYKeychainErrorItemNotFound, 
    YYKeychainErrorInteractionNotAllowed, 
    YYKeychainErrorDecode, 
    YYKeychainErrorAuthFailed, 
};
typedef NS_ENUM (NSUInteger, YYKeychainAccessible) {
    YYKeychainAccessibleNone = 0, 
    YYKeychainAccessibleWhenUnlocked,
    YYKeychainAccessibleAfterFirstUnlock,
    YYKeychainAccessibleAlways,
    YYKeychainAccessibleWhenPasscodeSetThisDeviceOnly,
    YYKeychainAccessibleWhenUnlockedThisDeviceOnly,
    YYKeychainAccessibleAfterFirstUnlockThisDeviceOnly,
    YYKeychainAccessibleAlwaysThisDeviceOnly,
};
typedef NS_ENUM (NSUInteger, YYKeychainQuerySynchronizationMode) {
    YYKeychainQuerySynchronizationModeAny = 0,
    YYKeychainQuerySynchronizationModeNo,
    YYKeychainQuerySynchronizationModeYes,
} NS_AVAILABLE_IOS (7_0);
#pragma mark - Item
@interface YYKeychainItem : NSObject <NSCopying>
@property (nullable, nonatomic, copy) NSString *service; 
@property (nullable, nonatomic, copy) NSString *account; 
@property (nullable, nonatomic, copy) NSData *passwordData; 
@property (nullable, nonatomic, copy) NSString *password; 
@property (nullable, nonatomic, copy) id <NSCoding> passwordObject; 
@property (nullable, nonatomic, copy) NSString *label; 
@property (nullable, nonatomic, copy) NSNumber *type; 
@property (nullable, nonatomic, copy) NSNumber *creater; 
@property (nullable, nonatomic, copy) NSString *comment; 
@property (nullable, nonatomic, copy) NSString *descr; 
@property (nullable, nonatomic, readonly, strong) NSDate *modificationDate; 
@property (nullable, nonatomic, readonly, strong) NSDate *creationDate; 
@property (nullable, nonatomic, copy) NSString *accessGroup; 
@property (nonatomic) YYKeychainAccessible accessible; 
@property (nonatomic) YYKeychainQuerySynchronizationMode synchronizable NS_AVAILABLE_IOS(7_0); 
@end
NS_ASSUME_NONNULL_END