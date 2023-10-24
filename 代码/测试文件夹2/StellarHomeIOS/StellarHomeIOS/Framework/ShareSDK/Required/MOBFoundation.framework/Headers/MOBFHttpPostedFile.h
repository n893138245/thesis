#import <Foundation/Foundation.h>
@interface MOBFHttpPostedFile : NSObject
@property (nonatomic, copy) NSString *fileName;
@property (nonatomic, copy) NSString *contentType;
@property (nonatomic, retain) NSData *fileData;
@property (nonatomic, copy) NSString *transferEncoding;
+ (MOBFHttpPostedFile *)httpPostedFileByFileName:(NSString *)fileName
                                           data:(NSData *)data
                                    contentType:(NSString *)contentType
                               transferEncoding:(NSString *)transferEncoding;
+ (MOBFHttpPostedFile *)httpPostedFileByPath:(NSString *)path
                                contentType:(NSString *)contentType;
@end