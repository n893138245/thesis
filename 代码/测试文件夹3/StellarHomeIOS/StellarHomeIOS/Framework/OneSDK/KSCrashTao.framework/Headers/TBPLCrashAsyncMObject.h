#ifndef PLCRASH_ASYNC_MOBJECT_H
#define PLCRASH_ASYNC_MOBJECT_H
#ifdef __cplusplus
extern "C" {
#endif
#include <stdint.h>
#include <KSCrashTao/TBPLCrashAsync.h>
typedef struct kscrash_async_mobject {
    task_t task;
    uintptr_t address;
    pl_vm_address_t task_address;
    pl_vm_size_t length;
    int64_t vm_slide;
    pl_vm_address_t vm_address;
    pl_vm_size_t vm_length;
} kscrash_async_mobject_t;
kscrash_error_t kscrash_async_mobject_init (kscrash_async_mobject_t *mobj, mach_port_t task, pl_vm_address_t task_addr, pl_vm_size_t length, bool require_full);
pl_vm_address_t kscrash_async_mobject_base_address (kscrash_async_mobject_t *mobj);
pl_vm_address_t kscrash_async_mobject_length (kscrash_async_mobject_t *mobj);
task_t kscrash_async_mobject_task (kscrash_async_mobject_t *mobj);
bool kscrash_async_mobject_verify_local_pointer (kscrash_async_mobject_t *mobj, uintptr_t address, pl_vm_off_t offset, size_t length);
void *kscrash_async_mobject_remap_address (kscrash_async_mobject_t *mobj, pl_vm_address_t address, pl_vm_off_t offset, size_t length);
kscrash_error_t kscrash_async_mobject_read_uint8 (kscrash_async_mobject_t *mobj, pl_vm_address_t address, pl_vm_off_t offset, uint8_t *result);
kscrash_error_t kscrash_async_mobject_read_uint16 (kscrash_async_mobject_t *mobj, const kscrash_async_byteorder_t *byteorder,
                                                   pl_vm_address_t address, pl_vm_off_t offset, uint16_t *result);
kscrash_error_t kscrash_async_mobject_read_uint32 (kscrash_async_mobject_t *mobj, const kscrash_async_byteorder_t *byteorder,
                                                   pl_vm_address_t address, pl_vm_off_t offset, uint32_t *result);
kscrash_error_t kscrash_async_mobject_read_uint64 (kscrash_async_mobject_t *mobj, const kscrash_async_byteorder_t *byteorder,
                                                   pl_vm_address_t address, pl_vm_off_t offset, uint64_t *result);
void kscrash_async_mobject_free (kscrash_async_mobject_t *mobj);
#ifdef __cplusplus
}
#endif
#endif 