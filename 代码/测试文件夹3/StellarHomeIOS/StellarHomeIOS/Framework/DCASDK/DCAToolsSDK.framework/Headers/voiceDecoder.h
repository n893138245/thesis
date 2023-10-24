#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, VDPriority)
{
    VD_CPUUsePriority
    , VD_MemoryUsePriority
};
typedef NS_ENUM(NSInteger, VDErrorCode)
{
    VD_SUCCESS = 0, VD_NoSignal = -1, VD_ECCError = -2, VD_NotEnoughSignal = 100
    , VD_NotHeaderOrTail = 101, VD_RecogCountZero = 102
};
@interface VoiceRecog : NSObject
{
    void *recognizer;
    void *recorder;
    NSThread *recogThread;
}
- (id)init:(VDPriority)_vdpriority;
- (void) start;
- (void) stop;
- (void) pause:(int)_ms;
- (bool) isStopped;
- (void) setFreqs:(int *)_freqs freqCount:(int)_freqCount;
- (void) onRecognizerStart;
- (void) onRecognizerEnd:(int)_result data:(char *)_data dataLen:(int)_dataLen;
- (NSString *) bytes2String:(char *)_bytes bytesLen:(int)_bytesLen;
+ (int) infoType:(char *)_data dataLen:(int)_dataLen;
@end