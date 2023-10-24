#import <Foundation/Foundation.h>
#ifdef __cplusplus
extern "C" {
#endif
@protocol FBObjectReference;
NSArray<id<FBObjectReference>> *_Nonnull FBGetClassReferences(__unsafe_unretained Class _Nullable aCls);
NSArray<id<FBObjectReference>> *_Nonnull FBGetObjectStrongReferences(id _Nullable obj,
                                                                     NSMutableDictionary<Class, NSArray<id<FBObjectReference>> *> *_Nullable layoutCache);
#ifdef __cplusplus
}
#endif