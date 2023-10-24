import UIKit
class CreatScenesViewModel: AddOpreationViewModel {
    func isDataCanSave(title: String?, data: [GroupModel]?) -> Bool {
        if !(title?.isEmpty ?? false) && !(data?.isEmpty ?? false) && title != StellarLocalizedString("SCENE_DEFAULT_TITLE") {
            return true
        }
        return false
    }
    override func filterGroup(newGroup: GroupModel) -> [GroupModel] {
        if dataList.count == 0 {
            dataList.append(newGroup)
            return dataList
        }
        if getNewGroupControlType(newGroup: newGroup) == .controlDeviceType {
            return filterControlDevice(newGroup: newGroup)
        }
        return filterControlRoom(newGroup: newGroup)
    }
    override func getNewGroupControlType(newGroup: GroupModel) -> DataType {
        guard let execution = newGroup.executions.first else {
            return .emptyType
        }
        if execution.room != nil {
            return .controlRoomType
        }else if execution.device != nil {
            return .controlDeviceType
        }
        return .emptyType
    }
    func getIdWithImageName(name: String) -> Int {
        if name == "scence_4" {
            return 4
        }else if name == "scence_3" {
            return 3
        }else if name == "scence_2" {
            return 2
        }
        return 1
    }
    func getImageNameWithId(backImageId: Int) -> String {
        return "scence_\(backImageId)"
    }
    override var creatGroupDataModel: CreatGroupDataModel {
        get {
            let model = super.creatGroupDataModel
            model.myDataType = getDataType()
            model.sourceVc = .creatScense
            return model
        }
    }
}
extension CreatScenesViewModel :UITableViewDelegate,UITableViewDataSource{
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
        if dataList.count == 0 {
            let vc = AddOperationViewController()
            vc.creatGroupDataModel = creatGroupDataModel
            delegate?.pushViewController(vc: vc)
        }else {
            let group = dataList[indexPath.row]
            if group.executions.first?.room != nil {
                showActionViewWithGroup(group: group, hasRoomId: true)
            }else {
                showActionViewWithGroup(group: group, hasRoomId: false)
            }
        }
    }
}
extension CreatScenesViewModel: SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        if indexPath.row != dataList.count&&orientation == .right {
            let delet = SwipeAction.init(style: .default, title: StellarLocalizedString("SMART_DELET")) { [weak self] (_, _) in
                self?.dataList = (self?.removeAt(index: indexPath.row)) ?? [GroupModel]()
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