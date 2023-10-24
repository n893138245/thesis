#import <unordered_map>
#import <Foundation/Foundation.h>
#import "FBAllocationTrackerDefines.h"
#import "FBAllocationTrackerFunctors.h"
#import "FBAllocationTrackerGenerationManager.h"
#if _INTERNAL_FBAT_ENABLED
namespace FB { namespace AllocationTracker {
  struct SingleClassSummary {
    NSUInteger allocations;
    NSUInteger deallocations;
    NSUInteger instanceSize;
  };
  typedef std::unordered_map<Class, SingleClassSummary, ClassHashFunctor, ClassEqualFunctor> AllocationSummary;
  AllocationSummary allocationTrackerSummary();
  void beginTracking();
  void endTracking();
  bool isTracking();
  void enableGenerations();
  void disableGenerations();
  void markGeneration();
  FullGenerationSummary generationSummary();
  std::vector<__unsafe_unretained Class> trackedClasses();
  NSArray *instancesOfClasses(NSArray *classes);
  std::vector<__weak id> instancesOfClassForGeneration(__unsafe_unretained Class aCls,
                                                       NSInteger generationIndex);
} }
#endif 