#ifndef AWSCognitoCredentialsProvider_Extension_h
#define AWSCognitoCredentialsProvider_Extension_h
@interface AWSCognitoCredentialsProvider (Internal)
- (AWSTask<AWSCredentials *> * _Nonnull)credentialsWithCancellationToken:(AWSCancellationTokenSource * _Nullable)cancellationTokenSource;
@end
#endif