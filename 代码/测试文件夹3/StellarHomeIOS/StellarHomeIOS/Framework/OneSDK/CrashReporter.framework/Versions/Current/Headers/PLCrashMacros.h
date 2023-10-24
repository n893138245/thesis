#ifndef PLCRASH_CONSTANTS_H
#define PLCRASH_CONSTANTS_H
#include <assert.h>
#if defined(__cplusplus)
#   define PLCR_EXPORT extern "C"
#   define PLCR_C_BEGIN_DECLS extern "C" {
#   define PLCR_C_END_DECLS }
#else
#   define PLCR_EXPORT extern
#   define PLCR_C_BEGIN_DECLS
#   define PLCR_C_END_DECLS
#endif
#if defined(__cplusplus)
#  if defined(PLCRASHREPORTER_PREFIX)
#    define PLCR_CPP_BEGIN_NS namespace plcrash { inline namespace PLCRASHREPORTER_PREFIX {
#    define PLCR_CPP_END_NS }}
#  else
#   define PLCR_CPP_BEGIN_NS namespace plcrash {
#   define PLCR_CPP_END_NS }
#  endif
#
#  define PLCR_CPP_BEGIN_ASYNC_NS PLCR_CPP_BEGIN_NS namespace async {
#  define PLCR_CPP_END_ASYNC_NS PLCR_CPP_END_NS }
#endif
#ifdef __clang__
#  define PLCR_PRAGMA_CLANG(_p) _Pragma(_p)
#else
#  define PLCR_PRAGMA_CLANG(_p)
#endif
#ifdef __clang__
#  define PLCR_DEPRECATED __attribute__((deprecated))
#else
#  define PLCR_DEPRECATED
#endif
#if defined(__clang__) || defined(__GNUC__)
#  define PLCR_UNUSED __attribute__((unused))
#else
#  define PLCR_UNUSED
#endif
#ifdef PLCR_PRIVATE
#define PLCR_EXTERNAL_DEPRECATED
#  define PLCR_EXTERNAL_DEPRECATED_NOWARN_PUSH() \
      PLCR_PRAGMA_CLANG("clang diagnostic push"); \
      PLCR_PRAGMA_CLANG("clang diagnostic ignored \"-Wdocumentation-deprecated-sync\"")
#  define PLCR_EXTERNAL_DEPRECATED_NOWARN_POP() PLCR_PRAGMA_CLANG("clang diagnostic pop")
#else
#  define PLCR_EXTERNAL_DEPRECATED PLCR_DEPRECATED
#  define PLCR_EXTERNAL_DEPRECATED_NOWARN_PUSH()
#  define PLCR_EXTERNAL_DEPRECATED_NOWARN_PUSH()
#endif 
#ifdef PLCR_PRIVATE
#  if defined(__clang__) && __has_feature(cxx_attributes) && __has_warning("-Wimplicit-fallthrough")
#    define PLCR_FALLTHROUGH [[clang::fallthrough]]
#  else
#    define PLCR_FALLTHROUGH do {} while (0)
#  endif
#endif
#ifdef PLCR_PRIVATE
#  define PLCR_ASSERT_STATIC(name, cond) PLCR_ASSERT_STATIC_(name, cond, __LINE__)
#  if (defined(__cplusplus) && __cplusplus >= 201103L) || (!defined(__cplusplus) && defined(__STDC_VERSION__) && __STDC_VERSION__ >= 201112L)
#    define PLCR_ASSERT_STATIC_(name, cond, line) PLCR_ASSERT_STATIC__(#name, cond)
#    define PLCR_ASSERT_STATIC__(name, cond) static_assert(cond, #name)
#  else
#    define PLCR_ASSERT_STATIC_(name, cond, line) PLCR_ASSERT_STATIC__(name, cond, line)
#    define PLCR_ASSERT_STATIC__(name, cond, line) typedef int plcf_static_assert_##name##_##line [(cond) ? 1 : -1] PLCR_UNUSED
#  endif
#endif 
#endif 