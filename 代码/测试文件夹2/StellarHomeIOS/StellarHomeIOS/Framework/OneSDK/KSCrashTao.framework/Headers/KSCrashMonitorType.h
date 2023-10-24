#ifndef HDR_KSCrashMonitorType_h
#define HDR_KSCrashMonitorType_h
#include <stdio.h>
#include <mach/mach_types.h>
#ifdef __cplusplus
extern "C" {
#endif
typedef enum
{
    KSCrashMonitorTypeMachException      = 0x01,
    KSCrashMonitorTypeSignal             = 0x02,
    KSCrashMonitorTypeCPPException       = 0x04,
    KSCrashMonitorTypeNSException        = 0x08,
    KSCrashMonitorTypeMainThreadDeadlock = 0x10,
    KSCrashMonitorTypeUserReported       = 0x20,
    KSCrashMonitorTypeSystem             = 0x40,
    KSCrashMonitorTypeApplicationState   = 0x80,
    KSCrashMonitorTypeZombie             = 0x100,
} KSCrashMonitorType;
#define KSCrashMonitorTypeAll              \
(                                          \
    KSCrashMonitorTypeMachException      | \
    KSCrashMonitorTypeSignal             | \
    KSCrashMonitorTypeCPPException       | \
    KSCrashMonitorTypeNSException        | \
    KSCrashMonitorTypeMainThreadDeadlock | \
    KSCrashMonitorTypeUserReported       | \
    KSCrashMonitorTypeSystem             | \
    KSCrashMonitorTypeApplicationState   | \
    KSCrashMonitorTypeZombie               \
)
#define KSCrashMonitorTypeExperimental     \
(                                          \
    KSCrashMonitorTypeMainThreadDeadlock   \
)
#define KSCrashMonitorTypeDebuggerUnsafe   \
(                                          \
    KSCrashMonitorTypeMachException      | \
    KSCrashMonitorTypeSignal             | \
    KSCrashMonitorTypeCPPException       | \
    KSCrashMonitorTypeNSException          \
)
#define KSCrashMonitorTypeAsyncSafe        \
(                                          \
    KSCrashMonitorTypeMachException      | \
    KSCrashMonitorTypeSignal               \
)
#define KSCrashMonitorTypeOptional         \
(                                          \
    KSCrashMonitorTypeZombie               \
)
#define KSCrashMonitorTypeAsyncUnsafe (KSCrashMonitorTypeAll & (~KSCrashMonitorTypeAsyncSafe))
#define KSCrashMonitorTypeDebuggerSafe (KSCrashMonitorTypeAll & (~KSCrashMonitorTypeDebuggerUnsafe))
#define KSCrashMonitorTypeProductionSafe (KSCrashMonitorTypeAll & (~KSCrashMonitorTypeExperimental))
#define KSCrashMonitorTypeProductionSafeMinimal (KSCrashMonitorTypeProductionSafe & (~KSCrashMonitorTypeOptional))
#define KSCrashMonitorTypeRequired (KSCrashMonitorTypeSystem | KSCrashMonitorTypeApplicationState)
#define KSCrashMonitorTypeManual (KSCrashMonitorTypeRequired | KSCrashMonitorTypeUserReported)
#define KSCrashMonitorTypeNone 0
const char* kscrashmonitortype_name(KSCrashMonitorType monitorType);
typedef void (*post_crash_callback_t)(int64_t reportId, void *ucontext, const char *reason, thread_t thread, boolean_t isMachException, uintptr_t errorPtr);
#ifdef __cplusplus
}
#endif
#endif 