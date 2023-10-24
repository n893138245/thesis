#import <Foundation/Foundation.h>
extern NSString *const MOBFApplicationCrashNotif;
@interface MOBFNotificationCenter : NSObject
+ (void)addObserver:(NSObject *)observer
           selector:(SEL)selector
               name:(NSString *)name
             object:(id)object;
+ (void)removeObserver:(NSObject *)observer;
+ (void)removeObserver:(NSObject *)observer
                  name:(NSString *)name
                object:(id)object;
@end