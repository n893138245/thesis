#ifndef sampling_h
#define sampling_h
#include <mach/mach.h>
namespace instrument {
    struct SamplingParameter {
        int sampleing_interval_;
        void (*sampling_callback_)(thread_t thread);
    };
    class SamplingThread final {
    public:
        static void* RunSamplingThread(void* arg);
        static void StopSampling();
        static void GetBackTrace(thread_t thread, uintptr_t *backtrace, int *count);
    };
}
#endif 