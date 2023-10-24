#import <Foundation/Foundation.h>
@interface SSDKSession : NSObject
@property (assign, nonatomic, readonly) BOOL isCancelled;
@property (assign, nonatomic) NSInteger platformType;
- (void) cancel;
@end