#import <Foundation/Foundation.h>
#import "PLCrashReportProcessorInfo.h"
@interface PLCrashReportBinaryImageInfo : NSObject {
@private
    PLCrashReportProcessorInfo *_processorInfo;
    uint64_t _baseAddress;
    uint64_t _imageSize;
    NSString *_imageName;
    BOOL _hasImageUUID;
    NSString *_imageUUID;
}
- (id) initWithCodeType: (PLCrashReportProcessorInfo *) processorInfo
            baseAddress: (uint64_t) baseAddress 
                   size: (uint64_t) imageSize
                   name: (NSString *) imageName
                   uuid: (NSData *) uuid;
@property(nonatomic, readonly) PLCrashReportProcessorInfo *codeType;
@property(nonatomic, readonly) uint64_t imageBaseAddress;
@property(nonatomic, readonly) uint64_t imageSize;
@property(nonatomic, readonly) NSString *imageName;
@property(nonatomic, readonly) BOOL hasImageUUID;
@property(nonatomic, readonly) NSString *imageUUID;
@end