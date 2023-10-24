#import <Foundation/Foundation.h>
@interface FBAssociationManager : NSObject
+ (void)hook;
+ (void)unhook;
+ (nullable NSArray *)associationsForObject:(nullable id)object;
@end