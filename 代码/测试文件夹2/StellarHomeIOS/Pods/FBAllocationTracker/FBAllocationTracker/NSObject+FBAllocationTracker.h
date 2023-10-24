#import <Foundation/Foundation.h>
#import "FBAllocationTrackerDefines.h"
#if _INTERNAL_FBAT_ENABLED
@interface NSObject (FBAllocationTracker)
+ (nonnull id)fb_originalAlloc;
- (void)fb_originalDealloc;
+ (nonnull id)fb_newAlloc;
- (void)fb_newDealloc;
@end
#endif 