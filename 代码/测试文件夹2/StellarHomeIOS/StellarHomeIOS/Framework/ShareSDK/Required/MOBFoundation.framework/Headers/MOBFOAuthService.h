#import <MOBFoundation/MOBFoundation.h>
@interface MOBFOAuthService : MOBFHttpService
- (void)setSecretByConsumerSecret:(NSString *)consumerSecret
                 oauthTokenSecret:(NSString *)oauthTokenSecret;
- (void)addOAuthParameter:(id)value forKey:(NSString *)key;
- (void)addOAuthParameters:(NSDictionary *)oauthParameters;
+ (MOBFOAuthService *)sendRequestByURLString:(NSString *)urlString
                                      method:(NSString *)method
                                  parameters:(NSDictionary *)parameters
                                     headers:(NSDictionary *)headers
                             oauthParameters:(NSDictionary *)oauthParameters
                              consumerSecret:(NSString *)consumerSecret
                            oauthTokenSecret:(NSString *)oauthTokenSecret
                                    onResult:(MOBFHttpResultEvent)resultHandler
                                     onFault:(MOBFHttpFaultEvent)faultHandler
                            onUploadProgress:(MOBFHttpUploadProgressEvent)uploadProgressHandler;
@end