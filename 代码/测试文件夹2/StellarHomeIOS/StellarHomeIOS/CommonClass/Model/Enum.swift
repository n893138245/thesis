import Foundation
enum DeviceType: String, ConvertibleEnum {
    case light, panel, hub, mainLight, unknown
}
enum DeviceRemoteType: String, ConvertibleEnum {
    case directly, needGateway, locally, unknown
}
enum ThirdPartType: String, ConvertibleEnum {
    case wechat, facebook,apple, unknown
}
enum AddDeviceState: String, ConvertibleEnum {
    case wait, adding, fail, success
}
enum Traits: String, ConvertibleEnum {
    case onOff, brightness, increaseBrightness, decreaseBrightness, color, colorTemperature, increaseColorTemperature, decreaseColorTemperature, buttonAction, execute, discover, internalScene, delayOff, mode, internalMode, radarVitalSigns, radarLocationInfo, monitor, fallDownAlert, vitalSignDisappearAlert, other
}
enum ConnectionType: String, ConvertibleEnum {
    case mesh,zigbee,softAP,smartConfig,dui, ble, unknown
}
enum ErrorCode: Int, ConvertibleEnum{
    case success = 0
    case userExist = 10001
    case userNotExist = 10002
    case smscodeWrong = 10003
    case serverError = 10004
    case smsSendError = 10005
    case tokenWrong = 10006
    case tokenExpire = 10007
    case requestTooFast = 10008
    case invaildParameters = 10009
    case wrongPassword = 10010
    case thirdUserNotExist = 10013
    case DBOPFailed = 20001
    case validationError = 20002
    case objectNotFound = 20003
    case duplicateName = 20004
    case gatewayNotFound = 20005
    case msgTimeout = 20006
    case gatewayMsgFormatError = 20007
    case gatewayNotReturnError = 20008
    case tooManyError = 20009
    case notOwnedResource = 20010
    case gatewayInBatchCreate = 20011
    case gatewayInvalid = 20012
    case thirdPartAuthorizeError = 30000
    case unknownError = 50000
}
enum ErrorMessage: String, ConvertibleEnum{
    case success = "请求成功"
    case userExist = "用户存在"
    case userNotExist = "用户不存在"
    case smscodeWrong = "验证码错误"
    case serverError = "服务器错误"
    case smsSendError = "验证码获取失败或达到上限"
    case tokenWrong = "身份验证失败"
    case tokenExpire = "用户身份过期"
    case requestTooFast = "请求过于频繁"
    case invaildParameters = "参数无效"
    case wrongPassword = "密码错误"
    case DBOPFailed = "数据库错误"
    case validationError = "参数格式错误"
    case objectNotFound = "访问资源不存在"
    case duplicateName = "名称重复"
    case gatewayNotFound = "网关不存在"
    case msgTimeout = "命令执行超时"
    case gatewayMsgFormatError = "网关数据格式错误"
    case gatewayNotReturnError = "网关未返回设备"
    case tooManyError = "指令或场景资源太多"
    case notOwnedResource = "资源不属于用户"
    case gatewayInBatchCreate = "批量创建设备中不允许包含网关类设备"
    case gatewayInvalid = "设备所属的网关不属于当前用户"
    case thirdPartAuthorizeError = "授权失败"
    case unknownError = "未知错误"
}
enum CodeUsage: String , ConvertibleEnum{
    case login,register,reset_password,check_identify
}