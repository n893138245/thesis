#ifdef VOICE_RECOG_DLL
#define VOICERECOGNIZEDLL_API __declspec(dllexport)
#else
#define VOICERECOGNIZEDLL_API
#endif
#ifndef VOICE_RECOG_H
#define VOICE_RECOG_H
#ifdef __cplusplus
extern "C" {
#endif
	enum VRErrorCode
	{
		VR_SUCCESS = 0, VR_NoSignal = -1, VR_ECCError = -2, VR_NotEnoughSignal = 100
		, VR_NotHeaderOrTail = 101, VR_RecogCountZero = 102
	};
	enum DecoderPriority
	{
		CPUUsePriority = 1
		, MemoryUsePriority = 2
	};
	typedef enum {vr_false = 0, vr_true = 1} vr_bool;
	typedef void (*vr_pRecognizerStartListener)(void *_listener, float _soundTime);
	typedef void (*vr_pRecognizerEndListener)(void *_listener, float _soundTime, int _result, char *_data, int _dataLen);
	VOICERECOGNIZEDLL_API void *vr_createVoiceRecognizer(enum DecoderPriority _decoderPriority);
	VOICERECOGNIZEDLL_API void vr_destroyVoiceRecognizer(void *_recognizer);
	VOICERECOGNIZEDLL_API void vr_setRecognizeFreqs(void *_recognizer, int *_freqs, int _freqCount);
	VOICERECOGNIZEDLL_API void vr_setRecognizerListener(void *_recognizer, void *_listener, vr_pRecognizerStartListener _startListener, vr_pRecognizerEndListener _endListener);
	VOICERECOGNIZEDLL_API void vr_runRecognizer(void *_recognizer);
	VOICERECOGNIZEDLL_API void vr_pauseRecognize(void *_recognizer, int _microSeconds);
	VOICERECOGNIZEDLL_API void vr_stopRecognize(void *_recognizer);
	VOICERECOGNIZEDLL_API vr_bool vr_isRecognizerStopped(void *_recognizer);
	VOICERECOGNIZEDLL_API int vr_writeData(void *_recognizer, char *_data, int _dataLen);
	int vr_decodeData(char *_hexs, int _hexsLen, int *_hexsCostLen, char *_result, int _resultLen);
	VOICERECOGNIZEDLL_API vr_bool vr_decodeString(int _recogStatus, char *_data, int _dataLen, char *_result, int _resultLen);
	enum InfoType
	{
		IT_WIFI = 0
		, IT_SSID_WIFI = 1
		, IT_PHONE = 2
		, IT_STRING = 3
	};
	VOICERECOGNIZEDLL_API enum InfoType vr_decodeInfoType(char *_data, int _dataLen);
	struct WiFiInfo
	{
		char mac[8];
		int macLen;
		char pwd[80];
		int pwdLen;
	};
	VOICERECOGNIZEDLL_API vr_bool vr_decodeWiFi(int _result, char *_data, int _dataLen, struct WiFiInfo *_wifi);
	struct SSIDWiFiInfo
	{
		char ssid[32];
		int ssidLen;
		char pwd[80];
		int pwdLen;
	};
	VOICERECOGNIZEDLL_API vr_bool vr_decodeSSIDWiFi(int _result, char *_data, int _dataLen, struct SSIDWiFiInfo *_wifi);
	struct PhoneInfo
	{
		char imei[18];
		int imeiLen;
		char phoneName[20];
		int nameLen;
	};
	VOICERECOGNIZEDLL_API vr_bool vr_decodePhone(int _result, char *_data, int _dataLen, struct PhoneInfo *_phone);
#ifdef __cplusplus
}
#endif
#endif