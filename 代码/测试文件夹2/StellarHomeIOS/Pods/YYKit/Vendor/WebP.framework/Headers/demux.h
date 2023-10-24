#ifndef WEBP_WEBP_DEMUX_H_
#define WEBP_WEBP_DEMUX_H_
#include "./decode.h"     
#include "./mux_types.h"
#ifdef __cplusplus
extern "C" {
#endif
#define WEBP_DEMUX_ABI_VERSION 0x0107    
typedef struct WebPDemuxer WebPDemuxer;
typedef struct WebPIterator WebPIterator;
typedef struct WebPChunkIterator WebPChunkIterator;
typedef struct WebPAnimInfo WebPAnimInfo;
typedef struct WebPAnimDecoderOptions WebPAnimDecoderOptions;
WEBP_EXTERN(int) WebPGetDemuxVersion(void);
typedef enum WebPDemuxState {
  WEBP_DEMUX_PARSE_ERROR    = -1,  
  WEBP_DEMUX_PARSING_HEADER =  0,  
  WEBP_DEMUX_PARSED_HEADER  =  1,  
  WEBP_DEMUX_DONE           =  2   
} WebPDemuxState;
WEBP_EXTERN(WebPDemuxer*) WebPDemuxInternal(
    const WebPData*, int, WebPDemuxState*, int);
static WEBP_INLINE WebPDemuxer* WebPDemux(const WebPData* data) {
  return WebPDemuxInternal(data, 0, NULL, WEBP_DEMUX_ABI_VERSION);
}
static WEBP_INLINE WebPDemuxer* WebPDemuxPartial(
    const WebPData* data, WebPDemuxState* state) {
  return WebPDemuxInternal(data, 1, state, WEBP_DEMUX_ABI_VERSION);
}
WEBP_EXTERN(void) WebPDemuxDelete(WebPDemuxer* dmux);
typedef enum WebPFormatFeature {
  WEBP_FF_FORMAT_FLAGS,  
  WEBP_FF_CANVAS_WIDTH,
  WEBP_FF_CANVAS_HEIGHT,
  WEBP_FF_LOOP_COUNT,
  WEBP_FF_BACKGROUND_COLOR,
  WEBP_FF_FRAME_COUNT    
} WebPFormatFeature;
WEBP_EXTERN(uint32_t) WebPDemuxGetI(
    const WebPDemuxer* dmux, WebPFormatFeature feature);
struct WebPIterator {
  int frame_num;
  int num_frames;          
  int x_offset, y_offset;  
  int width, height;       
  int duration;            
  WebPMuxAnimDispose dispose_method;  
  int complete;   
  WebPData fragment;  
  int has_alpha;      
  WebPMuxAnimBlend blend_method;  
  uint32_t pad[2];         
  void* private_;          
};
WEBP_EXTERN(int) WebPDemuxGetFrame(
    const WebPDemuxer* dmux, int frame_number, WebPIterator* iter);
WEBP_EXTERN(int) WebPDemuxNextFrame(WebPIterator* iter);
WEBP_EXTERN(int) WebPDemuxPrevFrame(WebPIterator* iter);
WEBP_EXTERN(void) WebPDemuxReleaseIterator(WebPIterator* iter);
struct WebPChunkIterator {
  int chunk_num;
  int num_chunks;
  WebPData chunk;    
  uint32_t pad[6];   
  void* private_;
};
WEBP_EXTERN(int) WebPDemuxGetChunk(const WebPDemuxer* dmux,
                                   const char fourcc[4], int chunk_number,
                                   WebPChunkIterator* iter);
WEBP_EXTERN(int) WebPDemuxNextChunk(WebPChunkIterator* iter);
WEBP_EXTERN(int) WebPDemuxPrevChunk(WebPChunkIterator* iter);
WEBP_EXTERN(void) WebPDemuxReleaseChunkIterator(WebPChunkIterator* iter);
typedef struct WebPAnimDecoder WebPAnimDecoder;  
struct WebPAnimDecoderOptions {
  WEBP_CSP_MODE color_mode;
  int use_threads;           
  uint32_t padding[7];       
};
WEBP_EXTERN(int) WebPAnimDecoderOptionsInitInternal(
    WebPAnimDecoderOptions*, int);
static WEBP_INLINE int WebPAnimDecoderOptionsInit(
    WebPAnimDecoderOptions* dec_options) {
  return WebPAnimDecoderOptionsInitInternal(dec_options,
                                            WEBP_DEMUX_ABI_VERSION);
}
WEBP_EXTERN(WebPAnimDecoder*) WebPAnimDecoderNewInternal(
    const WebPData*, const WebPAnimDecoderOptions*, int);
static WEBP_INLINE WebPAnimDecoder* WebPAnimDecoderNew(
    const WebPData* webp_data, const WebPAnimDecoderOptions* dec_options) {
  return WebPAnimDecoderNewInternal(webp_data, dec_options,
                                    WEBP_DEMUX_ABI_VERSION);
}
struct WebPAnimInfo {
  uint32_t canvas_width;
  uint32_t canvas_height;
  uint32_t loop_count;
  uint32_t bgcolor;
  uint32_t frame_count;
  uint32_t pad[4];   
};
WEBP_EXTERN(int) WebPAnimDecoderGetInfo(const WebPAnimDecoder* dec,
                                        WebPAnimInfo* info);
WEBP_EXTERN(int) WebPAnimDecoderGetNext(WebPAnimDecoder* dec,
                                        uint8_t** buf, int* timestamp);
WEBP_EXTERN(int) WebPAnimDecoderHasMoreFrames(const WebPAnimDecoder* dec);
WEBP_EXTERN(void) WebPAnimDecoderReset(WebPAnimDecoder* dec);
WEBP_EXTERN(const WebPDemuxer*) WebPAnimDecoderGetDemuxer(
    const WebPAnimDecoder* dec);
WEBP_EXTERN(void) WebPAnimDecoderDelete(WebPAnimDecoder* dec);
#ifdef __cplusplus
}    
#endif
#endif  