import UIKit
@objc protocol AddOpreationViewModelDelegate {
    func pushViewController(vc:UIViewController)
    func present(vc: UIViewController)
    func riceveDataChange(datas: [GroupModel])
}
class AddOpreationViewModel: NSObject {
    var dataList = [GroupModel]()
    weak var delegate: AddOpreationViewModelDelegate?
    func getActionsheetResult(group: GroupModel) -> (isHaveOnAction: Bool,isHaveOffAction:Bool,isHaveAutoOnOffAction:Bool,aTitle: String) {
        var haveOnAction = false 
        var haveOffAction = false 
        var haveAutoOnOffAction = false
        if let fristExcution = group.executions.first?.execution.first,fristExcution.command == .onOff {
            let onOff = fristExcution.params?.onOff
            if onOff == "on" {
                haveOnAction = true
            }else if onOff == "off" {
                haveOffAction = true
            }else {
                haveAutoOnOffAction = true
            }
        }
        var title = StellarLocalizedString("SMART_DEVICE_COUNT")
        if group.executions.count > 0 {
            title = "\(group.executions.count)" + StellarLocalizedString("SMART_DEVICE_COUNT")
        }
        return (haveOnAction,haveOffAction,haveAutoOnOffAction,title)
    }
    func removeOldGroupAndFilterDataGruops(newGroup: GroupModel, oldGroup: GroupModel) -> [GroupModel]  {
        dataList.removeAll(where: { $0.groupId == oldGroup.groupId })
        return filterGroup(newGroup: newGroup)
    }
    func isHiddenRightTopButton() -> Bool {
        if dataList.count == 0 || getDataType() == .executeScenesType { 
            return true
        }
        return false
    }
    func filterGroup(newGroup: GroupModel) -> [GroupModel] {
        if dataList.isEmpty {
            dataList.append(newGroup)
            return dataList
        }
        if getNewGroupControlType(newGroup: newGroup) == .controlDeviceType {
            return filterControlDevice(newGroup: newGroup)
        }else if getNewGroupControlType(newGroup: newGroup) == .executeScenesType {
            dataList.removeAll()
            dataList.append(newGroup)
            return dataList
        }
        return filterControlRoom(newGroup: newGroup)
    }
    func getNewGroupControlType(newGroup: GroupModel) -> DataType {
        guard let execution = newGroup.executions.first else {
            return .emptyType
        }
        if execution.room != nil {
            return .controlRoomType
        }else if execution.device != nil {
            return .controlDeviceType
        }else if execution.scene != nil {
            return .executeScenesType
        }
        return .emptyType
    }
    func filterControlDevice(newGroup: GroupModel) ->[GroupModel] {
        var willRemoveOrMergeOld = false 
        removeRedundantOnCommands(newGroup: newGroup) 
        for oldGroup in dataList {
            if newGroup.getExcuteRelationMutex(excuteOld: oldGroup.executions.first?.execution.first ?? ExecutionDetail()) {
                removeSameSnsExcution(oldGroup: oldGroup, newGroup: newGroup)
                if oldGroup.executions.count > 0 && newGroup.executions.first?.execution.first?.params == oldGroup.executions.first?.execution.first?.params { 
                    oldGroup.willMerge = true 
                }
                willRemoveOrMergeOld = true
            }
        }
        willRemoveOrMergeOld ? removeOrMregeOldGroup(newGroup: newGroup):dataList.append(newGroup)
        if dataList.count > 1 {
            dataList.sort(by: {$0.groupId < $1.groupId})
        }
        return dataList
    }
    func filterControlRoom(newGroup: GroupModel) -> [GroupModel] {
        var haveWillRemoveData = false
        for oldGroup in dataList {
            if newGroup.executions.first?.room == oldGroup.executions.first?.room {
                if newGroup.getExcuteRelationMutex(excuteOld: oldGroup.executions.first?.execution.first ?? ExecutionDetail()) {
                    oldGroup.willRemove = true
                    haveWillRemoveData = true
                }
            }else {
                if oldGroup.executions.first?.room == 0 {
                    oldGroup.willRemove = true
                    haveWillRemoveData = true
                }                         
            }
        }
        if haveWillRemoveData {
            dataList.removeAll(where: {$0.willRemove})
            dataList.append(newGroup)
        }else {
            dataList.append(newGroup)
        }
        if dataList.count > 1 {
            dataList.sort(by: {$0.groupId < $1.groupId})
        }
        return dataList
    }
    func removeRedundantOnCommands(newGroup: GroupModel) { 
        let trunOnList = newGroup.executions.filter({$0.execution.first?.params?.onOff == "on"})
        var allActions = [ExecutionModel]()
        for groupModel in dataList {
            allActions.append(contentsOf: groupModel.executions)
        }
        for action in trunOnList {
            for oldAction in allActions {
                if oldAction.device == action.device && oldAction.execution.count > 1 {
                    oldAction.execution.removeAll {$0.params?.onOff == "on"}
                }
            }
        }
    }
    func removeSameSnsExcution(oldGroup: GroupModel, newGroup: GroupModel) {
        newGroup.executions.forEach { (newExe) in
            oldGroup.executions.removeAll { $0.device == newExe.device }
        }
    }
    private func removeOrMregeOldGroup(newGroup: GroupModel) {
        dataList.removeAll { $0.executions.isEmpty }
        for oldGroup in dataList {
            if oldGroup.willMerge {
                for excute in oldGroup.executions {
                    excute.groupId = newGroup.groupId
                    newGroup.executions.append(excute)
                    oldGroup.willRemove = true
                }
            }
        }
        dataList.removeAll { $0.willRemove }
        dataList.append(newGroup)
    }
    func getBrightnessDeviceGroup(gruop: GroupModel) -> [LightModel] {
        var deviceGroup = [LightModel]() 
        for excution in gruop.executions {
            let light = LightModel()
            light.sn = excution.device ?? ""
            deviceGroup.append(light)
        }
        let firstLight = deviceGroup.first ?? LightModel()
        firstLight.name = getLightModelWithSn(sn: firstLight.sn).name
        if gruop.executions.first?.execution.first?.command == .brightness { 
            firstLight.status.brightness = gruop.executions.first?.execution.first?.params?.brightness ?? 0
        }else { 
            firstLight.status.brightness = getLightModelWithSn(sn: firstLight.sn).status.brightness
        }
        deviceGroup.remove(at: 0)
        deviceGroup.insert(firstLight, at: 0)
        return deviceGroup
    }
    func getColorDeviceGroup(gruop: GroupModel) -> [LightModel]{
        var deviceGroup = [LightModel]()
        for excution in gruop.executions {
            if let light = DevicesStore.instance.lights.first(where: {$0.sn == excution.device}) {
                deviceGroup.append(light)
            }
        }
        deviceGroup.sort { (light1, light2) -> Bool in
            return light1.traits?.count ?? 0 > light2.traits?.count ?? 0
        }
        return deviceGroup
    }
    func changeGroupToOnOffExcutions(gruop: GroupModel,onOff: String) -> [GroupModel] {
        for execution in gruop.executions {
            for detail in execution.execution {
                detail.command = .onOff
                let params = ExecutionDetailParams()
                params.onOff = onOff
                detail.params = params
            }
        }
        return removeOldGroupAndFilterDataGruops(newGroup: gruop, oldGroup: gruop)
    }
    func filterLightTriats(group: GroupModel, hasRoomId: Bool = false) -> [Traits] {
        let allTriats:[Traits] = [.onOff,.brightness,.color,.colorTemperature,.internalScene]
        if hasRoomId { 
            guard let roomId = group.executions.first?.room else {
                return allTriats
            }
            let deviceInstance = DevicesStore.instance
            if roomId == 0 {
                return deviceInstance.getSumOfTriats(lights: deviceInstance.lights)
            }
            return deviceInstance.getSumOfTriats(lights: deviceInstance.lights.filter({$0.room == roomId}))
        }
        var allLights = [LightModel]()
        group.executions.forEach({
            allLights.append(getLightModelWithSn(sn: $0.device ?? ""))
        })
        return DevicesStore.instance.getSumOfTriats(lights: allLights)
    }
    func getLightModelWithSn(sn: String) -> LightModel {
        return DevicesStore.instance.lights.first(where: {$0.sn == sn}) ?? LightModel()
    }
    func modifyGoupDevices(list: [LightModel], group: GroupModel) -> [GroupModel] {
        if list.isEmpty {
            dataList.removeAll(where: { $0.groupId == group.groupId })
            return dataList
        }else {
            let excutionOld = group.executions.first ?? ExecutionModel()
            group.executions.removeAll()
            for light in list {
                let excution = ExecutionModel()
                excution.device = light.sn
                excution.execution = excutionOld.execution
                excution.groupId = group.groupId
                group.executions.append(excution)
            }
            dataList.removeAll(where: { $0.groupId == group.groupId })
            if !dataList.isEmpty {
                dataList = filterGroup(newGroup: group)
            }else {
                dataList.append(group)
            }
        }
        return dataList
    }
    func getAllActions(datas: [GroupModel]) -> [ExecutionModel] {
        var actions = [ExecutionModel]()
        for group in datas {
            for excution in group.executions {
                actions.append(excution)
            }
        }
        if getDataType() == .controlDeviceType { 
            var notNeedsOnSns = [String]()
            for execution in actions {
                for detail in execution.execution {
                    if detail.command == .onOff && !notNeedsOnSns.contains(execution.device ?? "") {
                        notNeedsOnSns.append(execution.device ?? "")
                    }
                }
            }
            for action in actions {
                if !notNeedsOnSns.contains(action.device ?? "") {
                    notNeedsOnSns.append(action.device ?? "")
                    let detail = ExecutionDetail()
                    detail.command = .onOff
                    let params = ExecutionDetailParams()
                    params.onOff = "on"
                    detail.params = params
                    action.execution.append(detail)
                }
            }
        }
        return actions
    }
    func judgeLightsAreSameRoom(datas: [GroupModel]) -> (sameRoom: Bool, restOfLights: [LightModel]?) {
        if getDataType() != .controlDeviceType {
            return (false,nil)
        }
        var actions = [ExecutionModel]()
        for group in datas {
            for excution in group.executions {
                actions.append(excution)
            }
        }
        var allLights = [LightModel]()
        actions.forEach { (exe) in
            if let sn = exe.device {
                if !allLights.contains(where: {$0.sn == sn}) {
                    allLights.append(getLightModelWithSn(sn: sn))
                }
            }
        }
        let roomIds = allLights.map { (light) -> Int in
            return light.room ?? 0
        } 
        if roomIds.contains(0) || roomIds.contains(-1) { 
            return (false,nil)
        }
        let firstRoomId = roomIds.first ?? 0
        let filterIds = roomIds.filter({$0 == firstRoomId })
        var lightRoom = DevicesStore.sharedStore().sortedLightsDic[firstRoomId] ?? [LightModel]()
        if filterIds.count == roomIds.count && lightRoom.count >= roomIds.count {
            allLights.forEach { (light) in
                lightRoom.removeAll(where: {$0.sn == light.sn })
            }
            lightRoom.removeAll(where: { $0.remoteType == .locally }) 
            if !lightRoom.isEmpty { 
                return (true,lightRoom)
            }
        }
        return (false,nil)
    }
    func showTrunOffOtherLinghtsTipAlert(lights: [LightModel], datas: [GroupModel], userClicked: (() ->Void)?) {
        let room = StellarRoomManager.shared.getRoom(roomId: lights.first?.room ?? 0)
        let alert = StellarMineAlertView.init(
            icon: UIImage(named: "icon_scence_lamp") ?? UIImage(),
            message: "执行此操作是否需要\n关闭 \(room.name ?? "该房间")内 其余的灯？",
            leftTitle: StellarLocalizedString("ALERT_NO_SHUT_DOWN"),
            rightTitle: StellarLocalizedString("ALERT_NEED_SHUT_DOWN"))
        alert.rightClickBlock = { 
            let aGroup = GroupModel()
            aGroup.groupId = (datas.last?.groupId ?? 0) + 1
            lights.forEach { (lamp) in
                let execution = ExecutionModel()
                execution.device = lamp.sn
                execution.groupId = aGroup.groupId
                execution.id = UUID().uuidString
                let detail = ExecutionDetail()
                detail.command = .onOff
                let params = ExecutionDetailParams()
                params.onOff = "off"
                detail.params = params
                execution.execution.append(detail)
                aGroup.executions.append(execution)
            }
            self.dataList = self.filterGroup(newGroup: aGroup)
            self.sendActionsChangeSingal()
            userClicked?()
        }
        alert.leftClickBlock = {
            userClicked?()
        }
        alert.show()
    }
    func getDataWithAcions(actions: [ExecutionModel]) -> [GroupModel] {
        var copyActions = [ExecutionModel]()
        for execution in actions {
            let newExecution = ExecutionModel()
            newExecution.device = execution.device
            newExecution.room = execution.room
            newExecution.id = execution.id
            newExecution.groupId = execution.groupId
            newExecution.scene = execution.scene
            for detail in execution.execution {
                let excutionDetail = ExecutionDetail()
                excutionDetail.command = detail.command
                excutionDetail.params = detail.params
                newExecution.execution.append(excutionDetail)
            }
            copyActions.append(newExecution)
        }
        if copyActions.count > 0 {
            if copyActions.first?.execution.first?.command == .execute {
                let group = GroupModel()
                group.groupId = 0
                group.executions = [copyActions.first] as? [ExecutionModel] ?? [ExecutionModel]()
                dataList.append(group)
                return dataList
            }
            var groups = [Int]()
            for excution in copyActions {
                let groupId = excution.groupId ?? 0
                if !groups.contains(groupId){
                    groups.append(groupId)
                }
            }
            for groupId in groups {
                let group = GroupModel()
                group.groupId = groupId
                group.executions = copyActions.filter({ (model) -> Bool in
                    return model.groupId == groupId
                })
                dataList.append(group)
            }
        }
        return dataList
    }
    func getDataType() -> DataType {
        guard let group = dataList.first else {
            return .emptyType
        }
        if let action = group.executions.first,action.room != nil {
            return .controlRoomType
        }
        if let exection = group.executions.first?.execution.first,exection.command == .execute {
            return .executeScenesType
        }
        return .controlDeviceType
    }
    func getSelectScenId() -> String? {
        guard let group = dataList.first else {
            return nil
        }
        if let exection = group.executions.first?.execution.first,exection.command == .execute {
            return group.executions.first?.scene
        }
        return nil
    }
    func removeAt(index: Int) -> [GroupModel] {
        dataList.remove(at: index)
        return dataList
    }
    func getChangeDevicesGroupDevicesList(group : GroupModel) -> [LightModel] {
        var deviceList = [LightModel]()
        for excution in group.executions {
            if let light = DevicesStore.instance.lights.first(where: {$0.sn == excution.device}) {
                deviceList.append(light)
            }
        }
        return deviceList
    }
    var creatGroupDataModel: CreatGroupDataModel {
        get {
            let model = CreatGroupDataModel()
            model.myDataType = getDataType()
            if getDataType() == .executeScenesType {
                model.selectedScenseId = getSelectScenId()
            }
            model.sourceVc = .panelSetting
            if let lastGroup = dataList.last {
                model.groupId = lastGroup.groupId + 1
                model.controlRoomType = getControlRoomType(groupModel: lastGroup)
            }else {
                model.groupId = 1
            }
            return model
        }
    }
    private func getControlRoomType(groupModel: GroupModel) -> ControlRoomType {
        guard let roomId = groupModel.executions.first?.room else {
            return .none
        }
        if roomId == 0 {
            return .allRoom
        }
        return.otherRoom
    }
    func sendActionsChangeSingal() {
        delegate?.riceveDataChange(datas: dataList)
    }
    func showActionViewWithGroup(group: GroupModel, hasRoomId:Bool) {
        let result = getActionsheetResult(group: group) 
        var actionTriats = getWillShowActionViewTriats(group: group, hasRoomId: hasRoomId)
        var viewHeight: CGFloat = 230
        if result.isHaveAutoOnOffAction { 
            actionTriats.removeAll(where: { $0 == .autoOnOff})
        }else if result.isHaveOffAction {
            actionTriats.removeAll(where: { $0 == .off})
        }else if result.isHaveOnAction {
            actionTriats.removeAll(where: { $0 == .on})
        }
        viewHeight += CGFloat(60*actionTriats.count)
        var viewTitle = ""
        var leftTile = StellarLocalizedString("ALERT_SELECT_DEVICE")
        var facLights = [LightModel]()
        let allLights = DevicesStore.instance.lights.filter({$0.remoteType != .locally})
        if hasRoomId { 
            leftTile = StellarLocalizedString("ALERT_CHANGE_ROOM")
            let roomId = group.executions.first?.room ?? 0
            viewTitle = roomId == 0 ? "全部":"\(StellarRoomManager.shared.getRoom(roomId: roomId).name ?? "全部")"
            facLights = viewTitle == "全部" ? allLights:allLights.filter({ $0.room == roomId })
        }else { 
            viewTitle = result.aTitle
            for execution in group.executions {
                if let light = allLights.first(where: {$0.sn == execution.device}) {
                    facLights.append(light)
                }
            }
        }
        showBottomView(height: viewHeight,
                       title: viewTitle,
                       lights: facLights,
                       actions: actionTriats,
                       hasRoomId: hasRoomId,
                       leftTile: leftTile,
                       group: group)
    }
    func showBottomView(height: CGFloat,title: String,lights: [LightModel],actions: [ActionTriats],hasRoomId: Bool,leftTile: String, group: GroupModel) {
        let bottomPopView = SSBottomPopView.SSBottomPopView()
        bottomPopView.setContentHeight(height: height)
        let fac = HBottomSelectionDetailLightsFactory()
        fac.actions = actions
        fac.devices = lights
        bottomPopView.leftButton.setTitle(leftTile, for: .normal)
        bottomPopView.setDisplayFactory(factory: fac)
        if group.executions.first?.room == 0 {
            bottomPopView.setupViews(title: title)
        }else {
            bottomPopView.setupViews(title: title) { [weak self, weak bottomPopView] in
                bottomPopView?.hidden(complete: {
                    hasRoomId ? self?.changeRoomWithGroup(group: group):self?.changeDevicesWithGroup(group: group)
                })
            }
        }
        bottomPopView.show()
        fac.actionChangeBlock = { [weak self, weak bottomPopView] type in
            bottomPopView?.hidden(complete: {
                switch type {
                case .on:
                    self?.dataList = (self?.changeGroupToOnOffExcutions(gruop: group, onOff: "on")) ?? [GroupModel]()
                    self?.sendActionsChangeSingal()
                case .off:
                    self?.dataList = (self?.changeGroupToOnOffExcutions(gruop: group, onOff: "off")) ?? [GroupModel]()
                    self?.sendActionsChangeSingal()
                case .autoOnOff:
                    self?.dataList = (self?.changeGroupToOnOffExcutions(gruop: group, onOff: "autoOnOff")) ?? [GroupModel]()
                    self?.sendActionsChangeSingal()
                case .brightness:
                    self?.changeGroupBrightnessExcutions(gruop: group, hasRoomId: hasRoomId)
                case .color:
                    self?.changeGroupColorExcutions(gruop: group, hasRoomId: hasRoomId)
                }
            })
        }
    }
    func getWillShowActionViewTriats(group: GroupModel,hasRoomId: Bool) -> [ActionTriats] {
        let result = filterLightTriats(group: group,hasRoomId: hasRoomId) 
        var facActions :[ActionTriats] = [.on,.off,.autoOnOff,.brightness] 
        if result.contains(.color) || result.contains(.colorTemperature) || result.contains(.internalScene) && !facActions.contains(.color) {
            facActions.append(.color)
        }
        return facActions
    }
    func changeRoomWithGroup(group: GroupModel) {
        let vc = ControllRoomViewController.init()
        vc.creatGroupDataModel = creatGroupDataModel
        vc.isModify = true
        vc.modifyBlock = { [weak self] roomId in
            self?.dataList.removeAll(where: { $0.groupId == group.groupId })
            self?.dataList = self?.filterControlRoom(newGroup: self?.getNewRoomGroup(group: group, room: roomId) ?? GroupModel()) ?? [GroupModel]()
            self?.sendActionsChangeSingal()
        }
        delegate?.pushViewController(vc: vc)
    }
    private func getNewRoomGroup(group :GroupModel, room: Int?) -> GroupModel {
        let newGroup = GroupModel()
        newGroup.groupId = group.groupId
        group.executions.forEach({$0.room = room})
        return group
    }
    func changeDevicesWithGroup(group: GroupModel) {
        let vc = SelectLightsViewController.init()
        vc.selectedType = .change
        vc.selctedLights = getChangeDevicesGroupDevicesList(group: group)
        vc.selectCompleteBlock = { [weak self] (list) in
            self?.dataList = (self?.modifyGoupDevices(list: list, group: group)) ?? [GroupModel]()
            self?.sendActionsChangeSingal()
        }
        delegate?.pushViewController(vc: vc)
    }
    func changeGroupBrightnessExcutions(gruop: GroupModel, hasRoomId: Bool) {
        let vc = BrightnessControlViewController.init()
        vc.isModify = true
        vc.creatGroupDataModel = creatGroupDataModel
        if hasRoomId {
            vc.excution = gruop.executions.first
        }else {
            let lights = getBrightnessDeviceGroup(gruop: gruop)
            vc.lampModel = lights.first ?? LightModel()
            vc.lightGroup = lights
        }
        vc.modifyBlock = { [weak self] (newGroup) in
            self?.dataList = (self?.removeOldGroupAndFilterDataGruops(newGroup: newGroup, oldGroup: gruop)) ?? [GroupModel]()
            self?.sendActionsChangeSingal()
        }
        delegate?.pushViewController(vc: vc)
    }
    func changeGroupColorExcutions(gruop: GroupModel,hasRoomId: Bool) {
        let vc = ControlColorViewController.init()
        vc.isModify = true
        vc.creatGroupDataModel = creatGroupDataModel
        if hasRoomId {
            vc.excution = gruop.executions.first
        }else {
            let lights = getColorDeviceGroup(gruop: gruop)
            vc.lightGroup = lights
        }
        vc.modifyBlock = { [weak self] (newGroup) in
            self?.dataList = (self?.removeOldGroupAndFilterDataGruops(newGroup: newGroup, oldGroup: gruop)) ?? [GroupModel]()
            self?.sendActionsChangeSingal()
        }
        delegate?.pushViewController(vc: vc)
    }
}