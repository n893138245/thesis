#ifndef AliHAMethodTrace_h
#define AliHAMethodTrace_h
#define FRAME_COUNT_LIMIT 256
#define PRINT_LOG(msg) do { printf("%s\n", msg); } while(0);
#ifndef TEMP_FAILURE_RETRY
#define TEMP_FAILURE_RETRY(exp) ({ \
decltype(exp) _rc; \
do { \
_rc = (exp); \
} while (_rc == -1 && errno == EINTR); \
_rc; })
#endif
#endif 