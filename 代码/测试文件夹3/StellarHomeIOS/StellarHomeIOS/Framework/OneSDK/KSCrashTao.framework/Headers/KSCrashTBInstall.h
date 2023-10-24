#ifndef KSCrashTBInstall_h
#define KSCrashTBInstall_h
#include <stdio.h>
#include <mach/mach_types.h>
#import <KSCrashTao/KSCrashMonitorType.h>
typedef struct KSCrashTBConfig
{
    void (*justOnCrash)(void);
    post_crash_callback_t postCrashCallback;
    const char *(*getCurrentViewName)(void);
} KSCrashTBConfig;
bool kscrash_tb_install(KSCrashTBConfig config);
int64_t kscrash_tb_getPendingCrashReportId(void);
void kscrash_tb_deleteAllPendingCrashReport(void);
void kscrash_tb_deletePendingCrashReport(int64_t reportId);
NSData *kscrash_readDataOfReport(int64_t reportId, NSError **outError);
typedef const char *(*KSCrashTBAdditionInfoWriter)(thread_t crashThread, void *crashUContext);
bool  kscrash_tb_add_additionInfoWriter(KSCrashTBAdditionInfoWriter writer);
#endif 