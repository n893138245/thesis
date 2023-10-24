#ifndef trace_file_h
#define trace_file_h
#include <stdint.h>
#include <stdlib.h>
#include <map>
#include <thread>
#include <vector>
#include <string>
#include <mutex>
#include <condition_variable>
#include <sstream>
namespace instrument {
    static const char*    kTraceHotDataTrimName       = "hotdata.trim.trace";
    class TraceFile final {
    public:
        static bool Init(const char* session_dir,
                         uint32_t buffer_size,
                         uint64_t app_start_time,
                         std::map<const char*, const char*> app_info_properties,
                         std::map<const char*, const char*> device_info_properties,
                         std::map<const char*, const char*> type_descriptors);
        static void FlushCachedData(const char* session_dir);
        static void Append(uint16_t type, uint64_t time);
        static void Append(uint32_t type, uint64_t time, float params[], uint16_t param_size);
        static void Append(uint16_t type, uint64_t time, const char* data);
        static void Append(uint16_t type, uint64_t time, const char* data, float params[], uint16_t param_size);
        static void Append(uint16_t type, uint64_t time, const char* data, const char* desc);
        static void Append(uint16_t type, uint64_t time, const char* data, const char* desc, float params[], uint16_t param_size);
        static void Append(uint16_t type, uint64_t time, uint8_t* data, uint32_t size);
        ~TraceFile();
    private:
        void PrivateAppend(uint16_t type, uint64_t time);
        void PrivateAppend(uint32_t type, uint64_t time, float params[], uint16_t param_size);
        void PrivateAppend(uint16_t type, uint64_t time, const char* data);
        void PrivateAppend(uint16_t type, uint64_t time, const char* data, float params[], uint16_t param_size);
        void PrivateAppend(uint16_t type, uint64_t time, const char* data, const char* desc);
        void PrivateAppend(uint16_t type, uint64_t time, const char* data, const char* desc, float params[], uint16_t param_size);
        void PrivateAppend(uint16_t type, uint64_t time, uint8_t* data, uint32_t size);
    private:
        bool fatal_error_;
        std::string session_dir_;
        bool use_mmap_;
        uint8_t* buffer_;
        uint32_t buffer_size_;
        uint32_t cur_offset_;
        uint32_t binary_offset_;
        const uint32_t offset_boundary_;
        uint64_t start_time_;
        std::mutex buffer_op_mutex_;
        std::condition_variable dump_thread_cv_;
        std::mutex dump_thread_cv_mtx_;
    private:
        TraceFile(const char* session_dir, uint32_t buffer_size, uint64_t app_start_time);
        void AppendHeader(uint16_t type, uint64_t time, uint32_t body_size);
        void AppendString(const char *data, uint32_t length);
        bool CheckBufferOverflow();
        void AsyncLoopAndDump();
        void WaitUntilBufferOverflow();
        uint8_t* GetBufferedData(uint32_t *buffered_size);
    };
}
#endif 