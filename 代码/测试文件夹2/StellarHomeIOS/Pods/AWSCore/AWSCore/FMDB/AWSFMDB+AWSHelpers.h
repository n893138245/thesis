#import <AWSCore/AWSCore.h>
#import "AWSFMDatabasePool.h"
#import "AWSFMDatabaseQueue.h"
NS_ASSUME_NONNULL_BEGIN
@interface AWSFMDatabaseQueue (AWSHelpers)
+ (instancetype)serialDatabaseQueueWithPath:(NSString*)aPath;
@end
@interface AWSFMDatabasePool (AWSHelpers)
+ (instancetype)serialDatabasePoolWithPath:(NSString*)aPath;
@end
NS_ASSUME_NONNULL_END