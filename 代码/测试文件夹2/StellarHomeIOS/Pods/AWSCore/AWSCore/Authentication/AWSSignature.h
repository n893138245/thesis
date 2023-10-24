#import <Foundation/Foundation.h>
#import "AWSNetworking.h"
FOUNDATION_EXPORT NSString * _Nonnull const AWSSignatureV4Algorithm;
FOUNDATION_EXPORT NSString * _Nonnull const AWSSignatureV4Terminator;
@class AWSEndpoint;
@protocol AWSCredentialsProvider;
@interface AWSSignatureSignerUtility : NSObject
+ (NSData * _Nonnull)sha256HMacWithData:(NSData * _Nullable)data withKey:(NSData * _Nonnull)key;
+ (NSString * _Nonnull)hashString:(NSString * _Nullable)stringToHash;
+ (NSData * _Nonnull)hash:(NSData * _Nullable)dataToHash;
+ (NSString * _Nonnull)hexEncode:(NSString * _Nullable)string;
+ (NSString * _Nullable)HMACSign:(NSData * _Nullable)data withKey:(NSString * _Nonnull)key usingAlgorithm:(uint32_t)algorithm;
@end
@interface AWSSignatureV4Signer : NSObject <AWSNetworkingRequestInterceptor>
@property (nonatomic, strong, readonly) id<AWSCredentialsProvider> _Nonnull credentialsProvider;
- (instancetype _Nonnull)initWithCredentialsProvider:(id<AWSCredentialsProvider> _Nonnull)credentialsProvider
                                   endpoint:(AWSEndpoint * _Nonnull)endpoint;
+ (AWSTask<NSURL *> * _Nonnull)generateQueryStringForSignatureV4WithCredentialProvider:(id<AWSCredentialsProvider> _Nonnull)credentialsProvider
                                                                            httpMethod:(AWSHTTPMethod)httpMethod
                                                                        expireDuration:(int32_t)expireDuration
                                                                              endpoint:(AWSEndpoint * _Nonnull)endpoint
                                                                               keyPath:(NSString * _Nullable)keyPath
                                                                        requestHeaders:(NSDictionary<NSString *, NSString *> * _Nullable)requestHeaders
                                                                     requestParameters:(NSDictionary<NSString *, id> * _Nullable)requestParameters
                                                                              signBody:(BOOL)signBody;
+ (AWSTask<NSURL *> * _Nonnull)sigV4SignedURLWithRequest:(NSURLRequest * _Nonnull)request
                                      credentialProvider:(id<AWSCredentialsProvider> _Nonnull)credentialsProvider
                                              regionName:(NSString * _Nonnull)regionName
                                             serviceName:(NSString * _Nonnull)serviceName
                                                    date:(NSDate * _Nonnull)date
                                          expireDuration:(int32_t)expireDuration
                                                signBody:(BOOL)signBody
                                        signSessionToken:(BOOL)signSessionToken;
+ (NSString * _Nonnull)getCanonicalizedRequest:(NSString * _Nonnull)method
                                 path:(NSString * _Nonnull)path
                                query:(NSString * _Nullable)query
                              headers:(NSDictionary * _Nullable)headers
                        contentSha256:(NSString * _Nullable)contentSha256;
+ (NSData * _Nonnull)getV4DerivedKey:(NSString * _Nullable)secret
                       date:(NSString * _Nullable)dateStamp
                     region:(NSString * _Nullable)regionName
                    service:(NSString * _Nullable)serviceName;
+ (NSString * _Nonnull)getSignedHeadersString:(NSDictionary * _Nullable)headers;
@end
@interface AWSSignatureV2Signer : NSObject <AWSNetworkingRequestInterceptor>
@property (nonatomic, strong, readonly) id<AWSCredentialsProvider> _Nullable credentialsProvider;
+ (instancetype _Nonnull)signerWithCredentialsProvider:(id<AWSCredentialsProvider> _Nonnull)credentialsProvider
                                     endpoint:(AWSEndpoint * _Nonnull)endpoint;
- (instancetype _Nonnull)initWithCredentialsProvider:(id<AWSCredentialsProvider> _Nonnull)credentialsProvider
                                   endpoint:(AWSEndpoint * _Nonnull)endpoint;
@end
@interface AWSS3ChunkedEncodingInputStream : NSInputStream <NSStreamDelegate>
@property (atomic, assign) int64_t totalLengthOfChunkSignatureSent;
- (instancetype _Nonnull )initWithInputStream:(NSInputStream * _Nonnull)stream
                                         date:(NSDate * _Nullable)date
                                        scope:(NSString * _Nullable)scope
                                     kSigning:(NSData * _Nullable)kSigning
                              headerSignature:(NSString * _Nullable)headerSignature;
+ (NSUInteger)computeContentLengthForChunkedData:(NSUInteger)dataLength;
@end