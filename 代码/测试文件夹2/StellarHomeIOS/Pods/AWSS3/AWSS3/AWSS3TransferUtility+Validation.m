#import <AWSS3/AWSS3.h>
@implementation AWSS3TransferUtility (Validation)
- (AWSTask *) validateParameters: (NSString * )bucket key:(NSString *)key fileURL:(NSURL *)fileURL accelerationModeEnabled: (BOOL) accelerationModeEnabled
{
    AWSTask *validationError = [self validateParameters:bucket key:key accelerationModeEnabled:accelerationModeEnabled];
    if (validationError) {
        return validationError;
    }
    NSString *filePath = [fileURL path];
    if ([filePath length] < 2 ||
        ! [[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        return [AWSTask taskWithError:[NSError errorWithDomain:AWSS3TransferUtilityErrorDomain
                                                          code:AWSS3TransferUtilityErrorLocalFileNotFound
                                                      userInfo:nil]];
    }
    return nil;
}
- (AWSTask *) validateParameters: (NSString * )bucket key:(NSString *)key accelerationModeEnabled: (BOOL) accelerationModeEnabled
{
    if (!bucket || [bucket length] == 0) {
        NSInteger errorCode = (accelerationModeEnabled) ?
        AWSS3PresignedURLErrorInvalidBucketNameForAccelerateModeEnabled : AWSS3PresignedURLErrorInvalidBucketName;
        NSString *errorMessage = @"Invalid bucket specified. Please specify a bucket name or configure the bucket property in `AWSS3TransferUtilityConfiguration`.";
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:errorMessage
                                                         forKey:NSLocalizedDescriptionKey];
        return [AWSTask taskWithError:[NSError errorWithDomain:AWSS3PresignedURLErrorDomain
                                                      code:errorCode
                                                  userInfo:userInfo]];
    }
    if (!key || [key length] == 0) {
        NSString *errorMessage = [NSString stringWithFormat: @"Empty key specified"];
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:errorMessage
                                                             forKey:NSLocalizedDescriptionKey];
        return [AWSTask taskWithError:[NSError errorWithDomain:AWSS3TransferUtilityErrorDomain
                                                          code:AWSS3TransferUtilityErrorClientError
                                                      userInfo:userInfo]];
    }
    return nil;
}
@end