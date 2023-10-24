#import <Foundation/Foundation.h>
#import <FBRetainCycleDetector/FBObjectGraphConfiguration.h>
#ifdef __cplusplus
extern "C" {
#endif
NSArray<FBGraphEdgeFilterBlock> *_Nonnull FBGetStandardGraphEdgeFilters();
FBGraphEdgeFilterBlock _Nonnull FBFilterBlockWithObjectIvarRelation(Class _Nonnull aCls,
                                                                    NSString *_Nonnull ivarName);
FBGraphEdgeFilterBlock _Nonnull FBFilterBlockWithObjectToManyIvarsRelation(Class _Nonnull aCls,
                                                                           NSSet<NSString *> *_Nonnull ivarNames);
FBGraphEdgeFilterBlock _Nonnull FBFilterBlockWithObjectIvarObjectRelation(Class _Nonnull fromClass,
                                                                          NSString *_Nonnull ivarName,
                                                                          Class _Nonnull toClass);
#ifdef __cplusplus
}
#endif