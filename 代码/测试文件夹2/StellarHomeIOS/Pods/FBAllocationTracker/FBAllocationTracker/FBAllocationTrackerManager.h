#import <Foundation/Foundation.h>
#import "FBAllocationTrackerDefines.h"
#ifdef __cplusplus
extern "C" {
#endif
BOOL FBIsFBATEnabledInThisBuild(void);
#ifdef __cplusplus
}
#endif
@class FBAllocationTrackerSummary;
@interface FBAllocationTrackerManager : NSObject
+ (nullable instancetype)sharedManager;
- (void)startTrackingAllocations;
- (void)stopTrackingAllocations;
- (BOOL)isAllocationTrackerEnabled;
- (nullable NSArray<FBAllocationTrackerSummary *> *)currentAllocationSummary;
- (void)enableGenerations;
- (void)disableGenerations;
- (void)markGeneration;
- (nullable NSArray<NSArray<FBAllocationTrackerSummary *> *> *)currentSummaryForGenerations;
- (nullable NSArray *)instancesForClass:(nonnull __unsafe_unretained Class)aCls
                           inGeneration:(NSInteger)generation;
- (nullable NSArray *)instancesOfClasses:(nonnull NSArray *)classes;
- (nullable NSSet<Class> *)trackedClasses;
@end