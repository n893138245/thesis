#import <Foundation/Foundation.h>
@class SSEBaseUser;
@interface SSEUserManager : NSObject
@property (nonatomic, copy) NSString *currentUserLinkId;
@property (nonatomic, strong, readonly) NSDictionary *users;
+ (instancetype)defaultManager;
- (void)addUser:(SSEBaseUser *)user;
- (void)removeUser:(SSEBaseUser *)user;
- (void)save;
@end