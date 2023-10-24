#ifndef PLCRASH_ASYNC_H
#define PLCRASH_ASYNC_H
#ifdef __cplusplus
extern "C" {
#endif
#include <stdio.h> 
#include <unistd.h>
#include <stdbool.h>
#include <stddef.h>
#include <assert.h>
#include <TargetConditionals.h>
#include <mach/mach.h>
#if TARGET_OS_IPHONE
#ifdef __LP64__
#define PL_VM_ADDRESS_MAX UINT64_MAX
#else
#define PL_VM_ADDRESS_MAX UINT32_MAX
#endif
#ifdef __LP64__
#define PL_VM_SIZE_MAX UINT64_MAX
#else
#define PL_VM_SIZE_MAX UINT32_MAX
#endif
#define PL_VM_OFF_MAX PTRDIFF_MAX
#define PL_VM_OFF_MIN PTRDIFF_MIN
typedef vm_address_t pl_vm_address_t;
typedef vm_size_t pl_vm_size_t;
typedef ptrdiff_t pl_vm_off_t;
#else
#include <mach/mach_vm.h>
#define PL_HAVE_MACH_VM 1
#define PL_VM_ADDRESS_MAX UINT64_MAX
#define PL_VM_SIZE_MAX UINT64_MAX
#define PL_VM_OFF_MAX INT64_MAX
#define PL_VM_OFF_MIN INT64_MIN
typedef mach_vm_address_t pl_vm_address_t;
typedef mach_vm_size_t pl_vm_size_t;
typedef int64_t pl_vm_off_t;
#endif 
#define PL_VM_ADDRESS_INVALID PL_VM_ADDRESS_MAX
#ifdef PLCF_RELEASE_BUILD
#define PLCF_ASSERT(expr)
#else
#define PLCF_ASSERT(expr) assert(expr)
#endif 
#ifdef PLCF_RELEASE_BUILD
#define PLCF_DEBUG(msg, args...)
#else
#define PLCF_DEBUG(msg, args...) {\
    char __tmp_output[128];\
    snprintf(__tmp_output, sizeof(__tmp_output), "[PLCrashReport] "); \
    kscrash_async_writen(STDERR_FILENO, __tmp_output, strlen(__tmp_output));\
    \
    snprintf(__tmp_output, sizeof(__tmp_output), ":%d: ", __LINE__); \
    kscrash_async_writen(STDERR_FILENO, __func__, strlen(__func__));\
    kscrash_async_writen(STDERR_FILENO, __tmp_output, strlen(__tmp_output));\
    \
    snprintf(__tmp_output, sizeof(__tmp_output), msg, ## args); \
    kscrash_async_writen(STDERR_FILENO, __tmp_output, strlen(__tmp_output));\
    \
    __tmp_output[0] = '\n'; \
    kscrash_async_writen(STDERR_FILENO, __tmp_output, 1); \
}
#endif 
typedef enum  {
    PLCRASH_ESUCCESS = 0,
    PLCRASH_EUNKNOWN,
    PLCRASH_OUTPUT_ERR,
    PLCRASH_ENOMEM,
    PLCRASH_ENOTSUP,
    PLCRASH_EINVAL,
    PLCRASH_EINTERNAL,
    PLCRASH_EACCESS,
    PLCRASH_ENOTFOUND,
    PLCRASH_EINVALID_DATA,
} kscrash_error_t;
const char *kscrash_async_strerror (kscrash_error_t error);
bool kscrash_async_address_apply_offset (pl_vm_address_t base_address, pl_vm_off_t offset, pl_vm_address_t *result);
thread_t pl_mach_thread_self (void);
typedef struct kscrash_async_byteorder {
    uint16_t (*swap16)(uint16_t);
    uint32_t (*swap32)(uint32_t);
    uint64_t (*swap64)(uint64_t);
#ifdef __cplusplus
public:
    uint16_t swap (uint16_t v) const { return swap16(v); }
    uint32_t swap (uint32_t v) const { return swap32(v); }
    uint64_t swap (uint64_t v) const { return swap64(v); }
#endif
} kscrash_async_byteorder_t;
extern const kscrash_async_byteorder_t kscrash_async_byteorder_swapped;
extern const kscrash_async_byteorder_t kscrash_async_byteorder_direct;
extern const kscrash_async_byteorder_t *kscrash_async_byteorder_little_endian (void);
extern const kscrash_async_byteorder_t *kscrash_async_byteorder_big_endian (void);
kscrash_error_t kscrash_async_task_memcpy (mach_port_t task, pl_vm_address_t address, pl_vm_off_t offset, void *dest, pl_vm_size_t len);
kscrash_error_t kscrash_async_task_read_uint8 (task_t task, pl_vm_address_t address, pl_vm_off_t offset, uint8_t *result);
kscrash_error_t kscrash_async_task_read_uint16 (task_t task, const kscrash_async_byteorder_t *byteorder,
                                                pl_vm_address_t address, pl_vm_off_t offset, uint16_t *result);
kscrash_error_t kscrash_async_task_read_uint32 (task_t task, const kscrash_async_byteorder_t *byteorder,
                                                pl_vm_address_t address, pl_vm_off_t offset, uint32_t *result);
kscrash_error_t kscrash_async_task_read_uint64 (task_t task, const kscrash_async_byteorder_t *byteorder,
                                                pl_vm_address_t address, pl_vm_off_t offset, uint64_t *result);
int kscrash_async_strcmp(const char *s1, const char *s2);
int kscrash_async_strncmp(const char *s1, const char *s2, size_t n);
void *kscrash_async_memcpy(void *dest, const void *source, size_t n);
void *kscrash_async_memset(void *dest, uint8_t value, size_t n);
ssize_t kscrash_async_writen (int fd, const void *data, size_t len);
typedef struct kscrash_async_file {
    int fd;
    off_t limit_bytes;
    off_t total_bytes;
    size_t buflen;
    char buffer[256];
} kscrash_async_file_t;
void kscrash_async_file_init (kscrash_async_file_t *file, int fd, off_t output_limit);
bool kscrash_async_file_write (kscrash_async_file_t *file, const void *data, size_t len);
bool kscrash_async_file_flush (kscrash_async_file_t *file);
bool kscrash_async_file_close (kscrash_async_file_t *file);
#ifdef __cplusplus
}
#endif
#endif 