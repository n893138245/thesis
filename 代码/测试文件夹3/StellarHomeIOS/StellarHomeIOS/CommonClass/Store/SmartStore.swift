import UIKit
struct SmartStore {
    static let sharedStore = SmartStore.init()
    func queryAllIntelligents(success:(([IntelligentDetailModel])->Void)?, failure:((String)->Void)?) {
        Network.request(.queryAllIntelligents,success: { (json) in
            let code = json["code"].intValue
            if code == 0 {
                let jsonArr = json.arrayValue
                var list: [IntelligentDetailModel] = []
                for dic in jsonArr {
                    if let model = dic.description.kj.model(IntelligentDetailModel.self) {
                        list.append(model)
                    }
                }
                success?(list)
            }else{
                failure?("")
            }
        }) { moyaError,error  in
            failure?(error)
        }
    }
    func addIntelligents(addIntelligentsModel:AddIntelligentsModel,success:((JSONDictionary)->Void)?, failure:((String)->Void)?) {
        Network.request(.addIntelligents(addIntelligentsModel),success: { (json) in
            let code = json["code"].intValue
            if code == 0 {
                let jSONDictionary = json.dictionaryObject ?? [String : Any]()
                success?(jSONDictionary)
            }else{
                failure?("")
            }
        }) { moyaError,error  in
            failure?(error)
        }
    }
    func queryDetailIntelligent(id:String,success:((JSONDictionary)->Void)?, failure:((String)->Void)?) {
        Network.request(.queryDetailIntelligent(id: id),success: { (json) in
            let code = json["code"].intValue
            if code == 0 {
                let jSONDictionary = json.dictionaryObject ?? [String : Any]()
                success?(jSONDictionary)
            }else{
                failure?("")
            }
        }) { moyaError,error  in
            failure?(error)
        }
    }
    func deleteDetailIntelligent(id:String,success:((JSONDictionary)->Void)?, failure:((String)->Void)?) {
        Network.request(.deleteDetailIntelligent(id: id),success: { (json) in
            let code = json["code"].intValue
            if code == 0 {
                let jSONDictionary = json.dictionaryObject ?? [String : Any]()
                success?(jSONDictionary)
            }else{
                failure?("")
            }
        }) { moyaError,error  in
            failure?(error)
        }
    }
    func modifyDetailIntelligent(id:String,changeSmartInfoModel:ChangeSmartInfoModel,success:((JSONDictionary)->Void)?, failure:((String)->Void)?) {
        Network.request(.modifyDetailIntelligent(id: id, changeSmartInfoModel: changeSmartInfoModel),success: { (json) in
            let code = json["code"].intValue
            if code == 0 {
                let jSONDictionary = json.dictionaryObject ?? [String : Any]()
                success?(jSONDictionary)
            }else{
                failure?("")
            }
        }) { moyaError,error  in
            failure?(error)
        }
    }
    func queryRelationIntelligent(id:String,success:((JSONDictionary)->Void)?, failure:((String)->Void)?) {
        Network.request(.queryRelationIntelligent(id: id),success: { (json) in
            let code = json["code"].intValue
            if code == 0 {
                let jSONDictionary = json.dictionaryObject ?? [String : Any]()
                success?(jSONDictionary)
            }else{
                failure?("")
            }
        }) { moyaError,error  in
            failure?(error)
        }
    }
    func excuteDetailIntelligent(id:String,success:((JSONDictionary)->Void)?, failure:((String)->Void)?) {
        Network.request(.excuteDetailIntelligent(id: id),success: { (json) in
            let code = json["code"].intValue
            if code == 0 {
                let jSONDictionary = json.dictionaryObject ?? [String : Any]()
                success?(jSONDictionary)
            }else{
                failure?("")
            }
        }) { moyaError,error  in
            failure?(error)
        }
    }
    func disableDetailIntelligent(id:String,success:((JSONDictionary)->Void)?, failure:((String)->Void)?) {
        Network.request(.disableDetailIntelligent(id: id),success: { (json) in
            let code = json["code"].intValue
            if code == 0 {
                let jSONDictionary = json.dictionaryObject ?? [String : Any]()
                success?(jSONDictionary)
            }else{
                failure?("")
            }
        }) { moyaError,error  in
            failure?(error)
        }
    }
} 