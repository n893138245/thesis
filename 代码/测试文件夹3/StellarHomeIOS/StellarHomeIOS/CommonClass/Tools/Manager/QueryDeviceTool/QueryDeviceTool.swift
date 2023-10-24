import UIKit
class QueryDeviceTool: NSObject {
    static func queryScenes(completion: (() -> Void)? = nil){
        ScenesStore.sharedStore.queryAllScenes(success: { (arr) in
            if arr.count == 0 {
                QueryDeviceTool.creatScenes(completion: {
                    completion?()
                })
            }else{
                StellarAppManager.sharedManager.user.mySceneModelArr = arr
                completion?()
            }
        }) { (error) in
            QueryDeviceTool.creatScenes(completion: {
                completion?()
            })
        }
    }
    static func creatScenes(completion: (() -> Void)? = nil){
        let group = DispatchGroup.init()
        let devicesQueue = DispatchQueue(label: "com.scenesQueue", qos: .default, attributes: .concurrent, autoreleaseFrequency: .workItem, target: nil)
        group.enter()
        devicesQueue.async(group: group, qos: .default, flags: []) {
            let addScenesModel = AddScenesModel()
            addScenesModel.name = "游戏时间"
            addScenesModel.actions = [ExecutionModel]()
            addScenesModel.backImageUrl = "/images/scene_1.png"
            addScenesModel.isDefault = true
            ScenesStore.sharedStore.addScenes(addScenesModel: addScenesModel, success: { (jsonDic) in
                let model = jsonDic.kj.model(ScenesModel.self)
                StellarAppManager.sharedManager.user.mySceneModelArr.append(model)
                group.leave()
            }) { (error) in
                group.leave()
            }
        }
        group.enter()
        devicesQueue.async(group: group, qos: .default, flags: []) {
            let addScenesModel = AddScenesModel()
            addScenesModel.name = "会议模式"
            addScenesModel.actions = [ExecutionModel]()
            addScenesModel.backImageUrl = "/images/scene_3.png"
            addScenesModel.isDefault = true
            ScenesStore.sharedStore.addScenes(addScenesModel: addScenesModel, success: { (jsonDic) in
                let model = jsonDic.kj.model(ScenesModel.self)
                StellarAppManager.sharedManager.user.mySceneModelArr.append(model)
                group.leave()
            }) { (error) in
                group.leave()
            }
        }
        group.enter()
        devicesQueue.async(group: group, qos: .default, flags: []) {
            let addScenesModel = AddScenesModel()
            addScenesModel.name = "观影模式"
            addScenesModel.actions = [ExecutionModel]()
            addScenesModel.backImageUrl = "/images/scene_2.png"
            addScenesModel.isDefault = true
            ScenesStore.sharedStore.addScenes(addScenesModel: addScenesModel, success: { (jsonDic) in
                let model = jsonDic.kj.model(ScenesModel.self)
                StellarAppManager.sharedManager.user.mySceneModelArr.append(model)
                group.leave()
            }) { (error) in
                group.leave()
            }
        }
        group.notify(queue: devicesQueue) {
            DispatchQueue.main.async(execute: {
                completion?()
            })
        }
    }
}