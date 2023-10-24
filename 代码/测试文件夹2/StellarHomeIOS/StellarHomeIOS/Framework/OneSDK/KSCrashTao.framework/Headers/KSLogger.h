#pragma mark - (internal) -
#ifndef HDR_KSLogger_h
#define HDR_KSLogger_h
#ifdef __cplusplus
extern "C" {
#endif
#include <stdbool.h>
    void i_kslog_logC(const char* level,
                      const char* file,
                      int line,
                      const char* function,
                      const char* fmt, ...);
    void i_kslog_logCBasic(const char* fmt, ...);
#ifdef __OBJC__
#import <CoreFoundation/CoreFoundation.h>
void i_kslog_logObjC(const char* level,
                     const char* file,
                     int line,
                     const char* function,
                     CFStringRef fmt, ...);
void i_kslog_logObjCBasic(CFStringRef fmt, ...);
#define i_KSLOG_FULL(LEVEL,FILE,LINE,FUNCTION,FMT,...) i_kslog_logObjC(LEVEL,FILE,LINE,FUNCTION,(__bridge CFStringRef)FMT,##__VA_ARGS__)
#define i_KSLOG_BASIC(FMT, ...) i_kslog_logObjCBasic((__bridge CFStringRef)FMT,##__VA_ARGS__)
#else 
#define i_KSLOG_FULL i_kslog_logC
#define i_KSLOG_BASIC i_kslog_logCBasic
#endif 
#define i_KSLOG_FULL_C i_kslog_logC
#define i_KSLOG_BASIC_C i_kslog_logCBasic
#ifdef KS_NONE
    #define KSLOG_BAK_NONE KS_NONE
    #undef KS_NONE
#endif
#ifdef ERROR
    #define KSLOG_BAK_ERROR ERROR
    #undef ERROR
#endif
#ifdef WARN
    #define KSLOG_BAK_WARN WARN
    #undef WARN
#endif
#ifdef INFO
    #define KSLOG_BAK_INFO INFO
    #undef INFO
#endif
#ifdef DEBUG
    #define KSLOG_BAK_DEBUG DEBUG
    #undef DEBUG
#endif
#ifdef TRACE
    #define KSLOG_BAK_TRACE TRACE
    #undef TRACE
#endif
#define KSLogger_Level_None   0
#define KSLogger_Level_Error 10
#define KSLogger_Level_Warn  20
#define KSLogger_Level_Info  30
#define KSLogger_Level_Debug 40
#define KSLogger_Level_Trace 50
#define KS_NONE  KSLogger_Level_None
#define ERROR KSLogger_Level_Error
#define WARN  KSLogger_Level_Warn
#define INFO  KSLogger_Level_Info
#define DEBUG KSLogger_Level_Debug
#define TRACE KSLogger_Level_Trace
#ifndef KSLogger_Level
    #define KSLogger_Level KSLogger_Level_Error
#endif
#ifndef KSLogger_LocalLevel
    #define KSLogger_LocalLevel KSLogger_Level_None
#endif
#define a_KSLOG_FULL(LEVEL, FMT, ...) \
    i_KSLOG_FULL(LEVEL, \
                 __FILE__, \
                 __LINE__, \
                 __PRETTY_FUNCTION__, \
                 FMT, \
                 ##__VA_ARGS__)
#define a_KSLOG_FULL_C(LEVEL, FMT, ...) \
    i_KSLOG_FULL_C(LEVEL, \
                    __FILE__, \
                    __LINE__, \
                    __PRETTY_FUNCTION__, \
                    FMT, \
                    ##__VA_ARGS__)
#pragma mark - API -
bool kslog_setLogFilename(const char* filename, bool overwrite);
bool kslog_clearLogFile(void);
#define KSLOG_PRINTS_AT_LEVEL(LEVEL) \
    (KSLogger_Level >= LEVEL || KSLogger_LocalLevel >= LEVEL)
#define KSLOG_ALWAYS(FMT, ...) a_KSLOG_FULL("FORCE", FMT, ##__VA_ARGS__)
#define KSLOGBASIC_ALWAYS(FMT, ...) i_KSLOG_BASIC(FMT, ##__VA_ARGS__)
#if KSLOG_PRINTS_AT_LEVEL(KSLogger_Level_Error)
    #define KSLOG_ERROR(FMT, ...) a_KSLOG_FULL("ERROR", FMT, ##__VA_ARGS__)
    #define KSLOG_ERROR_C(FMT, ...) a_KSLOG_FULL_C("ERROR", FMT, ##__VA_ARGS__)
    #define KSLOGBASIC_ERROR(FMT, ...) i_KSLOG_BASIC(FMT, ##__VA_ARGS__)
#else
    #define KSLOG_ERROR(FMT, ...)
    #define KSLOGBASIC_ERROR(FMT, ...)
#endif
#if KSLOG_PRINTS_AT_LEVEL(KSLogger_Level_Warn)
    #define KSLOG_WARN(FMT, ...)  a_KSLOG_FULL("WARN ", FMT, ##__VA_ARGS__)
    #define KSLOGBASIC_WARN(FMT, ...) i_KSLOG_BASIC(FMT, ##__VA_ARGS__)
#else
    #define KSLOG_WARN(FMT, ...)
    #define KSLOGBASIC_WARN(FMT, ...)
#endif
#if KSLOG_PRINTS_AT_LEVEL(KSLogger_Level_Info)
    #define KSLOG_INFO(FMT, ...)  a_KSLOG_FULL("INFO ", FMT, ##__VA_ARGS__)
    #define KSLOGBASIC_INFO(FMT, ...) i_KSLOG_BASIC(FMT, ##__VA_ARGS__)
#else
    #define KSLOG_INFO(FMT, ...)
    #define KSLOGBASIC_INFO(FMT, ...)
#endif
#if KSLOG_PRINTS_AT_LEVEL(KSLogger_Level_Debug)
    #define KSLOG_DEBUG(FMT, ...) a_KSLOG_FULL("DEBUG", FMT, ##__VA_ARGS__)
    #define KSLOG_DEBUG_C(FMT, ...) a_KSLOG_FULL_C("DEBUG", FMT, ##__VA_ARGS__)
    #define KSLOGBASIC_DEBUG(FMT, ...) i_KSLOG_BASIC(FMT, ##__VA_ARGS__)
#else
    #define KSLOG_DEBUG(FMT, ...)
    #define KSLOG_DEBUG_C(FMT, ...)
    #define KSLOGBASIC_DEBUG(FMT, ...)
#endif
#if KSLOG_PRINTS_AT_LEVEL(KSLogger_Level_Trace)
    #define KSLOG_TRACE(FMT, ...) a_KSLOG_FULL("TRACE", FMT, ##__VA_ARGS__)
    #define KSLOGBASIC_TRACE(FMT, ...) i_KSLOG_BASIC(FMT, ##__VA_ARGS__)
#else
    #define KSLOG_TRACE(FMT, ...)
    #define KSLOGBASIC_TRACE(FMT, ...)
#endif
#pragma mark - (internal) -
#undef ERROR
#ifdef KSLOG_BAK_ERROR
    #define ERROR KSLOG_BAK_ERROR
    #undef KSLOG_BAK_ERROR
#endif
#undef WARNING
#ifdef KSLOG_BAK_WARN
    #define WARNING KSLOG_BAK_WARN
    #undef KSLOG_BAK_WARN
#endif
#undef INFO
#ifdef KSLOG_BAK_INFO
    #define INFO KSLOG_BAK_INFO
    #undef KSLOG_BAK_INFO
#endif
#undef DEBUG
#ifdef KSLOG_BAK_DEBUG
    #define DEBUG KSLOG_BAK_DEBUG
    #undef KSLOG_BAK_DEBUG
#endif
#undef TRACE
#ifdef KSLOG_BAK_TRACE
    #define TRACE KSLOG_BAK_TRACE
    #undef KSLOG_BAK_TRACE
#endif
#ifdef __cplusplus
}
#endif
#endif 