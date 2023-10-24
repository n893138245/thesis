#ifndef POP_POPDefines_h
#define POP_POPDefines_h
#import <Availability.h>
#ifdef __cplusplus
# define POP_EXTERN_C_BEGIN extern "C" {
# define POP_EXTERN_C_END   }
#else
# define POP_EXTERN_C_BEGIN
# define POP_EXTERN_C_END
#endif
#define POP_ARRAY_COUNT(x) sizeof(x) / sizeof(x[0])
#if defined (__cplusplus) && defined (__GNUC__)
# define POP_NOTHROW __attribute__ ((nothrow))
#else
# define POP_NOTHROW
#endif
#if defined(POP_USE_SCENEKIT)
# if TARGET_OS_MAC || TARGET_OS_IPHONE
#  define SCENEKIT_SDK_AVAILABLE 1
# endif
#endif
#endif