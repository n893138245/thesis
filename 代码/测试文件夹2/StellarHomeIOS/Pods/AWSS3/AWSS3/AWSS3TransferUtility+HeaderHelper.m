#import "AWSS3TransferUtility+HeaderHelper.h"
#import "AWSS3TransferUtilityTasks.h"
@interface AWSS3CreateMultipartUploadRequest()
+ (NSValueTransformer *)ACLJSONTransformer;
+ (NSValueTransformer *)storageClassJSONTransformer;
+ (NSValueTransformer *)serverSideEncryptionJSONTransformer;
+ (NSValueTransformer *)requestPayerJSONTransformer;
+ (NSValueTransformer *)expiresJSONTransformer;
@end
@interface AWSS3TransferUtilityExpression()
@property (strong, nonatomic) NSMutableDictionary<NSString *, NSString *> *internalRequestHeaders;
@property (strong, nonatomic) NSMutableDictionary<NSString *, NSString *> *internalRequestParameters;
- (void)assignRequestParameters:(AWSS3GetPreSignedURLRequest *)getPreSignedURLRequest;
- (void)assignRequestHeaders:(AWSS3GetPreSignedURLRequest *)getPreSignedURLRequest;
@end
@interface AWSS3TransferUtilityUploadExpression()
@property (copy, atomic) AWSS3TransferUtilityUploadCompletionHandlerBlock completionHandler;
@end
@interface AWSS3TransferUtilityMultiPartUploadExpression()
@property (strong, nonatomic) NSMutableDictionary<NSString *, NSString *> *internalRequestHeaders;
@property (strong, nonatomic) NSMutableDictionary<NSString *, NSString *> *internalRequestParameters;
- (void)assignRequestParameters:(AWSS3GetPreSignedURLRequest *)getPreSignedURLRequest;
@property (copy, atomic) AWSS3TransferUtilityMultiPartUploadCompletionHandlerBlock completionHandler;
@end
@implementation AWSS3TransferUtility (HeaderHelper)
-(void) propagateHeaderInformation: (AWSS3CreateMultipartUploadRequest *) uploadRequest
                        expression: (AWSS3TransferUtilityMultiPartUploadExpression *) expression {
    NSMutableDictionary<NSString *, NSString *> *metadata = [NSMutableDictionary new];
    for (NSString *key in expression.requestHeaders) {
        NSString *lKey = [key lowercaseString];
        if ([lKey hasPrefix:@"x-amz-meta"]) {
            [metadata setValue:expression.requestHeaders[key] forKey:[key stringByReplacingOccurrencesOfString:@"x-amz-meta-" withString:@""]];
        }
        else if ([lKey isEqualToString:@"x-amz-acl"]) {
            NSValueTransformer *transformer = [AWSS3CreateMultipartUploadRequest ACLJSONTransformer];
            uploadRequest.ACL = (AWSS3ObjectCannedACL)[[transformer transformedValue:expression.requestHeaders[key]] integerValue];
        }
        else if ([lKey isEqualToString:@"x-amz-grant-read" ]) {
            uploadRequest.grantRead = expression.requestHeaders[key];
        }
        else if ([lKey isEqualToString:@"x-amz-grant-read-acp" ]) {
            uploadRequest.grantReadACP = expression.requestHeaders[key];
        }
        else if ([lKey isEqualToString:@"x-amz-grant-read-acp" ]) {
            uploadRequest.grantReadACP = expression.requestHeaders[key];
        }
        else if ([lKey isEqualToString:@"x-amz-grant-write-acp" ]) {
            uploadRequest.grantWriteACP = expression.requestHeaders[key];
        }
        else if ([lKey isEqualToString:@"x-amz-grant-full-control" ]) {
            uploadRequest.grantFullControl = expression.requestHeaders[key];
        }
        else if ([lKey isEqualToString:@"x-amz-server-side-encryption" ]) {
            NSValueTransformer *transformer = [AWSS3CreateMultipartUploadRequest serverSideEncryptionJSONTransformer];
            uploadRequest.serverSideEncryption = (AWSS3ServerSideEncryption)[[transformer transformedValue:expression.requestHeaders[key]] integerValue];
        }
        else if ([lKey isEqualToString:@"x-amz-server-side-encryption-aws-kms-key-id" ]) {
            uploadRequest.SSEKMSKeyId = expression.requestHeaders[key];
        }
        else if ([lKey isEqualToString:@"x-amz-server-side-encryption-customer-algorithm" ]) {
            uploadRequest.SSECustomerAlgorithm = expression.requestHeaders[key];
        }
        else if ([lKey isEqualToString:@"x-amz-server-side-encryption-customer-key" ]) {
            uploadRequest.SSECustomerKey = expression.requestHeaders[key];
        }
        else if ([lKey isEqualToString:@"x-amz-server-side-encryption-customer-key-md5" ]) {
            uploadRequest.SSECustomerKeyMD5 = expression.requestHeaders[key];
        }
        else if ([lKey isEqualToString:@"content-encoding" ]) {
            uploadRequest.contentEncoding = expression.requestHeaders[key];
        }
        else if ([lKey isEqualToString:@"content-type" ]) {
            uploadRequest.contentType = expression.requestHeaders[key];
        }
        else if ([lKey isEqualToString:@"content-disposition" ]) {
            uploadRequest.contentDisposition = expression.requestHeaders[key];
        }
        else if([lKey isEqualToString:@"cache-control"]) {
            uploadRequest.cacheControl = expression.requestHeaders[key];
        }
        else if ([lKey isEqualToString:@"x-amz-request-payer" ]) {
            NSValueTransformer *transformer = [AWSS3CreateMultipartUploadRequest requestPayerJSONTransformer];
            uploadRequest.requestPayer = (AWSS3RequestPayer)[[transformer transformedValue:expression.requestHeaders[key]] integerValue];
        }
        else if ([lKey isEqualToString:@"expires" ]) {
            NSValueTransformer *transformer = [AWSS3CreateMultipartUploadRequest expiresJSONTransformer];
            uploadRequest.expires = [transformer transformedValue:expression.requestHeaders[key]];
        }
        else if ([lKey isEqualToString:@"x-amz-storage-class" ]) {
            NSValueTransformer *transformer = [AWSS3CreateMultipartUploadRequest storageClassJSONTransformer];
            uploadRequest.storageClass = (AWSS3StorageClass)[[transformer transformedValue:expression.requestHeaders[key]] integerValue];
        }
        else if ([lKey isEqualToString:@"x-amz-website-redirect-location" ]) {
            uploadRequest.websiteRedirectLocation = expression.requestHeaders[key];
        }
        else if ([lKey isEqualToString:@"x-amz-tagging" ]) {
            uploadRequest.tagging = expression.requestHeaders[key];
        }
    }
    uploadRequest.metadata = metadata;
}
-(void) filterAndAssignHeaders:(NSDictionary<NSString *, NSString *> *) requestHeaders
        getPresignedURLRequest:(AWSS3GetPreSignedURLRequest *) getPresignedURLRequest
                    URLRequest: (NSMutableURLRequest *) URLRequest {
    NSSet *disallowedHeaders = [[NSSet alloc] initWithArray:
                                @[@"x-amz-acl", @"x-amz-tagging", @"x-amz-storage-class", @"x-amz-server-side-encryption"]];
    for (NSString *key in requestHeaders) {
        NSString *lKey = [key lowercaseString];
        if ([ lKey hasPrefix:@"x-amz-meta"] || [lKey hasPrefix:@"x-amz-grant"]) {
            continue;
        }
        if ([disallowedHeaders containsObject:lKey]) {
            continue;
        }
        [getPresignedURLRequest setValue:requestHeaders[key] forRequestHeader:key];
        [URLRequest setValue:requestHeaders[key] forHTTPHeaderField:key];
    }
}
@end