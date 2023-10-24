#include <stdio.h>
#include <mach-o/loader.h>
#include <string>
namespace instrument {
    uintptr_t firstCmdAfterHeader(const struct mach_header *header);
    void printBinaryImages(std::ostringstream &os);
}