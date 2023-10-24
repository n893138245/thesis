#ifndef RemoteDebug_h
#define RemoteDebug_h
#import <Foundation/Foundation.h>
#import <TBJSONModel/TBJSONModel.h>
#pragma messages type
extern NSString * const MESSAGE_TYPE_REQUEST;
extern NSString * const MESSAGE_TYPE_REPLY;
extern NSString * const MESSAGE_TYPE_NOTIFY;
#pragma opcode
extern NSString * const OPCODE_ACK;
extern NSString * const OPCODE_STARTUP;
extern NSString * const OPCODE_APPLY_UPLOAD_TOKEN;                  
extern NSString * const OPCODE_APPLY_UPLOAD_TOKEN_REPLY;
extern NSString * const OPCODE_APPLY_UPLOAD;                        
extern NSString * const OPCODE_APPLY_UPLOAD_REPLY;
extern NSString * const OPCODE_APPLY_UPLOAD_COMPLETE;
extern NSString * const OPCODE_APPLY_UPLOAD_COMPLETE_REPLY;
extern NSString * const OPCODE_LOG_CONFIGURE;
extern NSString * const OPCODE_LOG_CONFIGURE_REPLY;
extern NSString * const OPCODE_LOG_UPLOAD;
extern NSString * const OPCODE_LOG_UPLOAD_REPLY;
extern NSString * const OPCODE_METHOD_TRACE_DUMP;
extern NSString * const OPCODE_METHOD_TRACE_DUMP_REPLY;
extern NSString * const OPCODE_HEAP_DUMP;
extern NSString * const OPCODE_HEAP_DUMP_REPLY;
extern NSString * const OPCODE_PACKET_PULL;                         
#pragma debug type
extern NSString * const DEBUG_TYPE_UNKOWN;
extern NSString * const DEBUG_TYPE_TLOG;
extern NSString * const DEBUG_TYPE_METHOD_TRACE;
extern NSString * const DEBUG_TYPE_HEAP_DUMP;
#pragma biz type
extern NSString * const BIZ_TYPE_UNKOWN;
extern NSString * const BIZ_TYPE_FEEDBACK;
extern NSString * const BIZ_TYPE_CRASH;
#pragma AliHA remote debug message protocol
@interface RemoteDebugMessagePacket : NSObject
@property (nonatomic, copy) NSString *type;                 
@property (nonatomic, copy) NSString *version;              
@property (nonatomic, strong) NSMutableDictionary *headers; 
@property (nonatomic, copy) NSString *appKey;
@property (nonatomic, copy) NSString *appId;
@property (nonatomic, copy) NSString *deviceId;
@property (nonatomic, copy) NSString *sessionId;
@property (nonatomic, copy) NSString *requestId;
@property (nonatomic, copy) NSString *opCode;               
@property (nonatomic, copy) NSString *platform;             
@property (nonatomic, strong) NSMutableDictionary *data;    
@property (nonatomic, copy) NSString *bizType;              
@property (nonatomic, copy) NSString *debugType;            
@property (nonatomic, copy) NSString *tokenType;            
@property (nonatomic, copy) NSDictionary *tokenInfo;        
@property (nonatomic, copy) NSString *uploadId;             
@property (nonatomic, copy) NSDictionary *forward;          
@property (nonatomic, copy) NSDictionary *extraInfo;        
- (instancetype)init;
- (instancetype)initWithJson:(NSDictionary *)json;
- (NSString *)serializeToJSONString;
@end
@interface RemoteDebugResponse : RemoteDebugMessagePacket
@property (nonatomic, copy) NSString *replyId;
@property (nonatomic, copy) NSString *replyCode;
@property (nonatomic, copy) NSString *replyMessage;
@end
@interface RemoteDebugRequest : RemoteDebugMessagePacket
@end
@interface RemoteDebugLocalFileItem : TBJSONModel
@property (nonatomic, copy) NSString *absolutePath;
@property (nonatomic, copy) NSString *contentEncoding;
@property (nonatomic, copy) NSString *contentType;
@property (nonatomic, assign) NSUInteger contentLength;
@property (nonatomic, copy) NSString *contentMD5;
@property (nonatomic, copy) NSString *fileName;
@property (nonatomic, assign) NSTimeInterval lastModified;
@end
@interface RemoteDebugRemoteFileItem : RemoteDebugLocalFileItem
@property (nonatomic, copy) NSString *storageType;
@property (nonatomic, copy) NSDictionary *storageInfo;  
@end
@interface RemoteDebugUploadFileReqeust : RemoteDebugRequest
@property (nonatomic, copy) NSArray<RemoteDebugLocalFileItem *> *fileInfos;
@end
@interface RemoteDebugUploadFileCompleteResponse : RemoteDebugResponse
@property (nonatomic, copy) NSArray<RemoteDebugLocalFileItem *> *remoteFileInfos;
@end
@protocol AliHARemoteDebugMessageProtocol <NSObject>
- (void)sendStartupMessage:(RemoteDebugRequest *)request resultsBlock:(void(^)(NSError *error, RemoteDebugResponse *response))resultsBlock;
- (void)sendData:(RemoteDebugMessagePacket *)request resultsBlock:(void(^)(NSError *error, RemoteDebugResponse *response))resultsBlock;
- (void)pullData:(NSString *)appKey deviceId:(NSString *)deviceId resultsBlock:(void (^)(NSError *, RemoteDebugResponse *))resultsBlock;
@end
#pragma remote deubug command handler protocol
@protocol RemoteDebugCommandHandler
- (NSString *)targetOpCode;
- (BOOL)handleCommand:(RemoteDebugMessagePacket *)packet;
@end
#pragma upload protocol
typedef void (^UploadResultBlock)(RemoteDebugUploadFileCompleteResponse* uploadFileCompleteResponse);
typedef void (^UploadFailureBlock)(NSString* errorMsg);
typedef NS_ENUM(NSInteger, AliHAUploadReasonType) {
    AliHAUploadReasonInvalid = 0,
    AliHAUploadReasonLog,
    AliHAUploadReasonMethodTrace,
    AliHAUploadReasonMemoryDump
};
#pragma file upload protocl
@protocol AliHAUploadProtocol <NSObject>
- (void)uploadFileAsync:(RemoteDebugUploadFileReqeust *)request
        successCallback:(UploadResultBlock)succssCallback
        failureCallback:(UploadFailureBlock)failureCallback;
@end
#endif 