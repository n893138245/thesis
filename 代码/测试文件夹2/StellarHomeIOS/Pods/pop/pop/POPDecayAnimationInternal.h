#import "POPDecayAnimation.h"
#import <cmath>
#import "POPPropertyAnimationInternal.h"
static CGFloat kPOPAnimationDecayMinimalVelocityFactor = 5.;
static CGFloat kPOPAnimationDecayDecelerationDefault = 0.998;
static void decay_position(CGFloat *x, CGFloat *v, NSUInteger count, CFTimeInterval dt, CGFloat deceleration)
{
  dt *= 1000;
  float v0[count];
  float kv = powf(deceleration, dt);
  float kx = deceleration * (1 - kv) / (1 - deceleration);
  for (NSUInteger idx = 0; idx < count; idx++) {
    v0[idx] = v[idx] / 1000.;
    v[idx] = v0[idx] * kv * 1000.;
    x[idx] = x[idx] + v0[idx] * kx;
  }
}
struct _POPDecayAnimationState : _POPPropertyAnimationState
{
  double deceleration;
  CFTimeInterval duration;
  _POPDecayAnimationState(id __unsafe_unretained anim) :
  _POPPropertyAnimationState(anim),
  deceleration(kPOPAnimationDecayDecelerationDefault),
  duration(0)
  {
    type = kPOPAnimationDecay;
  }
  bool isDone() {
    if (_POPPropertyAnimationState::isDone()) {
      return true;
    }
    CGFloat f = dynamicsThreshold * kPOPAnimationDecayMinimalVelocityFactor;
    const CGFloat *velocityValues = vec_data(velocityVec);
    for (NSUInteger idx = 0; idx < valueCount; idx++) {
      if (std::abs((velocityValues[idx])) >= f)
        return false;
    }
    return true;
  }
  void computeDuration() {
    Vector4r scaledVelocity = vector4(velocityVec) / 1000.;
    double k = dynamicsThreshold * kPOPAnimationDecayMinimalVelocityFactor / 1000.;
    double vx = k / scaledVelocity.x;
    double vy = k / scaledVelocity.y;
    double vz = k / scaledVelocity.z;
    double vw = k / scaledVelocity.w;
    double d = log(deceleration) * 1000.;
    duration = MAX(MAX(MAX(log(fabs(vx)) / d, log(fabs(vy)) / d), log(fabs(vz)) / d), log(fabs(vw)) / d);
    if (std::isnan(duration) || duration < 0) {
      duration = 0;
    }
  }
  void computeToValue() {
    VectorRef fromValue = NULL != currentVec ? currentVec : fromVec;
    if (!fromValue) {
      return;
    }
    if (0 == duration) {
      computeDuration();
    }
    VectorRef toValue(Vector::new_vector(fromValue.get()));
    Vector4r velocity = velocityVec->vector4r();
    decay_position(toValue->data(), velocity.data(), valueCount, duration, deceleration);
    toVec = toValue;
  }
  bool advance(CFTimeInterval time, CFTimeInterval dt, id obj) {
    if (NULL == currentVec) {
      return false;
    }
    decay_position(currentVec->data(), velocityVec->data(), valueCount, dt, deceleration);
    clampCurrentValue(kPOPAnimationClampEnd | clampMode);
    return true;
  }
};
typedef struct _POPDecayAnimationState POPDecayAnimationState;