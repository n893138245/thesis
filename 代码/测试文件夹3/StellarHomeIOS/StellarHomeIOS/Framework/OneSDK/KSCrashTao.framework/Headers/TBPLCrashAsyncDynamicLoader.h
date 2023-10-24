#ifndef PLCRASH_ASYNC_DYNAMICLOADER_C_COMPAT_H
#define PLCRASH_ASYNC_DYNAMICLOADER_C_COMPAT_H
#include <KSCrashTao/TBPLCrashMacros.h>
#include <KSCrashTao/TBPLCrashAsyncAllocator.h>
#include <KSCrashTao/TBPLCrashAsyncMachOImage.h>
#ifdef __cplusplus
#include <KSCrashTao/TBDynamicLoader.hpp>
using kscrash_async_dynloader_t = kscrash::async::DynamicLoader;
using kscrash_async_image_list_t = kscrash::async::DynamicLoader::ImageList;
#else
typedef uintptr_t kscrash_async_dynloader_t;
typedef uintptr_t kscrash_async_image_list_t;
#endif
PLCR_C_BEGIN_DECLS
typedef struct kscrash_dynamic_loader_ctx {
    kscrash_async_allocator_t *writer_allocator;
    kscrash_async_allocator_t *_precrash_allocator;
    kscrash_async_dynloader_t *dynamic_loader;
} kscrash_dynamic_loader_ctx_t;
void kscrash_init_dynamic_loader(void);
kscrash_dynamic_loader_ctx_t *kscrash_get_shared_dynamic_loader(void);
kscrash_error_t kscrash_nasync_dynloader_new (kscrash_async_dynloader_t **loader, kscrash_async_allocator_t *allocator, task_t task);
kscrash_error_t kscrash_async_dynloader_read_image_list (kscrash_async_dynloader_t *loader, kscrash_async_allocator_t *allocator, kscrash_async_image_list_t **image_list);
void kscrash_async_dynloader_free (kscrash_async_dynloader_t *loader);
kscrash_error_t kscrash_nasync_image_list_new (kscrash_async_image_list_t **list, kscrash_async_allocator_t *allocator, task_t task);
kscrash_async_image_list_t *kscrash_async_image_list_new_empty (kscrash_async_allocator_t *allocator);
kscrash_async_macho_t *kscrash_async_image_list_get_image (kscrash_async_image_list_t *list, size_t index);
size_t kscrash_async_image_list_count (kscrash_async_image_list_t *list);
kscrash_async_macho_t *kscrash_async_image_containing_address (kscrash_async_image_list_t *list, pl_vm_address_t address);
void kscrash_async_image_list_free (kscrash_async_image_list_t *list);
PLCR_C_END_DECLS
#endif 