#import <Foundation/Foundation.h>
@interface ABSUtil : NSObject
+ (void)setLogger:(void (^)(NSString *))logger;
+ (void)Logger:(NSString *)log;
+ (BOOL)isValidString:(id)notValidString;
+ (BOOL)isWhiteListClass:(Class)class;
+ (void)deleteCacheWithfilePathsToRemove:(NSArray *)filePathsToRemove;
@end