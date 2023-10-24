import UIKit
class IntelligentsViewModel: AddOpreationViewModel {
    var smartModel: IntelligentDetailModel?
    var myDetailType: SceneDetailType = .creatType
    func isEanbleToSave(actions: [GroupModel], condition: IntelligentDetailModelCondition?, title: String) -> Bool {
        if myDetailType == .creatType { 
            if actions.count > 0 && condition != nil {
                return true
            }
        }
        guard let model = smartModel else {
            return false
        }
        if actions.isEmpty {
            return false
        }
        var pActionList = [ExecutionModel]()
        for pModel in actions {
            for actionModel in pModel.executions {
                pActionList.append(actionModel)
            }
        }
        if condition != model.condition.first || title != model.name || pActionList != model.actions {
            return true
        }
        return false
    }
    func updateSmartModel(model: IntelligentDetailModel?) {
        smartModel = model
    }
    override var creatGroupDataModel: CreatGroupDataModel {
        get {
            let model = super.creatGroupDataModel
            model.sourceVc = .creatSmart
            return model
        }
    }
    func isOpeningTimer() -> Bool {
        guard let model = smartModel else {
            return false
        }
        if let condition = model.condition.first,condition.type == .countdown && model.enable && model.available {
            return true
        }
        return false
    }
    func addIntelligents(condition: IntelligentDetailModelCondition?, name: String, datas: [GroupModel], success: (() -> Void)?, failure: (() ->Void)?) {
        StellarProgressHUD.showHUD()
        let addIntelligentsModel = AddIntelligentsModel()
        addIntelligentsModel.backImageId = 0
        if condition?.type == .timing {
            let theCondition = condition?.kj.JSONString().kj.model(type: IntelligentDetailModelCondition.self) as? IntelligentDetailModelCondition
            let dateFamatter = DateFormatter()
            dateFamatter.dateFormat = "HH:mm"
            dateFamatter.timeZone = TimeZone.current
            dateFamatter.locale = Locale.init(identifier: TimeZone.current.identifier)
            let newDate = dateFamatter.date(from: condition?.params.time ?? "") ?? Date()
            theCondition?.params.time = String.ss.UTCStringFromDate(date: newDate)
            addIntelligentsModel.condition = [theCondition ?? IntelligentDetailModelCondition()]
        }else {
            addIntelligentsModel.condition = [condition ?? IntelligentDetailModelCondition()]
        }
        addIntelligentsModel.actions = getAllActions(datas: datas)
        addIntelligentsModel.name = name
        SmartStore.sharedStore.addIntelligents(addIntelligentsModel:addIntelligentsModel , success: { (jsonDic) in
            StellarProgressHUD.dissmissHUD()
            let model = jsonDic.kj.model(IntelligentDetailModel.self)
            TOAST_SUCCESS(message: StellarLocalizedString("ALERT_ADD_SUCCESS"))
            self.executeIntellignt(id: model.id, compeleted: success, failure: success)
        }) { (error) in
            StellarProgressHUD.dissmissHUD()
            TOAST(message: StellarLocalizedString("ALERT_ADD_FAIL"))
            failure?()
        }
    }
    func modifyIntelligents(smartModel: IntelligentDetailModel?,name: String, condition: IntelligentDetailModelCondition?, datas: [GroupModel], success: (()-> Void)?,failure: (() ->Void)?) {
        StellarProgressHUD.showHUD()
        let changeSmartInfoModel = ChangeSmartInfoModel()
        changeSmartInfoModel.id = smartModel?.id ?? ""
        changeSmartInfoModel.name = name
        if condition?.type == .timing {
            let theCondition = condition?.kj.JSONString().kj.model(type: IntelligentDetailModelCondition.self) as? IntelligentDetailModelCondition
            let dateFamatter = DateFormatter()
            dateFamatter.dateFormat = "HH:mm"
            dateFamatter.timeZone = TimeZone.current
            dateFamatter.locale = Locale.init(identifier: TimeZone.current.identifier)
            let newDate = dateFamatter.date(from: condition?.params.time ?? "") ?? Date()
            theCondition?.params.time = String.ss.UTCStringFromDate(date: newDate)
            changeSmartInfoModel.condition = [theCondition ?? IntelligentDetailModelCondition()]
        }else {
            changeSmartInfoModel.condition = [condition ?? IntelligentDetailModelCondition()]
        }
        changeSmartInfoModel.actions = getAllActions(datas: datas)
        SmartStore.sharedStore.modifyDetailIntelligent(id: smartModel?.id ?? "", changeSmartInfoModel: changeSmartInfoModel, success: { (jsonDic) in
            StellarProgressHUD.dissmissHUD()
            TOAST_SUCCESS(message: StellarLocalizedString("ALERT_CONFIRM_SUCCESS"))
            success?()
        }) { (error) in
            StellarProgressHUD.dissmissHUD()
            TOAST(message: StellarLocalizedString("ALERT_CONFIRM_FAIL"))
            failure?()
        }
    }
    private func executeIntellignt(id: String, compeleted: (()->Void)?,failure: (() ->Void)?) {
        SmartStore.sharedStore.excuteDetailIntelligent(id: id, success: { (jsonDic) in
            let response = jsonDic.kj.model(CommonResponseModel.self)
            if response.code != 0 {
                TOAST(message: "开启智能失败，您可以手动开启")
            }
            compeleted?()
        }) { (error) in
            TOAST(message: "开启智能失败，您可以手动开启")
            compeleted?()
        }
    }
    func deletIntelligents(id: String, success: (() ->Void)?, failure: (() ->Void)?) {
        StellarProgressHUD.showHUD()
        SmartStore.sharedStore.deleteDetailIntelligent(id: id, success: { (jsonDic) in
            StellarProgressHUD.dissmissHUD()
            let model = jsonDic.kj.model(CommonResponseModel.self)
            if model.code == 0 {
                TOAST_SUCCESS(message: StellarLocalizedString("COMMON_DELETE_SUCCESS"))
                success?()
            }else {
                TOAST(message: StellarLocalizedString("COMMON_DELETE_FAIL"))
                failure?()
            }
        }) { (error) in
            StellarProgressHUD.dissmissHUD()
            TOAST(message: StellarLocalizedString("COMMON_DELETE_FAIL"))
            failure?()
        }
    }
    func disable(model: IntelligentDetailModel, success: (() ->Void)?, failure: (() ->Void)?) {
        StellarProgressHUD.showHUD()
        SmartStore.sharedStore.disableDetailIntelligent(id: model.id, success: { (jsonDic) in
            StellarProgressHUD.dissmissHUD()
            let cmmModel = jsonDic.kj.model(CommonResponseModel.self)
            if cmmModel.code == 0 {
                success?()
            }else {
                TOAST(message: StellarLocalizedString("ALERT_SHUTDOWN_COUNTDOWN_FAIL"))
                failure?()
            }
        }) { (error) in
            StellarProgressHUD.dissmissHUD()
            TOAST(message: StellarLocalizedString("ALERT_SHUTDOWN_COUNTDOWN_FAIL"))
            failure?()
        }
    }
}
extension IntelligentsViewModel:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if dataList.count > 0 {
            return dataList.count
        }
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OperationTableViewCell", for: indexPath) as! OperationTableViewCell
        cell.selectionStyle = .none
        if dataList.count == 0 {
            cell.setupViews(topString: StellarLocalizedString("ALERT_ADD_OPERATION"), bottomString: StellarLocalizedString("ALERT_EXAMPLE_LIGHT_ON"), imageName: "icon_scence_operation")
        }else {
            cell.setupViews(model: dataList[indexPath.row])
        }
        cell.delegate = self
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if myDetailType == .detailType && isOpeningTimer() {
            TOAST(message: StellarLocalizedString("ALERT_OFF_COUNTER"))
            return
        }
        if dataList.count == 0 {
            let vc = AddOperationViewController.init()
            vc.creatGroupDataModel = creatGroupDataModel
            delegate?.pushViewController(vc: vc)
        }else {
            if getDataType() == .controlDeviceType {
                showActionViewWithGroup(group: dataList[indexPath.row], hasRoomId: false)
            }else if getDataType() == .executeScenesType {
                let vc = SelectScenesViewController()
                vc.isModify = true
                vc.creatGroupDataModel = creatGroupDataModel
                vc.modifyBlock = { [weak self] (newGroup) in
                    self?.dataList = (self?.filterGroup(newGroup: newGroup)) ?? [GroupModel]()
                    self?.sendActionsChangeSingal()
                }
                delegate?.pushViewController(vc: vc)
            }else {
                showActionViewWithGroup(group: dataList[indexPath.row], hasRoomId: true)
            }
        }
    }
}
extension IntelligentsViewModel: SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        if myDetailType == .detailType && isOpeningTimer() {
            return nil
        }
        if indexPath.row != dataList.count && orientation == .right {
            let delet = SwipeAction.init(style: .default, title: StellarLocalizedString("COMMON_DELETE")) { [weak self] (_, _) in
                self?.dataList.remove(at: indexPath.row)
                self?.sendActionsChangeSingal()
                tableView.reloadData()
            }
            delet.backgroundColor = .white
            delet.font = STELLAR_FONT_BOLD_T15
            return [delet]
        }
        return nil
    }
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
        var options = SwipeTableOptions()
        options.minimumButtonWidth = 100
        options.maximumButtonWidth = 100
        return options
    }
}