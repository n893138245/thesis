public enum NetRequestAPI {
    case login(LoginRequestModel)
    case getDcaToken
    case thirdLogin(ThirdPartLoginModel)
    case sendCode(SendCodeModel)
    case checkCode(CheckCodeModel)
    case changePhone(_ cellphone:String,_ accessCode:String )
    case destroyAccount(_ accessCode:String )
    case checkIdentify(LoginRequestModel)
    case chageEmail(_ email:String,_ accessCode:String )
    case changePassword(_ newPassword:String,_ accessCode:String )
    case getUserInfo
    case modificationUserInfoSubscribe(subscribe:Bool)
    case modificationUserInfoNickname(nickname:String)
    case modificationUserInfoAlertWays(alertWays:[String])
    case refreshToken(refreshToken:String)
    case checkIsNewUserCellphone(cellphone:String)
    case checkIsNewUserEmail(email:String)
    case resetPassword(ResetPasswordModel)
    case register(RegistModel)
    case bindThirdpart(ThirdPartInfoModel)
    case unbindThirdpart(ThirdPartInfoModel)
    case getDeviceRegisterToken
    case adddevicesToGateway([BasicDeviceModel]) 
    case addSingleDevice(BasicDeviceModel) 
    case getAllDeviceBasicInfo
    case getAllDeviceStateInfo
    case getSingleDeviceInfo(sn:String)
    case excuteDevices([ExecutionModel])
    case getSingleStatusDevice(sn:String)
    case getRelationDevice(sn:String)
    case modifyDeviceRoom(sn:String,room:Int)
    case modifyDeviceName(sn:String,name:String)
    case excutePanelActions(sn: String,buttonId: String)
    case getPanelButtonsActions(sn: String)
    case setPanelButtonsActions(sn:String,buttonId:Int,actions:[ExecutionModel])
    case deleteDevice(sn:String)
    case startSearch(sn:String,time:Int)
    case stopSearch(sn:String)
    case getVitalSigns(sn:String)
    case getLocationInfo(sn:String)
    case startMonitorLocation(sn:String)
    case stopMonitorLocation(sn:String)
    case startMonitorVital(sn:String)
    case stopMonitorVital(sn:String)
    case radarLocationExistance(sn:String,startTime:String,endTime:String)
    case radarLocationHistory(sn:String,time:String)
    case deleteScene(id:String)
    case addScene(AddScenesModel)
    case queryRelation(id:String)
    case excuteScene(id:String)
    case modifyScene(changeScenseInfoModel:ChangeScenseInfoModel,id:String)
    case querySingleScene(id:String)
    case queryAllScenes
    case queryAllScenesBGImageList
    case queryAllIntelligents
    case addIntelligents(AddIntelligentsModel)
    case queryDetailIntelligent(id:String)
    case deleteDetailIntelligent(id:String)
    case modifyDetailIntelligent(id:String,changeSmartInfoModel:ChangeSmartInfoModel)
    case queryRelationIntelligent(id:String)
    case excuteDetailIntelligent(id:String)
    case disableDetailIntelligent(id:String)
    case start_upgrade(sn:String,latestSwVersion:Int)
    case queryAllRooms
    case queryDevicesVersionDescription(fwType:String,hwVersion:String,swVersion:String)
    case devicesUpgradeInfo(fwType:String,hwVersion:String)
    case queryDevicesAddList
}
extension NetRequestAPI: TargetType {
    public var baseURL: URL {
        switch self {
        case .login(_):
            return URL(string: StellarHomeResourceUrl.baseurl_user)!
        case .getDcaToken:
            return URL(string: StellarHomeResourceUrl.baseurl_user)!
        case .thirdLogin(_):
            return URL(string: StellarHomeResourceUrl.baseurl_user)!
        case .sendCode(_):
            return URL(string: StellarHomeResourceUrl.baseurl_user)!
        case .checkCode(_):
            return URL(string: StellarHomeResourceUrl.baseurl_user)!
        case .changePhone(_ , _):
            return URL(string: StellarHomeResourceUrl.baseurl_user)!
        case .destroyAccount(_):
            return URL(string: StellarHomeResourceUrl.baseurl_user)!
        case .checkIdentify(_):
            return URL(string: StellarHomeResourceUrl.baseurl_user)!
        case .chageEmail(_ ,_ ):
            return URL(string: StellarHomeResourceUrl.baseurl_user)!
        case .changePassword(_ ,_ ):
            return URL(string: StellarHomeResourceUrl.baseurl_user)!
        case .getUserInfo:
            return URL(string: StellarHomeResourceUrl.baseurl_user)!
        case .modificationUserInfoSubscribe( _ ):
            return URL(string: StellarHomeResourceUrl.baseurl_user)!
        case .modificationUserInfoNickname(_):
            return URL(string: StellarHomeResourceUrl.baseurl_user)!
        case .refreshToken(_):
            return URL(string: StellarHomeResourceUrl.baseurl_user)!
        case .checkIsNewUserCellphone(_ ):
            return URL(string: StellarHomeResourceUrl.baseurl_user)!
        case .checkIsNewUserEmail(_ ):
            return URL(string: StellarHomeResourceUrl.baseurl_user)!
        case .resetPassword(_):
            return URL(string: StellarHomeResourceUrl.baseurl_user)!
        case .register(_):
            return URL(string: StellarHomeResourceUrl.baseurl_user)!
        case .bindThirdpart(_):
            return URL(string: StellarHomeResourceUrl.baseurl_user)!
        case .unbindThirdpart(_):
            return URL(string: StellarHomeResourceUrl.baseurl_user)!
        case .getDeviceRegisterToken:
            return URL(string: StellarHomeResourceUrl.baseurl_device)!
        case .adddevicesToGateway(_):
            return URL(string: StellarHomeResourceUrl.baseurl_device)!
        case .addSingleDevice(_):
            return URL(string: StellarHomeResourceUrl.baseurl_device)!
        case .getAllDeviceBasicInfo:
            return URL(string: StellarHomeResourceUrl.baseurl_device)!
        case .getAllDeviceStateInfo:
            return URL(string: StellarHomeResourceUrl.baseurl_device)!
        case .getSingleDeviceInfo(_):
            return URL(string: StellarHomeResourceUrl.baseurl_device)!
        case .excuteDevices:
            return URL(string: StellarHomeResourceUrl.baseurl_device)!
        case .getSingleStatusDevice(_):
            return URL(string: StellarHomeResourceUrl.baseurl_device)!
        case .getRelationDevice(_):
            return URL(string: StellarHomeResourceUrl.baseurl_device)!
        case .modifyDeviceRoom(_,_):
            return URL(string: StellarHomeResourceUrl.baseurl_device)!
        case .modifyDeviceName(_,_):
            return URL(string: StellarHomeResourceUrl.baseurl_device)!
        case .excutePanelActions(_,_):
            return URL(string: StellarHomeResourceUrl.baseurl_device)!
        case .getPanelButtonsActions(_):
            return URL(string: StellarHomeResourceUrl.baseurl_device)!
        case .setPanelButtonsActions(_,_,_):
            return URL(string: StellarHomeResourceUrl.baseurl_device)!
        case .deleteDevice(_):
            return URL(string: StellarHomeResourceUrl.baseurl_device)!
        case .startSearch(_,_):
            return URL(string: StellarHomeResourceUrl.baseurl_device)!
        case .stopSearch(_):
            return URL(string: StellarHomeResourceUrl.baseurl_device)!
        case .getVitalSigns(_):
            return URL(string: StellarHomeResourceUrl.baseurl_device)!
        case .getLocationInfo(_):
            return URL(string: StellarHomeResourceUrl.baseurl_device)!
        case .startMonitorLocation(_):
            return URL(string: StellarHomeResourceUrl.baseurl_device)!
        case .stopMonitorLocation(_):
            return URL(string: StellarHomeResourceUrl.baseurl_device)!
        case .startMonitorVital(_):
            return URL(string: StellarHomeResourceUrl.baseurl_device)!
        case .stopMonitorVital(_):
            return URL(string: StellarHomeResourceUrl.baseurl_device)!
        case .deleteScene(_):
            return URL(string: StellarHomeResourceUrl.baseurl_device)!
        case .addScene(_):
            return URL(string: StellarHomeResourceUrl.baseurl_device)!
        case .queryRelation(_):
            return URL(string: StellarHomeResourceUrl.baseurl_device)!
        case .excuteScene(_):
            return URL(string: StellarHomeResourceUrl.baseurl_device)!
        case .modifyScene(_,_):
            return URL(string: StellarHomeResourceUrl.baseurl_device)!
        case .querySingleScene(_):
            return URL(string: StellarHomeResourceUrl.baseurl_device)!
        case .queryAllScenes:
            return URL(string: StellarHomeResourceUrl.baseurl_device)!
        case .queryAllIntelligents:
            return URL(string: StellarHomeResourceUrl.baseurl_device)!
        case .addIntelligents:
            return URL(string: StellarHomeResourceUrl.baseurl_device)!
        case .queryDetailIntelligent:
            return URL(string: StellarHomeResourceUrl.baseurl_device)!
        case .deleteDetailIntelligent:
            return URL(string: StellarHomeResourceUrl.baseurl_device)!
        case .modifyDetailIntelligent(_,_):
            return URL(string: StellarHomeResourceUrl.baseurl_device)!
        case .queryRelationIntelligent(_):
            return URL(string: StellarHomeResourceUrl.baseurl_device)!
        case .excuteDetailIntelligent(_):
            return URL(string: StellarHomeResourceUrl.baseurl_device)!
        case .disableDetailIntelligent(_):
            return URL(string: StellarHomeResourceUrl.baseurl_device)!
        case .start_upgrade(_,_):
            return URL(string: StellarHomeResourceUrl.baseurl_device)!
        case .queryAllRooms:
            return URL(string: StellarHomeResourceUrl.baseulr_source)!
        case .queryDevicesVersionDescription(_,_,_):
            return URL(string: StellarHomeResourceUrl.baseulr_source)!
        case .devicesUpgradeInfo(_,_):
            return URL(string: StellarHomeResourceUrl.baseulr_source)!
        case .queryDevicesAddList:
            return URL(string: StellarHomeResourceUrl.baseulr_source)!
        case .queryAllScenesBGImageList:
            return URL(string: StellarHomeResourceUrl.baseulr_source)!
        case .radarLocationExistance(_,_,_):
            return URL(string: StellarHomeResourceUrl.baseurl_device)!
        case .radarLocationHistory(_,_):
            return URL(string: StellarHomeResourceUrl.baseurl_device)!
        case .modificationUserInfoAlertWays(_):
            return URL(string: StellarHomeResourceUrl.baseurl_user)!
        }
    }
    public var path: String {
        switch self {
        case .login(_):
            return "/user/login"
        case .getDcaToken:
            return "/user/dca_token"
        case .thirdLogin(_):
            return "/user/third_part_login"
        case .sendCode(_):
            return "/user/code"
        case .checkCode(_):
            return "/user/check_code"
        case .changePhone(_, _):
            return "/user/change_cellphone"
        case .destroyAccount(_):
            return "/user/destroy"
        case .checkIdentify(_):
            return "/user/check_identify"
        case .chageEmail(_ ,_ ):
            return "/user/change_email"
        case .changePassword(_ ,_ ):
            return "/user/change_password"
        case .getUserInfo:
            return "/user/info"
        case .modificationUserInfoSubscribe(_ ):
            return "/user/info"
        case .modificationUserInfoNickname(_):
            return "/user/info"
        case .refreshToken(_):
            return "/user/refresh_token"
        case .checkIsNewUserCellphone(_ ):
            return "/user/check_user"
        case .checkIsNewUserEmail(_ ):
            return "/user/check_user"
        case .resetPassword(_ ):
            return "/user/reset_password"
        case .register(_ ):
            return "/user/register"
        case .bindThirdpart(_):
            return "/user/bind_third_part"
        case .unbindThirdpart(_):
            return "/user/unbind_third_part"
        case .getDeviceRegisterToken:
            return "/devices/register_token"
        case .adddevicesToGateway(_):
            return "/devices/add_to_gateway"
        case .addSingleDevice:
            return "/devices"
        case .getAllDeviceBasicInfo:
            return "/devices"
        case .getAllDeviceStateInfo:
            return "/devices/status"
        case .getSingleDeviceInfo(let sn):
            return "/devices/\(sn)"
        case .excuteDevices:
            return "/devices/execute"
        case .getSingleStatusDevice(let sn):
            return "/devices/\(sn)/status"
        case .getRelationDevice(let sn):
            return "/devices/\(sn)/relation"
        case .modifyDeviceRoom(let sn, _):
            return "/devices/\(sn)/room"
        case .modifyDeviceName(let sn, _):
            return "/devices/\(sn)/name"
        case .excutePanelActions(let sn,let buttonId):
            return "/devices/\(sn)/buttons/\(buttonId)/execute"
        case .getPanelButtonsActions(let sn):
            return "/devices/\(sn)/buttons"
        case .setPanelButtonsActions(let sn,let buttonId,_):
            return "/devices/\(sn)/buttons/\(buttonId)"
        case .deleteDevice(let sn):
            return "/devices/\(sn)"
        case .startSearch(let sn,_):
            return "/devices/\(sn)/start_search"
        case .stopSearch(let sn):
            return "/devices/\(sn)/stop_search"
        case .deleteScene(let id):
            return "/scenes/\(id)"
        case .addScene(_):
            return "/scenes"
        case .queryRelation(let id):
            return "/scenes/\(id)"
        case .excuteScene(let id):
            return "/scenes/\(id)/execute"
        case .modifyScene(_,let id):
            return "/scenes/\(id)"
        case .querySingleScene(let id):
            return "/scenes/\(id)"
        case .queryAllScenes:
            return "/scenes"
        case .queryAllIntelligents:
            return "/Intelligents"
        case .addIntelligents:
            return "/Intelligents"
        case .queryDetailIntelligent(let id):
            return "/Intelligents/\(id)"
        case .deleteDetailIntelligent(let id):
            return "/Intelligents/\(id)"
        case .modifyDetailIntelligent(let id,_):
            return "/Intelligents/\(id)"
        case .queryRelationIntelligent(let id):
            return "/Intelligents/\(id)/relation"
        case .excuteDetailIntelligent(let id):
            return "/Intelligents/\(id)/enable"
        case .disableDetailIntelligent(let id):
            return "/Intelligents/\(id)/disable"
        case .start_upgrade(let sn,_):
            return "/devices/\(sn)/start_upgrade"
        case .queryAllRooms:
            return "/group_list/group_list.json"
        case .queryDevicesVersionDescription(let fwType,let hwVersion,let swVersion):
            return "/devices_json/\(fwType)/\(hwVersion)/\(swVersion).json"
        case .devicesUpgradeInfo(let fwType,let hwVersion):
            return "/devices_json/\(fwType)/\(hwVersion)/upgrade.json"
        case .queryDevicesAddList:
            return "/devices_json/devices_list.json"
        case .getVitalSigns(let sn):
            return "/devices/\(sn)/radar_vital_signs"
        case .getLocationInfo(let sn):
            return "/devices/\(sn)/radar_location_info"
        case .startMonitorVital(let sn):
            return "/devices/\(sn)/start_radar_vital_signs"
        case .stopMonitorVital(let sn):
            return "/devices/\(sn)/stop_radar_vital_signs"
        case .startMonitorLocation(let sn):
            return "/devices/\(sn)/start_radar_location"
        case .stopMonitorLocation(let sn):
            return "/devices/\(sn)/stop_radar_location"
        case .queryAllScenesBGImageList:
            return "/scenes/bg_list.json"
        case .radarLocationExistance(let sn, _, _):
            return "/devices/\(sn)/radar_location_existance"
        case .radarLocationHistory(let sn, _):
            return "/devices/\(sn)/radar_location_history"
        case .modificationUserInfoAlertWays(_):
            return "/user/info"
        }
    }
    public var method: Moya.Method {
        switch self {
        case .login(_):
            return .post
        case .getDcaToken:
            return .post
        case .thirdLogin(_):
            return .post
        case .sendCode(_):
            return .post
        case .checkCode(_):
            return .post
        case .changePhone(_, _):
            return .patch
        case .destroyAccount(_):
            return .delete
        case .checkIdentify(_):
            return .post
        case .chageEmail(_ ,_ ):
            return .patch
        case .changePassword(_ ,_ ):
            return .patch
        case .getUserInfo:
            return .get
        case .modificationUserInfoSubscribe(_ ):
            return .patch
        case .modificationUserInfoNickname(_ ):
            return .patch
        case .refreshToken(_):
            return .post
        case .checkIsNewUserEmail(_ ):
            return .post
        case .checkIsNewUserCellphone(_ ):
            return .post
        case .resetPassword(_ ):
            return .patch
        case .register(_ ):
            return .post
        case .bindThirdpart(_):
            return .post
        case .unbindThirdpart(_):
            return .delete
        case .getDeviceRegisterToken:
            return .get
        case .adddevicesToGateway(_):
            return .post
        case .addSingleDevice(_):
            return .post
        case .getAllDeviceBasicInfo:
            return .get
        case .getAllDeviceStateInfo:
            return .get
        case .getSingleDeviceInfo(_):
            return .get
        case .excuteDevices(_):
            return .post
        case .getSingleStatusDevice(_):
            return .get
        case .getRelationDevice(_):
            return .get
        case .modifyDeviceName(_,_):
            return .patch
        case .modifyDeviceRoom(_,_):
            return .patch
        case .excutePanelActions(_,_):
            return .post
        case .getPanelButtonsActions(_):
            return .get
        case .setPanelButtonsActions(_,_,_):
            return .put
        case .deleteDevice(_):
            return .delete
        case .startSearch(_,_):
            return .post
        case .stopSearch(_):
            return .post
        case .deleteScene(_):
            return .delete
        case .addScene(_):
            return .post
        case .queryRelation(_):
            return .get
        case .excuteScene(_):
            return .post
        case .modifyScene(_,_):
            return .patch
        case .querySingleScene(_):
            return .get
        case .queryAllScenes:
            return .get
        case .queryAllIntelligents:
            return .get
        case .addIntelligents:
            return .post
        case .queryDetailIntelligent(_):
            return .get
        case .deleteDetailIntelligent(_):
            return .delete
        case .modifyDetailIntelligent(_,_):
            return .patch
        case .queryRelationIntelligent(_):
            return .get
        case .excuteDetailIntelligent(_):
            return .post
        case .disableDetailIntelligent(_):
            return .post
        case .start_upgrade(_,_):
            return .post
        case .queryAllRooms:
            return .get
        case .queryDevicesVersionDescription(_,_,_):
            return .get
        case .devicesUpgradeInfo(_,_):
            return .get
        case .queryDevicesAddList:
            return .get
        case .getVitalSigns(_):
            return .get
        case .getLocationInfo(_):
            return .get
        case .startMonitorLocation(_):
            return.post
        case .stopMonitorLocation(_):
            return .post
        case .startMonitorVital(_):
            return .post
        case .stopMonitorVital(_):
            return .post
        case .queryAllScenesBGImageList:
            return .get
        case .radarLocationExistance(_,_,_):
            return .post
        case .radarLocationHistory(_, _):
            return .get
        case .modificationUserInfoAlertWays(_):
            return .patch
        }
    }
    public var task: Task {
        var param: [String: Any] = [:]
        switch self {
        case .login(let requestModel):
            param = requestModel.kj.JSONObject()
            break
        case .thirdLogin(let thirdLoginModel):
            param = thirdLoginModel.kj.JSONObject()
            break
        case .sendCode(let sendCodeModel):
            param = sendCodeModel.kj.JSONObject()
            break
        case .checkCode(let checkCodeModel):
            param = checkCodeModel.kj.JSONObject()
            break
        case .changePhone(let cellphone,let accessCode ):
            if accessCode.isEmpty {
                param = ["cellphone":cellphone]
            }else{
                param = ["cellphone":cellphone,
                "accessCode":accessCode]
            }
        case .destroyAccount(let accessCode):
            if !accessCode.isEmpty {
                param = ["accessCode":accessCode]
            }
        case .checkIdentify(let loginRequestModel):
            param = loginRequestModel.kj.JSONObject()
            break
        case .chageEmail(let email,let accessCode):
            if accessCode.isEmpty {
                param = ["email":email]
            }else{
                param = ["email":email,
                "accessCode":accessCode]
            }
        case .changePassword(let newPassword,let accessCode):
            if accessCode.isEmpty {
                param = ["newPassword":newPassword]
            }else{
                param = ["newPassword":newPassword,
                "accessCode":accessCode]
            }
        case .modificationUserInfoSubscribe(let subscribe):
            param["subscribe"] = subscribe
            break
        case .modificationUserInfoNickname(let nickname):
            param["nickname"] = nickname
        break
        case .refreshToken(let refreshToken):
            param = ["refreshToken":refreshToken]
            break
        case .checkIsNewUserCellphone(let cellphone):
            param["cellphone"] = cellphone
            break
        case .checkIsNewUserEmail(let email):
            param["email"] = email
            break
        case .resetPassword(let resetPasswordModel):
            param = resetPasswordModel.kj.JSONObject()
            break
        case .register(let registModel ):
            param = registModel.kj.JSONObject()
            break
        case .bindThirdpart(let thirdPartInfoModel):
            param = thirdPartInfoModel.kj.JSONObject()
            break
        case .unbindThirdpart(let thirdPartInfoModel):
            param = thirdPartInfoModel.kj.JSONObject()
            break
        case .adddevicesToGateway(let devices):
            var params = [[String:Any]]()
            for model in devices {
                params.append(model.kj.JSONObject())
            }
            return .requestParameters(parameters: ["jsonArray": params], encoding: JSONArrayEncoding.default)
        case .addSingleDevice(let basicModel):
            param = basicModel.kj.JSONObject()
            break
        case .excuteDevices(let excuteGroups):
            return .requestParameters(parameters: ["jsonArray": excuteGroups.kj.JSONObjectArray()], encoding: JSONArrayEncoding.default)
        case .modifyDeviceRoom( _,let room):
            param = ["room":room]
            break
        case .modifyDeviceName( _,let name):
            param = ["name":name]
            break
        case .setPanelButtonsActions(_, _, let actions):
            param = ["actions":actions.map({
                $0.kj.JSONObject()
                })]
            break
        case .startSearch(_, let time):
            param["time"]=time
            break
        case .addScene(let addScenesModel):
            param = addScenesModel.kj.JSONObject()
            break
        case .modifyScene(let changeScenseInfoModel,_):
            param = changeScenseInfoModel.kj.JSONObject()
            break
        case .addIntelligents(let addIntelligentsModel):
            param = addIntelligentsModel.kj.JSONObject()
            break
        case .modifyDetailIntelligent(_,let changeSmartInfoModel):
            param = changeSmartInfoModel.kj.JSONObject()
            break
        case .start_upgrade(_, let latestSwVersion):
            param["latestSwVersion"] = latestSwVersion
            break
        case .radarLocationExistance(_, let startTime, let endTime):
            param = ["startTime": startTime,"endTime": endTime]
        case .radarLocationHistory(_, let time):
            param = ["time": time]
            return .requestCompositeData(bodyData: Data(), urlParameters: param)
        case .modificationUserInfoAlertWays(let alerWays):
            param = ["alertWays": alerWays]
        default:
            break
        }
        if param.count > 0 {
            return .requestParameters(parameters: param, encoding: JSONEncoding.default)
        }
        return .requestPlain
    }
    public var validate: Bool {
        return false
    }
    public var sampleData: Data {
        return "{}".data(using: String.Encoding.utf8, allowLossyConversion: true)!
    }
    public var headers: [String : String]? {
        var header = [String : String]()
        let uuid = UUID().uuidString
        header["requestId"] = uuid
        header["Content-type"] = "application/json; charset=utf-8"
        return header
    }
}
extension Moya.Response{
    func json<T>() -> T?{
        guard
            let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? T else {
                return nil
        }
        return json
    }
}
struct JSONArrayEncoding: ParameterEncoding {
    static let `default` = JSONArrayEncoding()
    func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var request = try urlRequest.asURLRequest()
        guard let json = parameters?["jsonArray"] else {
            return request
        }
        let data = try JSONSerialization.data(withJSONObject: json, options: [])
        if request.value(forHTTPHeaderField: "Content-Type") == nil {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        request.httpBody = data
        return request
    }
}