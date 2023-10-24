#import "FBAllocationTrackerDefines.h"
#if _INTERNAL_FBAT_ENABLED
namespace FB { namespace AllocationTracker {
  void incrementAllocations(__unsafe_unretained id obj);
  void incrementDeallocations(__unsafe_unretained id obj);
} }
#endif