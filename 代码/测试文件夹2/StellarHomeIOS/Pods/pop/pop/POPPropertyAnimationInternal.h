#import "POPAnimationInternal.h"
#import "POPPropertyAnimation.h"
static void clampValue(CGFloat &value, CGFloat fromValue, CGFloat toValue, NSUInteger clamp)
{
  BOOL increasing = (toValue > fromValue);
  if ((kPOPAnimationClampStart & clamp) &&
      ((increasing && (value < fromValue)) || (!increasing && (value > fromValue)))) {
    value = fromValue;
  }
  if ((kPOPAnimationClampEnd & clamp) &&
      ((increasing && (value > toValue)) || (!increasing && (value < toValue)))) {
    value = toValue;
  }
}
struct _POPPropertyAnimationState : _POPAnimationState
{
  POPAnimatableProperty *property;
  POPValueType valueType;
  NSUInteger valueCount;
  VectorRef fromVec;
  VectorRef toVec;
  VectorRef currentVec;
  VectorRef previousVec;
  VectorRef previous2Vec;
  VectorRef velocityVec;
  VectorRef originalVelocityVec;
  VectorRef distanceVec;
  CGFloat roundingFactor;
  NSUInteger clampMode;
  NSArray *progressMarkers;
  POPProgressMarker *progressMarkerState;
  NSUInteger progressMarkerCount;
  NSUInteger nextProgressMarkerIdx;
  CGFloat dynamicsThreshold;
  _POPPropertyAnimationState(id __unsafe_unretained anim) : _POPAnimationState(anim),
  property(nil),
  valueType((POPValueType)0),
  valueCount(0),
  fromVec(nullptr),
  toVec(nullptr),
  currentVec(nullptr),
  previousVec(nullptr),
  previous2Vec(nullptr),
  velocityVec(nullptr),
  originalVelocityVec(nullptr),
  distanceVec(nullptr),
  roundingFactor(0),
  clampMode(0),
  progressMarkers(nil),
  progressMarkerState(nil),
  progressMarkerCount(0),
  nextProgressMarkerIdx(0),
  dynamicsThreshold(0)
  {
    type = kPOPAnimationBasic;
  }
  ~_POPPropertyAnimationState()
  {
    if (progressMarkerState) {
      free(progressMarkerState);
      progressMarkerState = NULL;
    }
  }
  bool canProgress() {
    return hasValue();
  }
  bool shouldRound() {
    return 0 != roundingFactor;
  }
  bool hasValue() {
    return 0 != valueCount;
  }
  bool isDone() {
    if (_POPAnimationState::isDone()) {
      return true;
    }
    if (!hasValue() && !isCustom()) {
      return true;
    }
    return false;
  }
  VectorRef currentValue() {
    VectorRef vec = VectorRef(Vector::new_vector(currentVec.get()));
    if (shouldRound()) {
      vec->subRound(1 / roundingFactor);
    }
      return vec;
  }
  void resetProgressMarkerState()
  {
    for (NSUInteger idx = 0; idx < progressMarkerCount; idx++)
      progressMarkerState[idx].reached = false;
    nextProgressMarkerIdx = 0;
  }
  void updatedProgressMarkers()
  {
    if (progressMarkerState) {
      free(progressMarkerState);
      progressMarkerState = NULL;
    }
    progressMarkerCount = progressMarkers.count;
    if (0 != progressMarkerCount) {
      progressMarkerState = (POPProgressMarker *)malloc(progressMarkerCount * sizeof(POPProgressMarker));
      [progressMarkers enumerateObjectsUsingBlock:^(NSNumber *progressMarker, NSUInteger idx, BOOL *stop) {
        progressMarkerState[idx].reached = false;
        progressMarkerState[idx].progress = [progressMarker floatValue];
      }];
    }
    nextProgressMarkerIdx = 0;
  }
  virtual void updatedDynamicsThreshold()
  {
    dynamicsThreshold = property.threshold;
  }
  void finalizeProgress()
  {
    progress = 1.0;
    NSUInteger count = valueCount;
    VectorRef outVec(Vector::new_vector(count, NULL));
    if (outVec && toVec) {
      *outVec = *toVec;
    }
    currentVec = outVec;
    clampCurrentValue();
    delegateProgress();
  }
  void computeProgress() {
    if (!canProgress()) {
      return;
    }
    static ComputeProgressFunctor<Vector4r> func;
    Vector4r v = vector4(currentVec);
    Vector4r f = vector4(fromVec);
    Vector4r t = vector4(toVec);
    progress = func(v, f, t);
  }
  void delegateProgress() {
    if (!canProgress()) {
      return;
    }
    if (delegateDidProgress && progressMarkerState) {
      while (nextProgressMarkerIdx < progressMarkerCount) {
        if (progress < progressMarkerState[nextProgressMarkerIdx].progress)
          break;
        if (!progressMarkerState[nextProgressMarkerIdx].reached) {
          ActionEnabler enabler;
          [delegate pop_animation:self didReachProgress:progressMarkerState[nextProgressMarkerIdx].progress];
          progressMarkerState[nextProgressMarkerIdx].reached = true;
        }
        nextProgressMarkerIdx++;
      }
    }
    if (!didReachToValue) {
      bool didReachToValue = false;
      if (0 == valueCount) {
        didReachToValue = true;
      } else {
        Vector4r distance = toVec->vector4r();
        distance -= currentVec->vector4r();
        if (0 == distance.squaredNorm()) {
          didReachToValue = true;
        } else {
          if (distanceVec) {
            didReachToValue = true;
            const CGFloat *distanceValues = distanceVec->data();
            for (NSUInteger idx = 0; idx < valueCount; idx++) {
              didReachToValue &= (signbit(distance[idx]) != signbit(distanceValues[idx]));
            }
          }
        }
      }
      if (didReachToValue) {
        handleDidReachToValue();
      }
    }
  }
  void handleDidReachToValue() {
    didReachToValue = true;
    if (delegateDidReachToValue) {
      ActionEnabler enabler;
      [delegate pop_animationDidReachToValue:self];
    }
    POPAnimationDidReachToValueBlock block = animationDidReachToValueBlock;
    if (block != NULL) {
      ActionEnabler enabler;
      block(self);
    }
    if (tracing) {
      [tracer didReachToValue:POPBox(currentValue(), valueType, true)];
    }
  }
  void readObjectValue(VectorRef *ptrVec, id obj)
  {
    POPAnimatablePropertyReadBlock read = property.readBlock;
    if (NULL != read) {
      Vector4r vec = read_values(read, obj, valueCount);
      *ptrVec = VectorRef(Vector::new_vector(valueCount, vec));
      if (tracing) {
        [tracer readPropertyValue:POPBox(*ptrVec, valueType, true)];
      }
    }
  }
  virtual void willRun(bool started, id obj) {
    if (NULL == fromVec) {
      readObjectValue(&fromVec, obj);
    }
    if (NULL == toVec) {
      if (kPOPAnimationDecay == type) {
        [self toValue];
      } else {
        readObjectValue(&toVec, obj);
      }
    }
    if (started) {
      if (!currentVec) {
        currentVec = VectorRef(Vector::new_vector(valueCount, NULL));
        if (currentVec && fromVec) {
          *currentVec = *fromVec;
        }
      }
      if (!velocityVec) {
        velocityVec = VectorRef(Vector::new_vector(valueCount, NULL));
      }
      if (!originalVelocityVec) {
        originalVelocityVec = VectorRef(Vector::new_vector(valueCount, NULL));
      }
    }
    if (NULL == distanceVec) {
      VectorRef fromVec2 = NULL != currentVec ? currentVec : fromVec;
      if (fromVec2 && toVec) {
        Vector4r distance = toVec->vector4r();
        distance -= fromVec2->vector4r();
        if (0 != distance.squaredNorm()) {
          distanceVec = VectorRef(Vector::new_vector(valueCount, distance));
        }
      }
    }
  }
  virtual void reset(bool all) {
    _POPAnimationState::reset(all);
    if (all) {
      currentVec = NULL;
      previousVec = NULL;
      previous2Vec = NULL;
    }
    progress = 0;
    resetProgressMarkerState();
    didReachToValue = false;
    distanceVec = NULL;
  }
  void clampCurrentValue(NSUInteger clamp)
  {
    if (kPOPAnimationClampNone == clamp)
      return;
    CGFloat *currentValues = currentVec->data();
    const CGFloat *fromValues = fromVec->data();
    const CGFloat *toValues = toVec->data();
    for (NSUInteger idx = 0; idx < valueCount; idx++) {
      clampValue(currentValues[idx], fromValues[idx], toValues[idx], clamp);
    }
  }
  void clampCurrentValue()
  {
    clampCurrentValue(clampMode);
  }
};
typedef struct _POPPropertyAnimationState POPPropertyAnimationState;
@interface POPPropertyAnimation ()
@end