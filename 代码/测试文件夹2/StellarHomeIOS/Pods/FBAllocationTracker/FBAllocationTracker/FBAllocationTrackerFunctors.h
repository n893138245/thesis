#import <Foundation/Foundation.h>
namespace FB { namespace AllocationTracker {
  struct ObjectHashFunctor {
    size_t operator()(const __unsafe_unretained id key) const {
      return (size_t)(key);
    }
  };
  struct ObjectEqualFunctor {
    bool operator()(const __unsafe_unretained id left,
                    const __unsafe_unretained id right) const {
      return left == right;
    }
  };
  struct ClassHashFunctor {
    size_t operator()(const Class key) const {
      return (size_t)(key);
    }
  };
  struct ClassEqualFunctor {
    bool operator()(const Class left, const Class right) const {
      return left == right;
    }
  };
} }