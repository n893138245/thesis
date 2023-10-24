#import <Foundation/Foundation.h>
@class NetworkConfigInfo;
@protocol LinkManager <NSObject>
@required
- (BOOL)connect:(NetworkConfigInfo *)info;
- (int)read:(char *)buffer size:(int)size;
- (BOOL)write:(const char *)buffer size:(int)size;
- (BOOL)disconnect;
@end