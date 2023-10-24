#import <mutex>
#import <unordered_map>
#import <unordered_set>
#import <vector>
#import <Foundation/Foundation.h>
#import "FBAllocationTrackerFunctors.h"
namespace FB { namespace AllocationTracker {
  typedef std::unordered_set<__unsafe_unretained id, ObjectHashFunctor, ObjectEqualFunctor> GenerationList;
  typedef std::unordered_map<Class, GenerationList, ClassHashFunctor, ClassEqualFunctor> GenerationMap;
  typedef std::unordered_map<Class, NSInteger, ClassHashFunctor, ClassEqualFunctor> GenerationSummary;
  class Generation {
  public:
    void add(__unsafe_unretained id object);
    void remove(__unsafe_unretained id object);
    GenerationSummary getSummary() const;
    std::vector<__weak id> instancesForClass(__unsafe_unretained Class aCls) const;
    Generation() = default;
    Generation(Generation&&) = default;
    Generation &operator=(Generation&&) = default;
    Generation(const Generation&) = delete;
    Generation &operator=(const Generation&) = delete;
  private:
    GenerationMap objects;
  };
} }