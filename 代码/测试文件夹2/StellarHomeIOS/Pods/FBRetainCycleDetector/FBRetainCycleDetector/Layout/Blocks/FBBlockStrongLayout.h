#import <Foundation/Foundation.h>
#ifdef __cplusplus
extern "C" {
#endif
NSArray *_Nullable FBGetBlockStrongReferences(void *_Nonnull block);
BOOL FBObjectIsBlock(void *_Nullable object);
#ifdef __cplusplus
}
#endif