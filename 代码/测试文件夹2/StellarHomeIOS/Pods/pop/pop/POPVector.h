#ifndef __POP__FBVector__
#define __POP__FBVector__
#ifdef __cplusplus
#include <iostream>
#include <vector>
#import <objc/NSObjCRuntime.h>
#import <CoreGraphics/CoreGraphics.h>
#import <Foundation/NSException.h>
#import "POPDefines.h"
#if SCENEKIT_SDK_AVAILABLE
#import <SceneKit/SceneKit.h>
#endif
#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#endif
namespace POP {
  template <typename T>
  struct Vector2
  {
  private:
    typedef T Vector2<T>::* const _data[2];
    static const _data _v;
  public:
    T x;
    T y;
    static const Vector2 Zero() { return Vector2(0); }
    Vector2() {}
    explicit Vector2(T v) { x = v; y = v; };
    explicit Vector2(T x0, T y0) : x(x0), y(y0) {};
    explicit Vector2(const CGPoint &p) : x(p.x), y (p.y) {}
    explicit Vector2(const CGSize &s) : x(s.width), y (s.height) {}
    template<typename U> explicit Vector2(const Vector2<U> &v) : x(v.x), y(v.y) {}
    const T& operator[](size_t i) const { return this->*_v[i]; }
    T& operator[](size_t i) { return this->*_v[i]; }
    const T& operator()(size_t i) const { return this->*_v[i]; }
    T& operator()(size_t i) { return this->*_v[i]; }
    T * data() { return &(this->*_v[0]); }
    const T * data() const { return &(this->*_v[0]); }
    inline size_t size() const { return 2; }
    Vector2 &operator= (T v) { x = v; y = v; return *this;}
    template<typename U> Vector2 &operator= (const Vector2<U> &v) { x = v.x; y = v.y; return *this;}
    Vector2 operator- (void) const { return Vector2<T>(-x, -y); }
    bool operator== (T v) const { return (x == v && y == v); }
    bool operator== (const Vector2 &v) const { return (x == v.x && y == v.y); }
    bool operator!= (T v) const {return (x != v || y != v); }
    bool operator!= (const Vector2 &v) const { return (x != v.x || y != v.y); }
    Vector2 operator+ (T v) const { return Vector2(x + v, y + v); }
    Vector2 operator- (T v) const { return Vector2(x - v, y - v); }
    Vector2 operator* (T v) const { return Vector2(x * v, y * v); }
    Vector2 operator/ (T v) const { return Vector2(x / v, y / v); }
    Vector2 &operator+= (T v) { x += v; y += v; return *this; };
    Vector2 &operator-= (T v) { x -= v; y -= v; return *this; };
    Vector2 &operator*= (T v) { x *= v; y *= v; return *this; };
    Vector2 &operator/= (T v) { x /= v; y /= v; return *this; };
    Vector2 operator+ (const Vector2 &v) const { return Vector2(x + v.x, y + v.y); }
    Vector2 operator- (const Vector2 &v) const { return Vector2(x - v.x, y - v.y); }
    Vector2 &operator+= (const Vector2 &v) { x += v.x; y += v.y; return *this; };
    Vector2 &operator-= (const Vector2 &v) { x -= v.x; y -= v.y; return *this; };
    CGFloat norm() const { return sqrtr(squaredNorm()); }
    CGFloat squaredNorm() const { return x * x + y * y; }
    template<typename U> Vector2<U> cast() const { return Vector2<U>(x, y); }
    CGPoint cg_point() const { return CGPointMake(x, y); };
  };
  template<typename T>
  const typename Vector2<T>::_data Vector2<T>::_v = { &Vector2<T>::x, &Vector2<T>::y };
  template <typename T>
  struct Vector3
  {
  private:
    typedef T Vector3<T>::* const _data[3];
    static const _data _v;
  public:
    T x;
    T y;
    T z;
    static const Vector3 Zero() { return Vector3(0); };
    Vector3() {}
    explicit Vector3(T v) : x(v), y(v), z(v) {};
    explicit Vector3(T x0, T y0, T z0) : x(x0), y(y0), z(z0) {};
    template<typename U> explicit Vector3(const Vector3<U> &v) : x(v.x), y(v.y), z(v.z) {}
    const T& operator[](size_t i) const { return this->*_v[i]; }
    T& operator[](size_t i) { return this->*_v[i]; }
    const T& operator()(size_t i) const { return this->*_v[i]; }
    T& operator()(size_t i) { return this->*_v[i]; }
    T * data() { return &(this->*_v[0]); }
    const T * data() const { return &(this->*_v[0]); }
    inline size_t size() const { return 3; }
    Vector3 &operator= (T v) { x = v; y = v; z = v; return *this;}
    template<typename U> Vector3 &operator= (const Vector3<U> &v) { x = v.x; y = v.y; z = v.z; return *this;}
    Vector3 operator- (void) const { return Vector3<T>(-x, -y, -z); }
    bool operator== (T v) const { return (x == v && y == v && z = v); }
    bool operator== (const Vector3 &v) const { return (x == v.x && y == v.y && z == v.z); }
    bool operator!= (T v) const {return (x != v || y != v || z != v); }
    bool operator!= (const Vector3 &v) const { return (x != v.x || y != v.y || z != v.z); }
    Vector3 operator+ (T v) const { return Vector3(x + v, y + v, z + v); }
    Vector3 operator- (T v) const { return Vector3(x - v, y - v, z - v); }
    Vector3 operator* (T v) const { return Vector3(x * v, y * v, z * v); }
    Vector3 operator/ (T v) const { return Vector3(x / v, y / v, z / v); }
    Vector3 &operator+= (T v) { x += v; y += v; z += v; return *this; };
    Vector3 &operator-= (T v) { x -= v; y -= v; z -= v; return *this; };
    Vector3 &operator*= (T v) { x *= v; y *= v; z *= v; return *this; };
    Vector3 &operator/= (T v) { x /= v; y /= v; z /= v; return *this; };
    Vector3 operator+ (const Vector3 &v) const { return Vector3(x + v.x, y + v.y, z + v.z); }
    Vector3 operator- (const Vector3 &v) const { return Vector3(x - v.x, y - v.y, z - v.z); }
    Vector3 &operator+= (const Vector3 &v) { x += v.x; y += v.y; z += v.z; return *this; };
    Vector3 &operator-= (const Vector3 &v) { x -= v.x; y -= v.y; z -= v.z; return *this; };
    CGFloat norm() const { return sqrtr(squaredNorm()); }
    CGFloat squaredNorm() const { return x * x + y * y + z * z; }
    template<typename U> Vector3<U> cast() const { return Vector3<U>(x, y, z); }
  };
  template<typename T>
  const typename Vector3<T>::_data Vector3<T>::_v = { &Vector3<T>::x, &Vector3<T>::y, &Vector3<T>::z };
  template <typename T>
  struct Vector4
  {
  private:
    typedef T Vector4<T>::* const _data[4];
    static const _data _v;
  public:
    T x;
    T y;
    T z;
    T w;
    static const Vector4 Zero() { return Vector4(0); };
    Vector4() {}
    explicit Vector4(T v) : x(v), y(v), z(v), w(v) {};
    explicit Vector4(T x0, T y0, T z0, T w0) : x(x0), y(y0), z(z0), w(w0) {};
    template<typename U> explicit Vector4(const Vector4<U> &v) : x(v.x), y(v.y), z(v.z), w(v.w) {}
    const T& operator[](size_t i) const { return this->*_v[i]; }
    T& operator[](size_t i) { return this->*_v[i]; }
    const T& operator()(size_t i) const { return this->*_v[i]; }
    T& operator()(size_t i) { return this->*_v[i]; }
    T * data() { return &(this->*_v[0]); }
    const T * data() const { return &(this->*_v[0]); }
    inline size_t size() const { return 4; }
    Vector4 &operator= (T v) { x = v; y = v; z = v; w = v; return *this;}
    template<typename U> Vector4 &operator= (const Vector4<U> &v) { x = v.x; y = v.y; z = v.z; w = v.w; return *this;}
    Vector4 operator- (void) const { return Vector4<T>(-x, -y, -z, -w); }
    bool operator== (T v) const { return (x == v && y == v && z = v, w = v); }
    bool operator== (const Vector4 &v) const { return (x == v.x && y == v.y && z == v.z && w == v.w); }
    bool operator!= (T v) const {return (x != v || y != v || z != v || w != v); }
    bool operator!= (const Vector4 &v) const { return (x != v.x || y != v.y || z != v.z || w != v.w); }
    Vector4 operator+ (T v) const { return Vector4(x + v, y + v, z + v, w + v); }
    Vector4 operator- (T v) const { return Vector4(x - v, y - v, z - v, w - v); }
    Vector4 operator* (T v) const { return Vector4(x * v, y * v, z * v, w * v); }
    Vector4 operator/ (T v) const { return Vector4(x / v, y / v, z / v, w / v); }
    Vector4 &operator+= (T v) { x += v; y += v; z += v; w += v; return *this; };
    Vector4 &operator-= (T v) { x -= v; y -= v; z -= v; w -= v; return *this; };
    Vector4 &operator*= (T v) { x *= v; y *= v; z *= v; w *= v; return *this; };
    Vector4 &operator/= (T v) { x /= v; y /= v; z /= v; w /= v; return *this; };
    Vector4 operator+ (const Vector4 &v) const { return Vector4(x + v.x, y + v.y, z + v.z, w + v.w); }
    Vector4 operator- (const Vector4 &v) const { return Vector4(x - v.x, y - v.y, z - v.z, w - v.w); }
    Vector4 &operator+= (const Vector4 &v) { x += v.x; y += v.y; z += v.z; w += v.w; return *this; };
    Vector4 &operator-= (const Vector4 &v) { x -= v.x; y -= v.y; z -= v.z; w -= v.w; return *this; };
    CGFloat norm() const { return sqrtr(squaredNorm()); }
    CGFloat squaredNorm() const { return x * x + y * y + z * z + w * w; }
    template<typename U> Vector4<U> cast() const { return Vector4<U>(x, y, z, w); }
  };
  template<typename T>
  const typename Vector4<T>::_data Vector4<T>::_v = { &Vector4<T>::x, &Vector4<T>::y, &Vector4<T>::z, &Vector4<T>::w };
  typedef Vector2<float> Vector2f;
  typedef Vector2<double> Vector2d;
  typedef Vector2<CGFloat> Vector2r;
  typedef Vector3<float> Vector3f;
  typedef Vector3<double> Vector3d;
  typedef Vector3<CGFloat> Vector3r;
  typedef Vector4<float> Vector4f;
  typedef Vector4<double> Vector4d;
  typedef Vector4<CGFloat> Vector4r;
  class Vector
  {
    size_t _count;
    CGFloat *_values;
  private:
    Vector(size_t);
    Vector(const Vector& other);
  public:
    ~Vector();
    static Vector *new_vector(NSUInteger count, const CGFloat *values);
    static Vector *new_vector(const Vector * const other);
    static Vector *new_vector(NSUInteger count, Vector4r vec);
    NSUInteger size() const { return _count; }
    CGFloat *data () { return _values; }
    const CGFloat *data () const { return _values; };
    Vector2r vector2r() const;
    Vector4r vector4r() const;
    static Vector *new_cg_float(CGFloat f);
    CGPoint cg_point() const;
    static Vector *new_cg_point(const CGPoint &p);
    CGSize cg_size() const;
    static Vector *new_cg_size(const CGSize &s);
    CGRect cg_rect() const;
    static Vector *new_cg_rect(const CGRect &r);
#if TARGET_OS_IPHONE
    UIEdgeInsets ui_edge_insets() const;
    static Vector *new_ui_edge_insets(const UIEdgeInsets &i);
#endif
    CGAffineTransform cg_affine_transform() const;
    static Vector *new_cg_affine_transform(const CGAffineTransform &t);
    CGColorRef cg_color() const CF_RETURNS_RETAINED;
    static Vector *new_cg_color(CGColorRef color);
#if SCENEKIT_SDK_AVAILABLE
    SCNVector3 scn_vector3() const;
    static Vector *new_scn_vector3(const SCNVector3 &vec3);
    SCNVector4 scn_vector4() const;
    static Vector *new_scn_vector4(const SCNVector4 &vec4);
#endif
    CGFloat &operator[](size_t i) const {
      NSCAssert(size() > i, @"unexpected vector size:%lu", (unsigned long)size());
      return _values[i];
    }
    CGFloat norm() const;
    CGFloat squaredNorm() const;
    void subRound(CGFloat sub);
    NSString * toString() const;
    template<typename U> Vector& operator= (const Vector4<U>& other) {
      size_t count = MIN(_count, other.size());
      for (size_t i = 0; i < count; i++) {
        _values[i] = other[i];
      }
      return *this;
    }
    Vector& operator= (const Vector& other);
    void swap(Vector &first, Vector &second);
    bool operator==(const Vector &other) const;
    bool operator!=(const Vector &other) const;
  };
  typedef std::shared_ptr<Vector> VectorRef;
  typedef std::shared_ptr<const Vector> VectorConstRef;
}
#endif 
#endif 