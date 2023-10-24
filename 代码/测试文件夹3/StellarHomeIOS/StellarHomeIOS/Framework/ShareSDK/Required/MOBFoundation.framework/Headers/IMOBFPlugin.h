#import <Foundation/Foundation.h>
@protocol IMOBFPlugin <NSObject>
@required
- (void)load:(NSString *)key;
- (void)unload;
@end