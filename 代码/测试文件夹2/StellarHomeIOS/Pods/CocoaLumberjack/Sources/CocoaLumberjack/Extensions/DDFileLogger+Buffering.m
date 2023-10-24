#import <sys/mount.h>
#import <CocoaLumberjack/DDFileLogger+Buffering.h>
#import "../DDFileLogger+Internal.h"
static const NSUInteger kDDDefaultBufferSize = 4096; 
static const NSUInteger kDDMaxBufferSize = 1048576; 
static inline NSUInteger p_DDGetDefaultBufferSizeBytesMax(const BOOL max) {
    struct statfs *mountedFileSystems = NULL;
    int count = getmntinfo(&mountedFileSystems, 0);
    for (int i = 0; i < count; i++) {
        struct statfs mounted = mountedFileSystems[i];
        const char *name = mounted.f_mntonname;
        if (strnlen(name, 2) == 1 && *name == '/') {
            return max ? (NSUInteger)mounted.f_iosize : (NSUInteger)mounted.f_bsize;
        }
    }
    return max ? kDDMaxBufferSize : kDDDefaultBufferSize;
}
static NSUInteger DDGetMaxBufferSizeBytes() {
    static NSUInteger maxBufferSize = 0;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        maxBufferSize = p_DDGetDefaultBufferSizeBytesMax(YES);
    });
    return maxBufferSize;
}
static NSUInteger DDGetDefaultBufferSizeBytes() {
    static NSUInteger defaultBufferSize = 0;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultBufferSize = p_DDGetDefaultBufferSizeBytesMax(NO);
    });
    return defaultBufferSize;
}
@interface DDBufferedProxy : NSProxy
@property (nonatomic) DDFileLogger *fileLogger;
@property (nonatomic) NSOutputStream *buffer;
@property (nonatomic) NSUInteger maxBufferSizeBytes;
@property (nonatomic) NSUInteger currentBufferSizeBytes;
@end
@implementation DDBufferedProxy
- (instancetype)initWithFileLogger:(DDFileLogger *)fileLogger {
    _fileLogger = fileLogger;
    _maxBufferSizeBytes = DDGetDefaultBufferSizeBytes();
    [self flushBuffer];
    return self;
}
- (void)dealloc {
    dispatch_block_t block = ^{
        [self lt_sendBufferedDataToFileLogger];
        self.fileLogger = nil;
    };
    if ([self->_fileLogger isOnInternalLoggerQueue]) {
        block();
    } else {
        dispatch_sync(self->_fileLogger.loggerQueue, block);
    }
}
#pragma mark - Buffering
- (void)flushBuffer {
    [_buffer close];
    _buffer = [NSOutputStream outputStreamToMemory];
    [_buffer open];
    _currentBufferSizeBytes = 0;
}
- (void)lt_sendBufferedDataToFileLogger {
    NSData *data = [_buffer propertyForKey:NSStreamDataWrittenToMemoryStreamKey];
    [_fileLogger lt_logData:data];
    [self flushBuffer];
}
#pragma mark - Logging
- (void)logMessage:(DDLogMessage *)logMessage {
    NSData *data = [_fileLogger lt_dataForMessage:logMessage];
    if (data.length == 0) {
        return;
    }
    [data enumerateByteRangesUsingBlock:^(const void * __nonnull bytes, NSRange byteRange, BOOL * __nonnull __unused stop) {
        NSUInteger bytesLength = byteRange.length;
#ifdef NS_BLOCK_ASSERTIONS
        __unused
#endif
        NSInteger written = [_buffer write:bytes maxLength:bytesLength];
        NSAssert(written > 0 && (NSUInteger)written == bytesLength, @"Failed to write to memory buffer.");
        _currentBufferSizeBytes += bytesLength;
        if (_currentBufferSizeBytes >= _maxBufferSizeBytes) {
            [self lt_sendBufferedDataToFileLogger];
        }
    }];
}
- (void)flush {
    dispatch_block_t block = ^{
        @autoreleasepool {
            [self lt_sendBufferedDataToFileLogger];
            [self.fileLogger flush];
        }
    };
    if ([self.fileLogger isOnInternalLoggerQueue]) {
        block();
    } else {
        dispatch_queue_t globalLoggingQueue = [DDLog loggingQueue];
        NSAssert(![self.fileLogger isOnGlobalLoggingQueue], @"Core architecture requirement failure");
        dispatch_sync(globalLoggingQueue, ^{
            dispatch_sync(self.fileLogger.loggerQueue, block);
        });
    }
}
#pragma mark - Properties
- (void)setMaxBufferSizeBytes:(NSUInteger)newBufferSizeBytes {
    _maxBufferSizeBytes = MIN(newBufferSizeBytes, DDGetMaxBufferSizeBytes());
}
#pragma mark - Wrapping
- (DDFileLogger *)wrapWithBuffer {
    return (DDFileLogger *)self;
}
- (DDFileLogger *)unwrapFromBuffer {
    return (DDFileLogger *)self.fileLogger;
}
#pragma mark - NSProxy
- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel {
    return [self.fileLogger methodSignatureForSelector:sel];
}
- (BOOL)respondsToSelector:(SEL)aSelector {
    return [self.fileLogger respondsToSelector:aSelector];
}
- (void)forwardInvocation:(NSInvocation *)invocation {
    [invocation invokeWithTarget:self.fileLogger];
}
@end
@implementation DDFileLogger (Buffering)
- (instancetype)wrapWithBuffer {
    return (DDFileLogger *)[[DDBufferedProxy alloc] initWithFileLogger:self];
}
- (instancetype)unwrapFromBuffer {
    return self;
}
@end