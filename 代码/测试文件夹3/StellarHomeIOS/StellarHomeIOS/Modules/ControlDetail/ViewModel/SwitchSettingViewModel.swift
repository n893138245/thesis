import UIKit
class SwitchSettingViewModel: AddOpreationViewModel {
    func getFingerCenterAndPanelImage(switchIndex: Int,switcthType: SwitchKeyType) -> (panelImage: UIImage, fingerCenter: CGPoint) {
        var image = UIImage()
        var center = CGPoint.zero
        let width = 100.fit
        let fingerHalfW:CGFloat = 20
        let fingerHalfH:CGFloat = 37/2.0
        switch switcthType {
        case .keyTypeOne:
            image = UIImage(named: "switch_1") ?? UIImage()
            center = CGPoint(x: width/2+fingerHalfW, y: width/2+fingerHalfH)
        case .keyTypeTwo:
            image = UIImage(named: "switch_2") ?? UIImage()
            if switchIndex == 0 {
                center = CGPoint(x: width/4+fingerHalfW, y: width/4*3.0+fingerHalfH)
            }else {
                center = CGPoint(x: width/4*3.0+fingerHalfW, y: width/4*3.0+fingerHalfH)
            }
        case .keyTypeThree:
            image = UIImage(named: "switch_3") ?? UIImage()
            if switchIndex == 0 {
                center = CGPoint(x: width/6+fingerHalfW, y: width/4*3.0+fingerHalfH)
            }else if switchIndex == 1 {
                center = CGPoint(x: width/6*3.0+fingerHalfW, y: width/4*3.0+fingerHalfH)
            }else {
                center = CGPoint(x: width/6*5.0+fingerHalfW, y: width/4*3.0+fingerHalfH)
            }
        case .keyTypeFour:
            image = UIImage(named: "switch_4") ?? UIImage()
            if switchIndex == 0 { 
                center = CGPoint(x: width/4+fingerHalfW, y: width/4*3+fingerHalfH)
            }else if switchIndex == 1 { 
                center = CGPoint(x: width/4+fingerHalfW, y: width/4+fingerHalfH)
            }else if switchIndex == 2 { 
                center = CGPoint(x: width/4*3+fingerHalfW, y: width/4+fingerHalfH)
            }else {
                center = CGPoint(x: width/4*3+fingerHalfW, y: width/4*3+fingerHalfH)
            }
        }
        return (image,center)
    }
}
extension SwitchSettingViewModel :UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !dataList.isEmpty {
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
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if dataList.count == 0 {
            return false
        }
        return true
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if dataList.count == 0 {
            let vc = AddOperationViewController.init()
            vc.creatGroupDataModel = creatGroupDataModel
            delegate?.pushViewController(vc: vc)
        }else {
            if getDataType() == .controlDeviceType {
                let group = dataList[indexPath.row]
                showActionViewWithGroup(group: group, hasRoomId: false)
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
                let group = dataList[indexPath.row]
                showActionViewWithGroup(group: group, hasRoomId: true)
            }
        }
    }
}
extension SwitchSettingViewModel: SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        if indexPath.row != dataList.count&&orientation == .right {
            let delet = SwipeAction.init(style: .default, title: "删除") { [weak self] (_, _) in
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