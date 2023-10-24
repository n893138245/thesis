#ifndef FloatConversion_h
#define FloatConversion_h
#include <CoreGraphics/CGBase.h>
namespace WebCore {
    template<typename T>
    float narrowPrecisionToFloat(T);
    template<>
    inline float narrowPrecisionToFloat(double number)
    {
        return static_cast<float>(number);
    }
    template<typename T>
    CGFloat narrowPrecisionToCGFloat(T);
    template<>
    inline CGFloat narrowPrecisionToCGFloat(double number)
    {
        return static_cast<CGFloat>(number);
    }
} 
#endif 