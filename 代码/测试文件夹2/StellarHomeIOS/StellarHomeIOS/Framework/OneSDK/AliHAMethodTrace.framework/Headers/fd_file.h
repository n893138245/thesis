#ifndef FDFile_hpp
#define FDFile_hpp
#include <stdio.h>
namespace instrument {
    class FdFile {
    public:
        int fd;
        FdFile(int fd);
        virtual bool WriteFully(const char *buffer, size_t byte_count);
        virtual bool Close();
    };
    typedef FdFile File;
}
#endif 