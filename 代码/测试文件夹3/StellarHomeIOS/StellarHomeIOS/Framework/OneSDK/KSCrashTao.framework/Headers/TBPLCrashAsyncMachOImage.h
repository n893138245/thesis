#ifndef PLCRASH_ASYNC_MACHO_IMAGE_H
#define PLCRASH_ASYNC_MACHO_IMAGE_H
#include <stdint.h>
#include <mach/mach.h>
#include <mach-o/loader.h>
#include <mach-o/nlist.h>
#include <KSCrashTao/TBPLCrashAsyncMObject.h>
#include <KSCrashTao/TBPLCrashAsyncAllocator.h>
#ifdef __cplusplus
extern "C" {
#endif
typedef struct kscrash_async_macho {
    kscrash_async_allocator_t *_allocator;
    mach_port_t task;
    pl_vm_address_t header_addr;
    pl_vm_off_t vmaddr_slide;
    char *name;
    struct mach_header header;
    pl_vm_size_t header_size;
    uint32_t ncmds;
    kscrash_async_mobject_t load_cmds;
    pl_vm_address_t text_vmaddr;
    pl_vm_size_t text_size;
    bool m64;
    const kscrash_async_byteorder_t *byteorder;
} kscrash_async_macho_t;
typedef struct kscrash_async_macho_mapped_segment_t {
    kscrash_async_mobject_t mobj;
    uint64_t	fileoff;
	uint64_t	filesize;
} pl_async_macho_mapped_segment_t;
typedef struct kscrash_async_macho_symtab_entry {
    uint32_t n_strx;
    uint8_t n_type;
    uint8_t n_sect;
    uint16_t n_desc;
    pl_vm_address_t n_value;
    pl_vm_address_t normalized_value;
} kscrash_async_macho_symtab_entry_t;
typedef struct kscrash_async_macho_symtab_reader {
    kscrash_async_macho_t *image;
    pl_async_macho_mapped_segment_t linkedit;
    void *symtab;
    uint32_t nsyms;
    void *symtab_global;
    uint32_t nsyms_global;
    void *symtab_local;
    uint32_t nsyms_local;
    char *string_table;
    size_t string_table_size;
} kscrash_async_macho_symtab_reader_t;
typedef void (*pl_async_macho_found_symbol_cb)(pl_vm_address_t address, const char *name, void *ctx);
kscrash_error_t kscrash_async_macho_init (kscrash_async_macho_t *image, kscrash_async_allocator_t *allocator, mach_port_t task, const char *name, pl_vm_address_t header);
const kscrash_async_byteorder_t *kscrash_async_macho_byteorder (kscrash_async_macho_t *image);
const struct mach_header *kscrash_async_macho_header (kscrash_async_macho_t *image);
pl_vm_size_t kscrash_async_macho_header_size (kscrash_async_macho_t *image);
bool kscrash_async_macho_contains_address (kscrash_async_macho_t *image, pl_vm_address_t address);
cpu_type_t kscrash_async_macho_cpu_type (kscrash_async_macho_t *image);
cpu_subtype_t kscrash_async_macho_cpu_subtype (kscrash_async_macho_t *image);
void *kscrash_async_macho_next_command (kscrash_async_macho_t *image, void *previous);
void *kscrash_async_macho_next_command_type (kscrash_async_macho_t *image, void *previous, uint32_t expectedCommand);
void *kscrash_async_macho_find_command (kscrash_async_macho_t *image, uint32_t cmd);
void *kscrash_async_macho_find_segment_cmd (kscrash_async_macho_t *image, const char *segname);
kscrash_error_t kscrash_async_macho_map_segment (kscrash_async_macho_t *image, const char *segname, pl_async_macho_mapped_segment_t *seg);
kscrash_error_t kscrash_async_macho_map_section (kscrash_async_macho_t *image, const char *segname, const char *sectname, kscrash_async_mobject_t *mobj);
kscrash_error_t kscrash_async_macho_find_symbol_by_pc (kscrash_async_macho_t *image, pl_vm_address_t pc, pl_async_macho_found_symbol_cb symbol_cb, void *context);
kscrash_error_t kscrash_async_macho_find_symbol_by_name (kscrash_async_macho_t *image, const char *symbol, pl_vm_address_t *pc);
kscrash_error_t kscrash_async_macho_symtab_reader_init (kscrash_async_macho_symtab_reader_t *reader, kscrash_async_macho_t *image);
kscrash_async_macho_symtab_entry_t kscrash_async_macho_symtab_reader_read (kscrash_async_macho_symtab_reader_t *reader, void *symtab, uint32_t index);
const char *kscrash_async_macho_symtab_reader_symbol_name (kscrash_async_macho_symtab_reader_t *reader, uint32_t n_strx);
void kscrash_async_macho_symtab_reader_free (kscrash_async_macho_symtab_reader_t *reader);
void kscrash_async_macho_mapped_segment_free (pl_async_macho_mapped_segment_t *segment);
void kscrash_async_macho_free (kscrash_async_macho_t *image);
#ifdef __cplusplus
}
#endif
#endif 