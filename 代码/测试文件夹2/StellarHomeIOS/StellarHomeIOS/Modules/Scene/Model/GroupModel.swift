import UIKit
class GroupModel: NSObject {
    var executions: [ExecutionModel] = []
    var willRemove = false 
    var willMerge = false 
    var groupId = -1
    var willRemoveSns: [String] = [] 
    func getExcuteRelationMutex(excuteOld: ExecutionDetail) -> Bool {
        guard let excuteNew = self.executions.first?.execution.first else {
            return false
        }
        if isDetailOffOrAutoOnOff(excuteNew: excuteOld) || isDetailOffOrAutoOnOff(excuteNew: excuteNew) { 
            return true
        }
        switch excuteOld.command {
        case .onOff:
            let onOffOld = excuteOld.params?.onOff
            if onOffOld == "on" && excuteNew.command == .onOff { 
                return true
            }
        case .color,.colorTemperature,.internalScene:
            if excuteNew.command == .color || excuteNew.command == .colorTemperature || excuteNew.command == .internalScene {
                return true
            }
        case .brightness:
            if excuteNew.command == .brightness {
                return true
            }
        default:
            break
        }
        return false
    }
    private func isDetailOffOrAutoOnOff(excuteNew: ExecutionDetail) -> Bool {
        guard let detail = excuteNew.params?.onOff else{
            return false
        }
        if detail == "off" || detail == "autoOnOff" {
            return true
        }
        return false
    }
    class func creatGroupMoel(groupId: Int,param: ExecutionDetailParams,command: Traits,roomId: Int? = nil,lights: [LightModel]? = nil,sceneId: String? = nil) -> GroupModel {
        let model = GroupModel()
        model.groupId = groupId
        if roomId != nil { 
            model.executions.append(getExecution(sn: nil, roomId: roomId, scene: sceneId, groupId: groupId, command: command, param: param))
        }else {
            guard let devices = lights else { 
                model.executions.append(getExecution(sn: nil, roomId: nil, scene: sceneId, groupId: groupId, command: command, param: param))
                return model
            }
            for light in devices { 
                model.executions.append(getExecution(sn: light.sn, roomId: nil, scene: sceneId, groupId: groupId, command: command, param: param))
            }
        }
        return model
    }
    private class func getExecution(sn: String?,roomId: Int?,scene: String?,groupId: Int, command: Traits, param: ExecutionDetailParams) ->ExecutionModel {
        let execution = ExecutionModel()
        execution.room = roomId
        execution.device = sn
        execution.scene = scene
        execution.id = UUID().uuidString
        execution.groupId = groupId
        let detail = ExecutionDetail()
        detail.command = command
        execution.execution.append(detail)
        if command == .execute {
            return execution
        }
        if command == .onOff {
            detail.params = param
            return execution
        }
        execution.execution.append(getOnExedetail())
        detail.params = param
        return execution
    }
    private class func getOnExedetail() ->ExecutionDetail {
        let detail = ExecutionDetail()
        detail.command = .onOff
        let param = ExecutionDetailParams()
        param.onOff = "on"
        detail.params = param
        return detail
    }
}