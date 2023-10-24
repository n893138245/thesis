#import <Foundation/Foundation.h>
@interface SSERestoreScene : NSObject
@property (nonatomic, copy, readonly, nullable) NSString *path;
@property (nonatomic, copy, readonly, nullable) NSDictionary *params;
@property (nonatomic, copy, readonly, nullable) NSString *className;
@end