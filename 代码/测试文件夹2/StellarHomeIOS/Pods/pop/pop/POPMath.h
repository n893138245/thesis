#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import "POPDefines.h"
NS_INLINE CGFloat sqrtr(CGFloat f)
{
#if CGFLOAT_IS_DOUBLE
  return sqrt(f);
#else
  return sqrtf(f);
#endif
}
NS_INLINE CGFloat POPSubRound(CGFloat f, CGFloat sub)
{
  return round(f * sub) / sub;
}
#define MIX(a, b, f) ((a) + (f) * ((b) - (a)))
#define SOLVE_EPS(dur) (1. / (1000. * (dur)))
#define _EQLF_(x, y, epsilon) (fabsf ((x) - (y)) < epsilon)
extern void POPInterpolateVector(NSUInteger count, CGFloat *dst, const CGFloat *from, const CGFloat *to, CGFloat f);
extern double POPTimingFunctionSolve(const double vec[4], double t, double eps);
extern double POPQuadraticOutInterpolation(double t, double start, double end);
extern double POPNormalize(double value, double startValue, double endValue);
extern double POPProjectNormal(double n, double start, double end);
extern void POPQuadraticSolve(CGFloat a, CGFloat b, CGFloat c, CGFloat &x1, CGFloat &x2);
extern double POPBouncy3NoBounce(double tension);