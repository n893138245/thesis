#ifndef log_file_hpp
#define log_file_hpp
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
    enum LogLevel { OFF = 0, ErrorLevel = 1, WarnLevel = 2, InfoLevel = 3, DebugLevel = 4 };
    class LogFile final {
    public:
        static bool Init(const char* log_dir,
                            uint32_t buffer_size,
                         const char* app_key, uint32_t app_key_length,
                         const char* secret, uint32_t secret_length,
                         const char* secret_sign, uint32_t secret_sign_length,
                         const char* rsa_public_key_md5, uint32_t rsa_public_key_md5_length);
        static void SetLogLevel(LogLevel log_level);
        static void AppendLog(LogLevel log_level, const char* type, const char* module, const char* tag, const char* time_str, const char* content, const char *exception);
        static void AppendLog(LogLevel log_level, const char* module, const char* content);
        static void FlushHotData();
        static void DeleteAllLogs();
        static std::string GetLogFileName(uint32_t days_to_today);
    private:
        void PrivateSetLogLevel(LogLevel log_level);
        void PrivateAppendLog(LogLevel log_level, const char* type, const char* module, const char* tag, const char* time_str, const char* content, const char* exception);
        void PrivateAppendLog(LogLevel log_level, const char* module, const char* content);
        void PrivateFlushHotData();
        void PrivateDeleteAllLogs();
        ~LogFile();
    private:
        LogFile(const char* log_dir,
                uint32_t buffer_size,
                const char* app_key, uint32_t app_key_length,
                const char* secret, uint32_t secret_length,
                const char* secret_sign, uint32_t secret_sign_length,
                const char* rsa_public_key_md5, uint32_t rsa_public_key_md5_length);
        void InitCache();
        void CheckLog();
        void DeleteExpiredData();
        void GenerateLogHeader(uint8_t *header_buffer, uint32_t *header_length);
        void WriteLogSecretBlock();
        bool CheckBufferOverflow();
        void WaitUntilBufferOverflow();
        void AsyncLoopAndDump();
        void FlushCachedData();
        uint8_t* GetBufferedData(uint32_t* buffered_size);
    private:
        bool fatal_error_;
        bool use_mmap_;
        char* secret_;
        const uint32_t secret_length_;
        char* app_key_;
        const uint32_t app_key_length_;
        char* secret_sign_;
        const uint32_t secret_sign_length_;
        char* rsa_public_key_md5_;
        const uint32_t rsa_public_key_md5_length_;
        LogLevel log_level_;
        const std::string log_dir_;
        const std::string today_log_file_name_;
        uint8_t* buffer_;
        uint32_t buffer_size_;
        uint32_t cur_offset_;
        const uint32_t offset_boundary_;
        std::mutex buffer_op_mutex_;
        std::condition_variable dump_thread_cv_;
        std::mutex dump_thread_cv_mtx_;
        uint32_t log_index_;
    };
}
#endif 