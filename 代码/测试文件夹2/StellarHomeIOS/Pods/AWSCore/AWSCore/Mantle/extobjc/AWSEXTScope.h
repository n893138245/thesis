#import "AWSmetamacros.h"
#define onExit \
    try {} @finally {} \
    __strong awsmtl_cleanupBlock_t metamacro_concat(mtl_exitBlock_, __LINE__) __attribute__((cleanup(awsmtl_executeCleanupBlock), unused)) = ^
#define weakify(...) \
    try {} @finally {} \
    metamacro_foreach_cxt(mtl_weakify_,, __weak, __VA_ARGS__)
#define unsafeify(...) \
    try {} @finally {} \
    metamacro_foreach_cxt(mtl_weakify_,, __unsafe_unretained, __VA_ARGS__)
#define strongify(...) \
    try {} @finally {} \
    _Pragma("clang diagnostic push") \
    _Pragma("clang diagnostic ignored \"-Wshadow\"") \
    metamacro_foreach(mtl_strongify_,, __VA_ARGS__) \
    _Pragma("clang diagnostic pop")
typedef void (^awsmtl_cleanupBlock_t)(void);
void awsmtl_executeCleanupBlock (__strong awsmtl_cleanupBlock_t *block);
#define awsmtl_weakify_(INDEX, CONTEXT, VAR) \
    CONTEXT __typeof__(VAR) metamacro_concat(VAR, _weak_) = (VAR);
#define awsmtl_strongify_(INDEX, VAR) \
    __strong __typeof__(VAR) VAR = metamacro_concat(VAR, _weak_);