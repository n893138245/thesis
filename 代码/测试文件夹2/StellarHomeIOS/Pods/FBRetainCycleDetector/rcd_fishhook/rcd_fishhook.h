#ifndef rcd_fishhook_h
#define rcd_fishhook_h
#include <stddef.h>
#include <stdint.h>
#if !defined(FISHHOOK_EXPORT)
#define FISHHOOK_VISIBILITY __attribute__((visibility("hidden")))
#else
#define FISHHOOK_VISIBILITY __attribute__((visibility("default")))
#endif
#ifdef __cplusplus
extern "C" {
#endif 
struct rcd_rebinding {
  const char *name;
  void *replacement;
  void **replaced;
};
FISHHOOK_VISIBILITY
int rcd_rebind_symbols(struct rcd_rebinding rebindings[], size_t rebindings_nel);
FISHHOOK_VISIBILITY
int rcd_rebind_symbols_image(void *header,
                         intptr_t slide,
                         struct rcd_rebinding rebindings[],
                         size_t rebindings_nel);
#ifdef __cplusplus
}
#endif 
#endif 