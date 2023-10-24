#import "FBAllocationTrackerSummary.h"
@implementation FBAllocationTrackerSummary
- (instancetype)initWithAllocations:(NSUInteger)allocations
                      deallocations:(NSUInteger)deallocations
                       aliveObjects:(NSInteger)aliveObjects
                          className:(NSString *)className
                       instanceSize:(NSUInteger)instanceSize
{
  if ((self = [super init])) {
    _allocations = allocations;
    _deallocations = deallocations;
    _aliveObjects = aliveObjects;
    _className = className;
    _instanceSize = instanceSize;
  }
  return self;
}
@end