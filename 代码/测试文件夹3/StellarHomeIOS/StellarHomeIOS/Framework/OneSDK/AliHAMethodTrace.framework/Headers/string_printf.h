#ifndef ART_RUNTIME_BASE_STRINGPRINTF_H_
#define ART_RUNTIME_BASE_STRINGPRINTF_H_
#include <stdarg.h>
#include <string>
namespace instrument {
    std::string StringPrintf(const char* fmt, ...)
            __attribute__((__format__(__printf__, 1, 2)));
    void StringAppendF(std::string* dst, const char* fmt, ...)
            __attribute__((__format__(__printf__, 2, 3)));
    void StringAppendV(std::string* dst, const char* format, va_list ap);
}  
#endif  