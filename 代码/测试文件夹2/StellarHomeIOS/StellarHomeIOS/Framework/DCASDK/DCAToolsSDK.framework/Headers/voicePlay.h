#ifdef VOICE_RECOG_DLL
#define VOICERECOGNIZEDLL_API __declspec(dllexport)
#else
#define VOICERECOGNIZEDLL_API
#endif
#ifndef VOICE_PLAY_H
#define VOICE_PLAY_H
#ifdef __cplusplus
extern "C" {
#endif
    typedef void (*vp_pPlayerStartListener)(void *_listener);
    typedef void (*vp_pPlayerEndListener)(void *_listener);
    VOICERECOGNIZEDLL_API void * vp_createVoicePlayer();
    VOICERECOGNIZEDLL_API void vp_play(void *_player, char *_data, int _dataLen, int _playCount, int _muteInterval);
    VOICERECOGNIZEDLL_API void vp_setPlayerListener(void *_player, void *_listener, vp_pPlayerStartListener _startListener, vp_pPlayerEndListener _endListener);
    VOICERECOGNIZEDLL_API void vp_setVolume(void *_player, double _volume);
    VOICERECOGNIZEDLL_API void vp_setFreqs(void *_player, int *_freqs, int _freqCount);
    VOICERECOGNIZEDLL_API int vp_isStopped(void *_player);
    VOICERECOGNIZEDLL_API void vp_destoryVoicePlayer(void *_player);
    int vp_encodeData(char *_data, int _dataLen, char *_result);
    VOICERECOGNIZEDLL_API void vp_playString(void *_player, char *_str, int _playCount, int _muteInterval);
    VOICERECOGNIZEDLL_API void changePlayString(void *_player, char *_str, int _playCount, int _muteInterval);
    VOICERECOGNIZEDLL_API void vp_playXYSSIDWiFi(void *_player, char *_ssid, int _ssidLen, char *_pwd, int _pwdLen, unsigned char _ip[4], int _port, char *_rand, int _randLen, int _playCount, int _muteInterval);
#ifdef __cplusplus
}
#endif
#endif