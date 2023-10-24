#import <Foundation/Foundation.h>
struct _block_byref_block;
@interface FBBlockStrongRelationDetector : NSObject
{
  void *forwarding;
  int flags;   
  int size;
  void (*byref_keep)(struct _block_byref_block *dst, struct _block_byref_block *src);
  void (*byref_dispose)(struct _block_byref_block *);
  void *captured[16];
}
@property (nonatomic, assign, getter=isStrong) BOOL strong;
- (oneway void)trueRelease;
- (void *)forwarding;
@end