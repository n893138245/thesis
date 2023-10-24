#import "POPBasicAnimation.h"
#import "POPPropertyAnimationInternal.h"
static CGFloat const kPOPAnimationDurationDefault = 0.4;
static CGFloat const kPOPProgressThreshold = 1e-6;
static void interpolate(POPValueType valueType, NSUInteger count, const CGFloat *fromVec, const CGFloat *toVec, CGFloat *outVec, CGFloat p)
{
  switch (valueType) {
    case kPOPValueInteger:
    case kPOPValueFloat:
    case kPOPValuePoint:
    case kPOPValueSize:
    case kPOPValueRect:
    case kPOPValueEdgeInsets:
    case kPOPValueColor:
      POPInterpolateVector(count, outVec, fromVec, toVec, p);
      break;
    default:
      NSCAssert(false, @"unhandled type %d", valueType);
      break;
  }
}
struct _POPBasicAnimationState : _POPPropertyAnimationState
{
  CAMediaTimingFunction *timingFunction;
  double timingControlPoints[4];
  CFTimeInterval duration;
  CFTimeInterval timeProgress;
  _POPBasicAnimationState(id __unsafe_unretained anim) : _POPPropertyAnimationState(anim),
  timingFunction(nil),
  timingControlPoints{0.},
  duration(kPOPAnimationDurationDefault),
  timeProgress(0.)
  {
    type = kPOPAnimationBasic;
  }
  bool isDone() {
    if (_POPPropertyAnimationState::isDone()) {
      return true;
    }
    return timeProgress + kPOPProgressThreshold >= 1.;
  }
  void updatedTimingFunction()
  {
    float vec[4] = {0.};
    [timingFunction getControlPointAtIndex:1 values:&vec[0]];
    [timingFunction getControlPointAtIndex:2 values:&vec[2]];
    for (NSUInteger idx = 0; idx < POP_ARRAY_COUNT(vec); idx++) {
      timingControlPoints[idx] = vec[idx];
    }
  }
  bool advance(CFTimeInterval time, CFTimeInterval dt, id obj) {
    if (!timingFunction) {
      ((POPBasicAnimation *)self).timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    }
    CGFloat p = 1.0f;
    if (duration > 0.0f) {
        CFTimeInterval t = MIN(time - startTime, duration) / duration;
        p = POPTimingFunctionSolve(timingControlPoints, t, SOLVE_EPS(duration));
        timeProgress = t;
    } else {
        timeProgress = 1.;
    }
    interpolate(valueType, valueCount, fromVec->data(), toVec->data(), currentVec->data(), p);
    progress = p;
    clampCurrentValue();
    return true;
  }
};
typedef struct _POPBasicAnimationState POPBasicAnimationState;