import UIKit
class CommandManager: NSObject {
    static let shared = CommandManager()
    func creatOnOffCommandAndSend(deviceGroup: [LightModel], onOff: String, success:((_ result: Any)->Void)?,failure:((_ code: Int,_ message: String)->Void)?) {
        var excuteList: [ExecutionModel] = []
        for lamp in deviceGroup {
            let model = ExecutionModel()
            model.device = lamp.sn
            model.id = UUID().uuidString
            let datail = ExecutionDetail()
            datail.command = .onOff
            let param = ExecutionDetailParams()
            param.onOff = onOff
            datail.params = param
            model.execution.append(datail)
            excuteList.append(model)
        }
        creatRequestWithExecutionList(executionList: excuteList, success: { (pResponse) in
            self.updateLightsStatusWithOnOffResponse(pResponse: pResponse, excuteList: excuteList, onOff: onOff)
            success?(pResponse)
        }) { (code, message) in
            failure?(code,message)
        }
    }
    func creatFallDownAlertCommandAndSend(deviceGroup: [LightModel], isOn: Bool, success:((_ result: Any)->Void)?,failure:((_ code: Int,_ message: String)->Void)?) {
        var excuteList: [ExecutionModel] = []
        for lamp in deviceGroup {
            let model = ExecutionModel()
            model.device = lamp.sn
            model.id = UUID().uuidString
            let datail = ExecutionDetail()
            datail.command = .fallDownAlert
            let param = ExecutionDetailParams()
            param.fallDownAlert = isOn
            datail.params = param
            model.execution.append(datail)
            excuteList.append(model)
        }
        creatRequestWithExecutionList(executionList: excuteList, success: { (pResponse) in
            self.updateLightsStatusWithFallDownAlertResponse(pResponse: pResponse, excuteList: excuteList, isOn: isOn)
            success?(pResponse)
        }) { (code, message) in
            failure?(code,message)
        }
    }
    func creatVitalSignDisappearAlertCommandAndSend(deviceGroup: [LightModel], isOn: Bool, success:((_ result: Any)->Void)?,failure:((_ code: Int,_ message: String)->Void)?) {
        var excuteList: [ExecutionModel] = []
        for lamp in deviceGroup {
            let model = ExecutionModel()
            model.device = lamp.sn
            model.id = UUID().uuidString
            let datail = ExecutionDetail()
            datail.command = .vitalSignDisappearAlert
            let param = ExecutionDetailParams()
            param.vitalSignDisappearAlert = isOn
            datail.params = param
            model.execution.append(datail)
            excuteList.append(model)
        }
        creatRequestWithExecutionList(executionList: excuteList, success: { (pResponse) in
            self.updateLightsStatusWithVitalSignDisappearAlertResponse(pResponse: pResponse, excuteList: excuteList, isOn: isOn)
            success?(pResponse)
        }) { (code, message) in
            failure?(code,message)
        }
    }
    func creatColorCommandAndSend(deviceGroup: [LightModel], color: (r: Int,g: Int,b: Int), success:((_ result: Any)->Void)?,failure:((_ code: Int,_ message: String)->Void)?) {
        var excuteList: [ExecutionModel] = []
        for lamp in deviceGroup {
            let model = ExecutionModel()
            model.device = lamp.sn
            model.id = UUID().uuidString
            let detailColor = ExecutionDetail()
            detailColor.command = .color
            let param = ExecutionDetailParams()
            param.color = color
            detailColor.params = param
            model.execution.append(detailColor)
            excuteList.append(appenOnCommad(model: model))
        }
        creatRequestWithExecutionList(executionList: excuteList, success: { (pResponse) in
            self.updateLightsStatusWithColorResponse(pResponse: pResponse, excuteList: excuteList, color: color)
            success?(pResponse)
        }) { (code, message) in
            failure?(code,message)
        }
    }
    func creatCCTCommandAndSend(deviceGroup: [LightModel], cct: Int, success:((_ result: Any)->Void)?,failure:((_ code: Int,_ message: String)->Void)?) {
        var excuteList: [ExecutionModel] = []
        for lamp in deviceGroup {
            let model = ExecutionModel()
            model.device = lamp.sn
            model.id = UUID().uuidString
            let detailCCT = ExecutionDetail()
            detailCCT.command = .colorTemperature
            let param = ExecutionDetailParams()
            param.cct = cct
            detailCCT.params = param
            model.execution.append(detailCCT)
            excuteList.append(appenOnCommad(model: model))
        }
        creatRequestWithExecutionList(executionList: excuteList, success: { (pResponse) in
            self.updateLightsStatusWithCCTResponse(pResponse: pResponse, excuteList: excuteList, cct: cct)
            success?(pResponse)
        }) { (code, message) in
            failure?(code,message)
        }
    }
    func creatInternalModeCommandAndSend(deviceGroup: [LightModel], internalMode: LightInternalMode, success:((_ result: Any)->Void)?, failure:((_ code: Int,_ message: String)->Void)?) {
        var excuteList: [ExecutionModel] = []
        for lamp in deviceGroup {
            let model = ExecutionModel()
            model.device = lamp.sn
            model.id = UUID().uuidString
            let detailCCT = ExecutionDetail()
            detailCCT.command = .mode
            let param = ExecutionDetailParams()
            param.id = internalMode.id
            detailCCT.params = param
            model.execution.append(detailCCT)
            excuteList.append(appenOnCommad(model: model))
        }
        creatRequestWithExecutionList(executionList: excuteList, success: { (pResponse) in
            self.updateLightsStatusWithModeponse(pResponse: pResponse, excuteList: excuteList, model: internalMode)
            success?(pResponse)
        }) { (code, message) in
            failure?(code,message)
        }
    }
    func creatBringhtnessCommandAndSend(deviceGroup: [LightModel], brightness: Int, success:((_ result: Any)->Void)?,failure:((_ code: Int,_ message: String)->Void)?) {
        var excuteList: [ExecutionModel] = []
        for lamp in deviceGroup {
            let model = ExecutionModel()
            model.device = lamp.sn
            model.id = UUID().uuidString
            let detailB = ExecutionDetail()
            detailB.command = .brightness
            let param = ExecutionDetailParams()
            param.brightness = brightness
            detailB.params = param
            model.execution.append(detailB)
            excuteList.append(appenOnCommad(model: model))
        }
        creatRequestWithExecutionList(executionList: excuteList, success: { (pResponse) in
            self.updateLightsStatusWithBrightnessResponse(pResponse: pResponse, excuteList: excuteList, brightness: brightness)
            success?(pResponse)
        }) { (code, message) in
            failure?(code,message)
        }
    }
    func creatScenesCommandAndSend(scenesId: String, success:((_ result: Any)->Void)?,failure:((_ code: Int,_ message: String)->Void)?) {
        ScenesStore.sharedStore.excuteScene(id: scenesId, success: { (jsonDic) in
            if let block = success {
                block(jsonDic)
            }
        }) { (error) in
            if let block = failure {
                block(-1,"")
            }
        }
    }
    func creatRoomOnOffCammand(roomId: Int, onOff: String, success:((_ result: Any)->Void)?,failure:((_ code: Int,_ message: String)->Void)?) {
        let model = ExecutionModel()
        model.room = roomId
        model.id = UUID().uuidString
        let datail = ExecutionDetail()
        datail.command = .onOff
        let param = ExecutionDetailParams()
        param.onOff = onOff
        datail.params = param
        model.execution.append(datail)
        creatRequestWithExecutionList(executionList: [model], success: { (pResponse) in
            self.updateLightsStatusWithRoomOnOffResponse(pResponse: pResponse, onOff: onOff, roomId: roomId)
            success?(pResponse)
        }) { (code, message) in
            failure?(code,message)
        }
    }
    func creatRoomBritnessCammand(roomId: Int, britness: Int, success:((_ result: Any)->Void)?,failure:((_ code: Int,_ message: String)->Void)?) {
        let model = ExecutionModel()
        model.room = roomId
        model.id = UUID().uuidString
        let datail = ExecutionDetail()
        datail.command = .brightness
        let param = ExecutionDetailParams()
        param.brightness = britness
        datail.params = param
        model.execution.append(datail)
        let pModel = appenOnCommad(model: model)
        creatRequestWithExecutionList(executionList: [pModel], success: { (pResponse) in
            self.updateLightsStatusWithRoomBrightnessResponse(pResponse: pResponse, brightness: britness, roomId: roomId)
            success?(pResponse)
        }) { (code, message) in
            failure?(code,message)
        }
    }
    func creatRoomRGBCammand(roomId: Int, RGB: (r :Int,g :Int,b :Int), success:((_ result: Any)->Void)?,failure:((_ code: Int,_ message: String)->Void)?) {
        let model = ExecutionModel()
        model.room = roomId
        model.id = UUID().uuidString
        let datail = ExecutionDetail()
        datail.command = .color
        let param = ExecutionDetailParams()
        param.color = RGB
        datail.params = param
        model.execution.append(datail)
        let pModel = appenOnCommad(model: model)
        creatRequestWithExecutionList(executionList: [pModel], success: { (pResponse) in
            self.updateLightsStatusWithRoomColorResponse(pResponse: pResponse, color: RGB, roomId: roomId)
            success?(pResponse)
        }) { (code, message) in
            failure?(code,message)
        }
    }
    func creatRoomTemperatureCammand(roomId: Int, cct: Int, success:((_ result: Any)->Void)?,failure:((_ code: Int,_ message: String)->Void)?) {
        let model = ExecutionModel()
        model.room = roomId
        model.id = UUID().uuidString
        let datail = ExecutionDetail()
        datail.command = .colorTemperature
        let param = ExecutionDetailParams()
        param.cct = cct
        datail.params = param
        model.execution.append(datail)
        let pModel = appenOnCommad(model: model)
        creatRequestWithExecutionList(executionList: [pModel], success: { (pResponse) in
            self.updateLightsStatusWithRoomCCTResponse(pResponse: pResponse, cct: cct, roomId: roomId)
            success?(pResponse)
        }) { (code, message) in
            failure?(code,message)
        }
    }
    private func appenOnCommad(model : ExecutionModel) -> ExecutionModel {
        let datailOn = ExecutionDetail()
        datailOn.command = .onOff
        let param = ExecutionDetailParams()
        param.onOff = "on"
        datailOn.params = param
        model.execution.append(datailOn)
        return model
    }
    private func creatRequestWithExecutionList(executionList: [ExecutionModel],success:((_ result: Any)->Void)?,failure:((_ code: Int,_ message: String)->Void)?) {
        DevicesStore.sharedStore().excuteDevices(actions: executionList, success: { (pResponse) in
            success?(pResponse)
        }) { (_) in
            if let block = failure {
                block(-1,"")
            }
        }
    }
    private func getCommandListWithExecutions(executions: [ExecutionModel]) -> [[String: Any]] {
        var groupList: [[String : Any]] = []
        for execute in executions {
            groupList.append(execute.kj.JSONObject())
        }
        return groupList
    }
}
extension CommandManager {
    private func updateLightsStatusWithOnOffResponse(pResponse: Any, excuteList: [ExecutionModel], onOff: String) {
        let excuteUUIDSnList = excuteList.map{($0.id,$0.device)}
        guard let resultList = pResponse as? [[CommonResponseModel]] else {
            return
        }
        for result in resultList[0]{
            for uuidSn in excuteUUIDSnList{
                if uuidSn.0 == result.id {
                    let sn = uuidSn.1
                    guard let light = (DevicesStore.sharedStore().lights.filter{$0.sn == sn}.first) else{
                        return
                    }
                    light.status.onOff = onOff
                }
            }
        }
    }
    private func updateLightsStatusWithRoomOnOffResponse(pResponse: Any, onOff: String, roomId: Int) {
        guard let resultList = pResponse as? [[CommonResponseModel]] else {
            return
        }
        if resultList[0].count == 0 {
            return
        }
        for light in DevicesStore.instance.lights {
            if roomId == 0 { 
                light.status.onOff = onOff
            }else {
                if light.room == roomId {
                    light.status.onOff = onOff
                }
            }
            NotificationCenter.default.post(name: .NOTIFY_DEVICES_UPDATE, object: nil)
        }
    }
    private func updateLightsStatusWithFallDownAlertResponse(pResponse: Any, excuteList: [ExecutionModel], isOn: Bool) {
        let excuteUUIDSnList = excuteList.map{($0.id,$0.device)}
        guard let resultList = pResponse as? [[CommonResponseModel]] else {
            return
        }
        for result in resultList[0]{
            for uuidSn in excuteUUIDSnList{
                if uuidSn.0 == result.id {
                    let sn = uuidSn.1
                    guard let light = (DevicesStore.sharedStore().lights.filter{$0.sn == sn}.first) else{
                        return
                    }
                    light.status.fallDownAlert = isOn
                }
            }
        }
    }
    private func updateLightsStatusWithVitalSignDisappearAlertResponse(pResponse: Any, excuteList: [ExecutionModel], isOn: Bool) {
        let excuteUUIDSnList = excuteList.map{($0.id,$0.device)}
        guard let resultList = pResponse as? [[CommonResponseModel]] else {
            return
        }
        for result in resultList[0]{
            for uuidSn in excuteUUIDSnList{
                if uuidSn.0 == result.id {
                    let sn = uuidSn.1
                    guard let light = (DevicesStore.sharedStore().lights.filter{$0.sn == sn}.first) else{
                        return
                    }
                    light.status.vitalSignDisappearAlert = isOn
                }
            }
        }
    }
    private func updateLightsStatusWithBrightnessResponse(pResponse: Any, excuteList: [ExecutionModel], brightness: Int) {
        let excuteUUIDSnList = excuteList.map{($0.id,$0.device)}
        guard let resultList = pResponse as? [[CommonResponseModel]] else {
            return
        }
        for result in resultList[0]{
            for uuidSn in excuteUUIDSnList{
                if uuidSn.0 == result.id {
                    let sn = uuidSn.1
                    guard let light = (DevicesStore.sharedStore().lights.filter{$0.sn == sn}.first) else{
                        return
                    }
                    light.status.brightness = brightness
                    light.status.onOff = "on"
                }
            }
        }
        NotificationCenter.default.post(name: .NOTIFY_DEVICES_UPDATE, object: nil)
    }
    private func updateLightsStatusWithRoomBrightnessResponse(pResponse: Any, brightness: Int, roomId: Int) {
        guard let resultList = pResponse as? [[CommonResponseModel]] else {
            return
        }
        if resultList[0].count == 0 {
            return
        }
        for light in DevicesStore.instance.lights {
            if roomId == 0 { 
                light.status.brightness = brightness
                light.status.onOff = "on"
            }else {
                if light.room == roomId {
                    light.status.brightness = brightness
                    light.status.onOff = "on"
                }
            }
        }
        NotificationCenter.default.post(name: .NOTIFY_DEVICES_UPDATE, object: nil)
    }
    private func updateLightsStatusWithColorResponse(pResponse: Any, excuteList: [ExecutionModel], color: (r:Int,g:Int,b:Int)) {
        let excuteUUIDSnList = excuteList.map{($0.id,$0.device)}
        guard let resultList = pResponse as? [[CommonResponseModel]] else {
            return
        }
        for result in resultList[0]{
            for uuidSn in excuteUUIDSnList{
                if uuidSn.0 == result.id {
                    let sn = uuidSn.1
                    guard let light = (DevicesStore.sharedStore().lights.filter{$0.sn == sn}.first) else{
                        return
                    }
                    light.status.color = color
                    light.status.currentMode = .color
                    light.status.onOff = "on"
                }
            }
        }
        NotificationCenter.default.post(name: .NOTIFY_DEVICES_UPDATE, object: nil)
    }
    private func updateLightsStatusWithRoomColorResponse(pResponse: Any, color: (r:Int,g:Int,b:Int), roomId: Int) {
        guard let resultList = pResponse as? [[CommonResponseModel]] else {
            return
        }
        if resultList[0].count == 0 {
            return
        }
        for light in DevicesStore.instance.lights {
            if roomId == 0 { 
                light.status.color = color
                light.status.currentMode = .color
                light.status.onOff = "on"
            }else {
                if light.room == roomId {
                    light.status.color = color
                    light.status.currentMode = .color
                    light.status.onOff = "on"
                }
            }
        }
        NotificationCenter.default.post(name: .NOTIFY_DEVICES_UPDATE, object: nil)
    }
    private func updateLightsStatusWithCCTResponse(pResponse: Any, excuteList: [ExecutionModel], cct: Int) {
        let excuteUUIDSnList = excuteList.map{($0.id,$0.device)}
        guard let resultList = pResponse as? [[CommonResponseModel]] else {
            return
        }
        for result in resultList[0]{
            for uuidSn in excuteUUIDSnList{
                if uuidSn.0 == result.id {
                    let sn = uuidSn.1
                    guard let light = (DevicesStore.sharedStore().lights.filter{$0.sn == sn}.first) else{
                        return
                    }
                    light.status.cct = cct
                    light.status.currentMode = .cct
                    light.status.onOff = "on"
                }
            }
        }
        NotificationCenter.default.post(name: .NOTIFY_DEVICES_UPDATE, object: nil)
    }
    private func updateLightsStatusWithModeponse(pResponse: Any, excuteList: [ExecutionModel], model: LightInternalMode) {
        let excuteUUIDSnList = excuteList.map{($0.id,$0.device)}
        guard let resultList = pResponse as? [[CommonResponseModel]] else {
            return
        }
        for result in resultList[0]{
            for uuidSn in excuteUUIDSnList{
                if uuidSn.0 == result.id {
                    let sn = uuidSn.1
                    guard let light = (DevicesStore.sharedStore().lights.filter{$0.sn == sn}.first) else{
                        return
                    }
                    light.status.onOff = "on"
                    light.status.currentMode = .mode
                    light.status.mode = model.id
                    guard let pCCT = model.params?.cct else { return }
                    light.status.cct = pCCT
                    guard let brightness = model.params?.brightness else { return }
                    light.status.brightness = brightness
                }
            }
        }
        NotificationCenter.default.post(name: .NOTIFY_DEVICES_UPDATE, object: nil)
    }
    private func updateLightsStatusWithRoomCCTResponse(pResponse: Any, cct: Int, roomId: Int) {
        guard let resultList = pResponse as? [[CommonResponseModel]] else {
            return
        }
        if resultList[0].count == 0 {
            return
        }
        for light in DevicesStore.instance.lights {
            if roomId == 0 { 
                light.status.cct = cct
                light.status.currentMode = .cct
                light.status.onOff = "on"
            }else {
                if light.room == roomId {
                    light.status.cct = cct
                    light.status.currentMode = .cct
                    light.status.onOff = "on"
                }
            }
        }
        NotificationCenter.default.post(name: .NOTIFY_DEVICES_UPDATE, object: nil)
    }
}