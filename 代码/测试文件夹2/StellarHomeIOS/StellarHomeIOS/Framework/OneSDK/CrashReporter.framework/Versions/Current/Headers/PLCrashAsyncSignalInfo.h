#ifndef PLCRASH_ASYNC_SIGNAL_INFO_H
#define PLCRASH_ASYNC_SIGNAL_INFO_H
#ifdef __cplusplus
extern "C" {
#endif
const char *plcrash_async_signal_signame (int signal);
const char *plcrash_async_signal_sigcode (int signal, int si_code);
#ifdef __cplusplus
}
#endif
#endif 