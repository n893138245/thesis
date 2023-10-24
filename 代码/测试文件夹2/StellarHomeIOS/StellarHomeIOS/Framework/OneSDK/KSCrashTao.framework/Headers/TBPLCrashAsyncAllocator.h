#ifndef PLCRASH_ASYNC_ALLOCATOR_C_COMPAT_H
#define PLCRASH_ASYNC_ALLOCATOR_C_COMPAT_H
#include <KSCrashTao/TBPLCrashMacros.h>
#include <KSCrashTao/TBPLCrashAsync.h>
#ifdef __cplusplus
#include "TBAsyncAllocator.hpp"
using kscrash_async_allocator_t = kscrash::async::AsyncAllocator;
#else
typedef uintptr_t kscrash_async_allocator_t;
#endif
PLCR_C_BEGIN_DECLS
PLCR_EXPORT kscrash_error_t kscrash_async_allocator_create (kscrash_async_allocator_t **allocator, size_t initial_size);
PLCR_EXPORT kscrash_error_t kscrash_async_allocator_alloc (kscrash_async_allocator_t *allocator, void **allocated, size_t size);
PLCR_EXPORT void kscrash_async_allocator_dealloc (kscrash_async_allocator_t *allocator, void *ptr);
PLCR_EXPORT void kscrash_async_allocator_free (kscrash_async_allocator_t *allocator);
PLCR_C_END_DECLS
#endif 