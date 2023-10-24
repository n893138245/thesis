#import <mutex>
#import <unordered_map>
#import <vector>
#import <Foundation/Foundation.h>
#import "FBAllocationTrackerGeneration.h"
namespace FB { namespace AllocationTracker {
  typedef std::vector<GenerationSummary> FullGenerationSummary;
  class GenerationManager {
  public:
    void markGeneration();
    void addObject(__unsafe_unretained id object);
    void removeObject(__unsafe_unretained id object);
    std::vector<__weak id> instancesOfClassInGeneration(__unsafe_unretained Class aCls,
                                                 size_t generationIndex);
    std::vector<__weak id> instancesOfClassInLastGeneration(__unsafe_unretained Class aCls);
    FullGenerationSummary summary() const;
  private:
    std::vector<__weak id> unsafeInstancesOfClassInGeneration(__unsafe_unretained Class aCls,
                                                              size_t generationIndex);
    std::unordered_map<__unsafe_unretained id, NSInteger, ObjectHashFunctor, ObjectEqualFunctor> generationMapping;
    std::vector<Generation> generations;
  };
} }