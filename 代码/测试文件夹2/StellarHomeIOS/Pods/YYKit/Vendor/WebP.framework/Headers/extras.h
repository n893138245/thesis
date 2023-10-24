#ifndef WEBP_WEBP_EXTRAS_H_
#define WEBP_WEBP_EXTRAS_H_
#include "./types.h"
#ifdef __cplusplus
extern "C" {
#endif
#include "./encode.h"
#define WEBP_EXTRAS_ABI_VERSION 0x0000    
WEBP_EXTERN(int) WebPGetExtrasVersion(void);
WEBP_EXTERN(int) WebPImportGray(const uint8_t* gray, WebPPicture* picture);
WEBP_EXTERN(int) WebPImportRGB565(const uint8_t* rgb565, WebPPicture* pic);
WEBP_EXTERN(int) WebPImportRGB4444(const uint8_t* rgb4444, WebPPicture* pic);
#ifdef __cplusplus
}    
#endif
#endif  