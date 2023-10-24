#ifndef stellar_wifi_StellarProtocol_h
#define stellar_wifi_StellarProtocol_h
#import <Foundation/Foundation.h>
#pragma mark - typedefs
typedef uint16_t StellarFrameLengthType;
typedef uint16_t StellarFrameCrcType;
typedef uint8_t StellarFrameDelimiterType;
typedef uint8_t StellarFrameCodeType;
#pragma mark - frame constants
static const unsigned long StellarFrameMacLength = 8;
static const Byte broadcastMacBytes[] = {0xff, 0xff, 0xff, 0xff,
                                         0xff, 0xff, 0xff, 0xff};
static const NSUInteger StellarMaxBrightness = 100;
static const NSUInteger StellarRemoteInvalidScene = UINT8_MAX;
typedef enum : StellarFrameDelimiterType {
  StellarFramePrefixHost = 0xA5,
  StellarFramePrefixDevice = 0x35,
} StellarFramePrefix;
typedef enum : StellarFrameDelimiterType {
  StellarFramePostfixHost = 0x5A,
  StellarFramePostfixDevice = 0x53,
} StellarFramePostfix;
typedef enum : StellarFrameCodeType {
  StellarFrameCodeMissing = 0xFE,
  StellarFrameCodeAck = 0x80,
  StellarFrameCodeNoAck = 0x00,
  StellarFrameCodeSuccess = 0x00,
  StellarFrameCodeFailure = 0x01,
  StellarFrameCodeWrongParameter = 0x02,
  StellarFrameCodeCommandNotSupported = 0x03,
} StellarFrameCode;
#pragma mark - content enums
typedef enum : uint8_t {
    StellarFrameTypeQueryDeviceInfo = 0x00,
    StellarFrameTypeSyncTime = 0x01,
    StellarFrameTypeSetBrightnessCoefficient = 0x02,
    StellarFrameTypeSetRGBWPlaylist = 0x03,
    StellarFrameTypeSetCCTColorTemperature = 0x04,
    StellarFrameTypeActivateFactoryPreset = 0x05,
    StellarFrameTypeSetTimetable = 0x06,
    StellarFrameTypeSetWifiAccess = 0x07,
    StellarFrameTypeSetResetting = 0x08, 
    StellarFrameTypeSetBulbName = 0x09,
    StellarFrameTypeSetTimedOff = 0x0C, 
    StellarFrameTypeQueryDeviceTimeOff = 0x0D, 
    StellarFrameTypeSetBrightnessCoefficientWithDuration = 0x0B,
    StellarFrameTypeQueryDeviceStatus = 0x0A,
    StellarFrameTypeSetUpMode = 0x12, 
    StellarFrameTypeSetUpService = 0x13, 
    StellarFrameTypeSendDeviceToken = 0x14, 
    StellarFrameTypeBegainRegist = 0x15, 
    StellarFrameTypeQueryDeviceInfoNew = 0x16,
    StellarFrameTypeQueryDeviceName = 0x17,
    StellarFrameTypeDUIInfo = 0x18
} StellarFrameType;
typedef enum : uint16_t {
    TFTPFrameTypeUpdateBulb_WRQ = 0x0200,
    TFTPFrameTypeUpdateBulb_SD  = 0x0300,
    TFTPFrameTypeUpdateBulb_ACK = 0x0400,
    TFTPFrameTypeUpdateBulb_ERR = 0x0500,
}TFTPFrameType;
typedef enum : uint8_t {
  StellarDeviceConnectionTypeWifi = 0x00,
  StellarDeviceConnectionTypeBluetooth = 0x01,
  StellarDeviceConnectionTypeZigbee = 0x02,
  StellarDeviceConnectionTypeUnknown = 0xff,
} StellarDeviceConnectionType;
typedef enum : uint16_t {
  StellarDeviceTypeRGBW = 0x1001,
  StellarDeviceTypeCCT = 0x1002, 
  StellarDeviceTypeRBPlant = 0x1003, 
  StellarDeviceTypeWhitePlant = 0x1004, 
  StellarDeviceTypeCeiling = 0x1005, 
  StellarDeviceTypeLamp = 0x1006, 
  StellarDeviceTypeCeilingWhite = 0x1007, 
  StellarDeviceTypeUnknown = 0x0FFF, 
} StellarDeviceType;
typedef enum : uint8_t {
  StellarPlaylistPlaymodeTranslate = 0x00,
  StellarPlaylistPlaymodeDirect = 0x01,
  StellarPlaylistPlaymodeBlink = 0x02,
} StellarPlaylistPlaymode;
typedef enum : uint8_t {
  StellarTimetableItemTypeFactory = 0x01,
  StellarTimetableItemTypeRGBW = 0x02,
} StellarTimetableItemType;
#endif