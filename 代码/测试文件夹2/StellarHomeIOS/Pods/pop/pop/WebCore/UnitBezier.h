#ifndef UnitBezier_h
#define UnitBezier_h
#include <math.h>
namespace WebCore {
  struct UnitBezier {
    UnitBezier(double p1x, double p1y, double p2x, double p2y)
    {
      cx = 3.0 * p1x;
      bx = 3.0 * (p2x - p1x) - cx;
      ax = 1.0 - cx -bx;
      cy = 3.0 * p1y;
      by = 3.0 * (p2y - p1y) - cy;
      ay = 1.0 - cy - by;
    }
    double sampleCurveX(double t)
    {
      return ((ax * t + bx) * t + cx) * t;
    }
    double sampleCurveY(double t)
    {
      return ((ay * t + by) * t + cy) * t;
    }
    double sampleCurveDerivativeX(double t)
    {
      return (3.0 * ax * t + 2.0 * bx) * t + cx;
    }
    double solveCurveX(double x, double epsilon)
    {
      double t0;
      double t1;
      double t2;
      double x2;
      double d2;
      int i;
      for (t2 = x, i = 0; i < 8; i++) {
        x2 = sampleCurveX(t2) - x;
        if (fabs (x2) < epsilon)
          return t2;
        d2 = sampleCurveDerivativeX(t2);
        if (fabs(d2) < 1e-6)
          break;
        t2 = t2 - x2 / d2;
      }
      t0 = 0.0;
      t1 = 1.0;
      t2 = x;
      if (t2 < t0)
        return t0;
      if (t2 > t1)
        return t1;
      while (t0 < t1) {
        x2 = sampleCurveX(t2);
        if (fabs(x2 - x) < epsilon)
          return t2;
        if (x > x2)
          t0 = t2;
        else
          t1 = t2;
        t2 = (t1 - t0) * .5 + t0;
      }
      return t2;
    }
    double solve(double x, double epsilon)
    {
      return sampleCurveY(solveCurveX(x, epsilon));
    }
  private:
    double ax;
    double bx;
    double cx;
    double ay;
    double by;
    double cy;
  };
}
#endif