import Foundation
enum DCAErrorCode: Int {
    case server_108900 = 108900
    case server_108901 = 108901
    case server_108902 = 108902
    case parameters_108903 = 108903
    case accountLink = 108904
    case server_108905 = 108905
    case parameters_108906 = 108906
    case server_108907 = 108907
    case duiTokenNotMatch = 108908
    case deviceBind = 108909
    case server_108910 = 108910
    case server_108911 = 108911
    case timeOut = 108912
    case duiTokenInvaild = 103108
    case dcaTokenPastDue = 103601
    case dcaTokenRem = 103602
    case unknown = -1
}
extension Error{
    func getDCAErrorMessage(_ code: DCAErrorCode) -> String {
        switch code {
        case .server_108900, .server_108901, .server_108902, .server_108905, .server_108907, .server_108910, .server_108911:
            return "服务器内部错误"
        case .parameters_108903, .parameters_108906:
            return "传参出错"
        case .dcaTokenPastDue:
            return "dcatoken已过期，需要刷新dcatoken"
        case .accountLink:
            return "账号互通接口，第三方token无效"
        case .deviceBind:
            return "设备（音箱）绑定出错"
        case .dcaTokenRem:
            return "dca记住我凭证不合法，需要重新登录dca账号"
        case .duiTokenInvaild:
            return "不合法的dcatoken，需要刷新dcatoken"
        case .duiTokenNotMatch:
            return "思必驰用户id和思必驰账号的token不匹配"
        case .timeOut:
            return "查询第三方智能家居厂商设备超时"
        case .unknown:
            return "未知错误"
        }
    }
}