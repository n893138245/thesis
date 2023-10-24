#ifndef trace_h
#define trace_h
#include <mach/mach.h>
#include <iostream>
#include "fd_file.h"
#include "light_hashmap.h"
#include "AliHAMethodTrace.h"
namespace instrument {
    enum MethodTraceEvent {
        kMethodEntered = 0x00,
        kMethodExited = 0x01,
        kMethodUnwind = 0x02,
        kMethodInject = 0x03
    };
    typedef struct ThreadData {
        unsigned int thread_id; 
        char thread_name[10]; 
        uintptr_t last_stack_trace[FRAME_COUNT_LIMIT]; 
        uint8_t num_frames_of_last_stack_trace; 
    } ThreadData;
    typedef struct EventData {
        char event_name[256];
    } EventData;
    class Trace 
    {
    public:
        static void Start(int trace_fd, int buffer_size, int sampling_interval_us, bool use_mmap);
        static void Stop();
        static void InjectEvent(const char *event);
    private:
        File* trace_file_; 
        int64_t trace_start_time_; 
        uint8_t *buffer_; 
        const bool use_mmap_; 
        const int buffer_size_; 
        int32_t header_data_start_position_; 
        int32_t trace_data_start_position_; 
        int32_t current_offset_; 
        bool overflow_; 
        map_t thread_map_; 
        ThreadData *thread_data_slots_; 
        int cur_thread_slot_; 
        map_t method_map_; 
        EventData *event_data_slots_; 
        int cur_event_slot_; 
        explicit Trace(File* trace_file, int buffer_size, bool use_mmap);
        static void GetSample(thread_t thread);
        void DumpThreadList(std::ostringstream &os);
        void DumpMethodList(std::ostringstream &os);
        void ReadClocks(thread_t thread, uint32_t *thread_clock_diff, uint32_t *wall_clock_diff);
        void CompareAndMergeStackTrace(thread_t thread, uintptr_t *stack_trace, int num_frames);
        void LogMethodTraceEvent(thread_t thread, uintptr_t return_address, uint32_t thread_clock_diff, uint32_t wall_clock_diff, MethodTraceEvent event);
        void AppendEvent(const char * event);
        std::string GenerateTraceHeader();
        void FinishTracing();
    };
}
#endif 