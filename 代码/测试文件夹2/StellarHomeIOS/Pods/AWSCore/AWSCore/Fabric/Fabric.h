#import <Foundation/Foundation.h>
#import "FABAttributes.h"
NS_ASSUME_NONNULL_BEGIN
@interface Fabric : NSObject
+ (instancetype)with:(NSArray *)kitClasses;
+ (instancetype)sharedSDK;
@property (nonatomic, assign) BOOL debug;
- (id)init FAB_UNAVAILABLE("Use +sharedSDK to retrieve the shared Fabric instance.");
@end
NS_ASSUME_NONNULL_END