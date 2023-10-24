#import <Foundation/Foundation.h>
#import <dispatch/dispatch.h>
#import <TargetConditionals.h>
#import <Availability.h>
NS_ASSUME_NONNULL_BEGIN
extern NSString *const GCDAsyncUdpSocketException;
extern NSString *const GCDAsyncUdpSocketErrorDomain;
extern NSString *const GCDAsyncUdpSocketQueueName;
extern NSString *const GCDAsyncUdpSocketThreadName;
typedef NS_ERROR_ENUM(GCDAsyncUdpSocketErrorDomain, GCDAsyncUdpSocketError) {
	GCDAsyncUdpSocketNoError = 0,          
	GCDAsyncUdpSocketBadConfigError,       
	GCDAsyncUdpSocketBadParamError,        
	GCDAsyncUdpSocketSendTimeoutError,     
	GCDAsyncUdpSocketClosedError,          
	GCDAsyncUdpSocketOtherError,           
};
#pragma mark -
@class GCDAsyncUdpSocket;
@protocol GCDAsyncUdpSocketDelegate <NSObject>
@optional
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didConnectToAddress:(NSData *)address;
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didNotConnect:(NSError * _Nullable)error;
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didSendDataWithTag:(long)tag;
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError * _Nullable)error;
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data
                                             fromAddress:(NSData *)address
                                       withFilterContext:(nullable id)filterContext;
- (void)udpSocketDidClose:(GCDAsyncUdpSocket *)sock withError:(NSError  * _Nullable)error;
@end
typedef BOOL (^GCDAsyncUdpSocketReceiveFilterBlock)(NSData *data, NSData *address, id __nullable * __nonnull context);
typedef BOOL (^GCDAsyncUdpSocketSendFilterBlock)(NSData *data, NSData *address, long tag);
@interface GCDAsyncUdpSocket : NSObject
- (instancetype)init;
- (instancetype)initWithSocketQueue:(nullable dispatch_queue_t)sq;
- (instancetype)initWithDelegate:(nullable id<GCDAsyncUdpSocketDelegate>)aDelegate delegateQueue:(nullable dispatch_queue_t)dq;
- (instancetype)initWithDelegate:(nullable id<GCDAsyncUdpSocketDelegate>)aDelegate delegateQueue:(nullable dispatch_queue_t)dq socketQueue:(nullable dispatch_queue_t)sq NS_DESIGNATED_INITIALIZER;
#pragma mark Configuration
- (nullable id<GCDAsyncUdpSocketDelegate>)delegate;
- (void)setDelegate:(nullable id<GCDAsyncUdpSocketDelegate>)delegate;
- (void)synchronouslySetDelegate:(nullable id<GCDAsyncUdpSocketDelegate>)delegate;
- (nullable dispatch_queue_t)delegateQueue;
- (void)setDelegateQueue:(nullable dispatch_queue_t)delegateQueue;
- (void)synchronouslySetDelegateQueue:(nullable dispatch_queue_t)delegateQueue;
- (void)getDelegate:(id<GCDAsyncUdpSocketDelegate> __nullable * __nullable)delegatePtr delegateQueue:(dispatch_queue_t __nullable * __nullable)delegateQueuePtr;
- (void)setDelegate:(nullable id<GCDAsyncUdpSocketDelegate>)delegate delegateQueue:(nullable dispatch_queue_t)delegateQueue;
- (void)synchronouslySetDelegate:(nullable id<GCDAsyncUdpSocketDelegate>)delegate delegateQueue:(nullable dispatch_queue_t)delegateQueue;
- (BOOL)isIPv4Enabled;
- (void)setIPv4Enabled:(BOOL)flag;
- (BOOL)isIPv6Enabled;
- (void)setIPv6Enabled:(BOOL)flag;
- (BOOL)isIPv4Preferred;
- (BOOL)isIPv6Preferred;
- (BOOL)isIPVersionNeutral;
- (void)setPreferIPv4;
- (void)setPreferIPv6;
- (void)setIPVersionNeutral;
- (uint16_t)maxReceiveIPv4BufferSize;
- (void)setMaxReceiveIPv4BufferSize:(uint16_t)max;
- (uint32_t)maxReceiveIPv6BufferSize;
- (void)setMaxReceiveIPv6BufferSize:(uint32_t)max;
- (uint16_t)maxSendBufferSize;
- (void)setMaxSendBufferSize:(uint16_t)max;
- (nullable id)userData;
- (void)setUserData:(nullable id)arbitraryUserData;
#pragma mark Diagnostics
- (nullable NSData *)localAddress;
- (nullable NSString *)localHost;
- (uint16_t)localPort;
- (nullable NSData *)localAddress_IPv4;
- (nullable NSString *)localHost_IPv4;
- (uint16_t)localPort_IPv4;
- (nullable NSData *)localAddress_IPv6;
- (nullable NSString *)localHost_IPv6;
- (uint16_t)localPort_IPv6;
- (nullable NSData *)connectedAddress;
- (nullable NSString *)connectedHost;
- (uint16_t)connectedPort;
- (BOOL)isConnected;
- (BOOL)isClosed;
- (BOOL)isIPv4;
- (BOOL)isIPv6;
#pragma mark Binding
- (BOOL)bindToPort:(uint16_t)port error:(NSError **)errPtr;
- (BOOL)bindToPort:(uint16_t)port interface:(nullable NSString *)interface error:(NSError **)errPtr;
- (BOOL)bindToAddress:(NSData *)localAddr error:(NSError **)errPtr;
#pragma mark Connecting
- (BOOL)connectToHost:(NSString *)host onPort:(uint16_t)port error:(NSError **)errPtr;
- (BOOL)connectToAddress:(NSData *)remoteAddr error:(NSError **)errPtr;
#pragma mark Multicast
- (BOOL)joinMulticastGroup:(NSString *)group error:(NSError **)errPtr;
- (BOOL)joinMulticastGroup:(NSString *)group onInterface:(nullable NSString *)interface error:(NSError **)errPtr;
- (BOOL)leaveMulticastGroup:(NSString *)group error:(NSError **)errPtr;
- (BOOL)leaveMulticastGroup:(NSString *)group onInterface:(nullable NSString *)interface error:(NSError **)errPtr;
- (BOOL)sendIPv4MulticastOnInterface:(NSString*)interface error:(NSError **)errPtr;
- (BOOL)sendIPv6MulticastOnInterface:(NSString*)interface error:(NSError **)errPtr;
#pragma mark Reuse Port
- (BOOL)enableReusePort:(BOOL)flag error:(NSError **)errPtr;
#pragma mark Broadcast
- (BOOL)enableBroadcast:(BOOL)flag error:(NSError **)errPtr;
#pragma mark Sending
- (void)sendData:(NSData *)data withTimeout:(NSTimeInterval)timeout tag:(long)tag;
- (void)sendData:(NSData *)data
          toHost:(NSString *)host
            port:(uint16_t)port
     withTimeout:(NSTimeInterval)timeout
             tag:(long)tag;
- (void)sendData:(NSData *)data toAddress:(NSData *)remoteAddr withTimeout:(NSTimeInterval)timeout tag:(long)tag;
- (void)setSendFilter:(nullable GCDAsyncUdpSocketSendFilterBlock)filterBlock withQueue:(nullable dispatch_queue_t)filterQueue;
- (void)setSendFilter:(nullable GCDAsyncUdpSocketSendFilterBlock)filterBlock
            withQueue:(nullable dispatch_queue_t)filterQueue
       isAsynchronous:(BOOL)isAsynchronous;
#pragma mark Receiving
- (BOOL)receiveOnce:(NSError **)errPtr;
- (BOOL)beginReceiving:(NSError **)errPtr;
- (void)pauseReceiving;
- (void)setReceiveFilter:(nullable GCDAsyncUdpSocketReceiveFilterBlock)filterBlock withQueue:(nullable dispatch_queue_t)filterQueue;
- (void)setReceiveFilter:(nullable GCDAsyncUdpSocketReceiveFilterBlock)filterBlock
               withQueue:(nullable dispatch_queue_t)filterQueue
          isAsynchronous:(BOOL)isAsynchronous;
#pragma mark Closing
- (void)close;
- (void)closeAfterSending;
#pragma mark Advanced
- (void)markSocketQueueTargetQueue:(dispatch_queue_t)socketQueuesPreConfiguredTargetQueue;
- (void)unmarkSocketQueueTargetQueue:(dispatch_queue_t)socketQueuesPreviouslyConfiguredTargetQueue;
- (void)performBlock:(dispatch_block_t)block;
- (int)socketFD;
- (int)socket4FD;
- (int)socket6FD;
#if TARGET_OS_IPHONE
- (nullable CFReadStreamRef)readStream;
- (nullable CFWriteStreamRef)writeStream;
#endif
#pragma mark Utilities
+ (nullable NSString *)hostFromAddress:(NSData *)address;
+ (uint16_t)portFromAddress:(NSData *)address;
+ (int)familyFromAddress:(NSData *)address;
+ (BOOL)isIPv4Address:(NSData *)address;
+ (BOOL)isIPv6Address:(NSData *)address;
+ (BOOL)getHost:(NSString * __nullable * __nullable)hostPtr port:(uint16_t * __nullable)portPtr fromAddress:(NSData *)address;
+ (BOOL)getHost:(NSString * __nullable * __nullable)hostPtr port:(uint16_t * __nullable)portPtr family:(int * __nullable)afPtr fromAddress:(NSData *)address;
@end
NS_ASSUME_NONNULL_END