import UIKit
struct ScenesStore {
    static let sharedStore = ScenesStore.init()
    func deleteScene(sn: String, success:((JSONDictionary)->Void)?, failure:((String)->Void)?) {
        Network.request(.deleteScene(id: sn),success: { (json) in
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
    func addScenes(addScenesModel: AddScenesModel, success:((JSONDictionary)->Void)?, failure:((String)->Void)?) {
        Network.request(.addScene(addScenesModel),success: { (json) in
            let code = json["code"].intValue
            if code == 0 {
                let jSONDictionary = json.dictionaryObject ?? [String : Any]()
                success?(jSONDictionary)
            }else{
                if code == 20004 {
                    failure?("该名称已存在")
                }else {
                    failure?("")
                }
            }
        }) { moyaError,error  in
            failure?(error)
        }
    }
    func queryRelation(id: String, success:((JSONDictionary)->Void)?, failure:((String)->Void)?) {
        Network.request(.queryRelation(id: id),success: { (json) in
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
    func excuteScene(id: String, success:((JSONDictionary)->Void)?, failure:((String)->Void)?) {
        Network.request(.excuteScene(id: id),success: { (json) in
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
    func modifyScene(changeScenseInfoModel:ChangeScenseInfoModel,id: String,mod success:((JSONDictionary)->Void)?, failure:((String)->Void)?) {
        Network.request(.modifyScene(changeScenseInfoModel: changeScenseInfoModel, id: id),success: { (json) in
            let code = json["code"].intValue
            if code == 0 {
                let jSONDictionary = json.dictionaryObject ?? [String : Any]()
                success?(jSONDictionary)
            }else if code == 20004 {
                failure?("该名称已存在")
            }else {
                failure?("")
            }
        }) { moyaError,error  in
            failure?(error)
        }
    }
    func querySingleScene(id: String,success:((JSONDictionary)->Void)?, failure:((String)->Void)?) {
        Network.request(.querySingleScene(id: id),success: { (json) in
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
    func queryAllScenesBGImageList(success:((JSONDictionary)->Void)?, failure:((String)->Void)?) {
        Network.request(.queryAllScenesBGImageList,success: { (json) in
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
    func queryAllScenes(success:(([ScenesModel])->Void)?, failure:((String)->Void)?) {
        Network.request(.queryAllScenes,success: { (json) in
            let code = json["code"].intValue
            if code == 0 {
                let jsonArr = json.arrayValue
                var list: [ScenesModel] = []
                for dic in jsonArr {
                    if let model = dic.description.kj.model(ScenesModel.self) {
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
}