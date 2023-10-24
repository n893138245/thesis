import UIKit
enum ActionTriats {
    case on,off,autoOnOff,color,brightness
}
class HBottomSelectionDetailLightsFactory: HBottomSelectionBaseFactory {
    private var tableViewDataArr = [TableViewSectionModel]()
    var devices = [BasicDeviceModel]()
    var actions = [ActionTriats]()
    var actionChangeBlock:((_ actionType: ActionTriats) -> Void)?
    override func getSectionModelData() -> [TableViewSectionModel] {
        let sectionModel = getSectionModel()
        if devices.isEmpty { 
            let noDeviceCellmodel = CellModel()
            noDeviceCellmodel.cellHeight = {table,index in
                return 120
            }
            noDeviceCellmodel.cell = {table,index in
                let cell = RoomNoDeviceCell.initWithXIb() as! RoomNoDeviceCell
                cell.selectionStyle = .none
                return cell
            }
            sectionModel.cellModelsArr.append(noDeviceCellmodel)
        }else { 
            let lampCellmodel = CellModel()
            lampCellmodel.cellHeight = {table,index in
                return 120
            }
            lampCellmodel.cell = {table,index in
                let cell = SelectLampsCell.initWithXIb() as! SelectLampsCell
                cell.devices = self.devices
                return cell
            }
            sectionModel.cellModelsArr.append(lampCellmodel)
        }
        let spaceCellmodel = CellModel()
        spaceCellmodel.cellHeight = {table,index in
            return 2
        }
        spaceCellmodel.cell = {table,index in
            let cell = UITableViewCell()
            cell.backgroundColor = UIColor.init(red: 243/255.0, green: 244/255.0, blue: 249/255.0, alpha: 1)
            return cell
        }
        sectionModel.cellModelsArr.append(spaceCellmodel)
        let actionTipCellModel = CellModel()
        actionTipCellModel.cellHeight = {table,index in
            return 49
        }
        actionTipCellModel.cell = {table,index in
            let cell = LeftTipTableViewCell.initWithXIb() as! LeftTipTableViewCell
            cell.setview(imageName: "icon_popup", title: StellarLocalizedString("SMART_SELECT_OPREATION"))
            cell.leftLabel.textColor = STELLAR_COLOR_C1
            cell.leftLabel.font = STELLAR_FONT_T12
            cell.selectionStyle = .none
            return cell
        }
        sectionModel.cellModelsArr.append(actionTipCellModel)
        let actionArr = getActionArr()
        for title in actionArr {
            let actionTitleCellModel = CellModel()
            actionTitleCellModel.cellHeight = {table,index in
                return 58
            }
            actionTitleCellModel.cell = {table,index in
                let cell = LeftTwoLabelTableViewCell.initWithXIb() as! LeftTwoLabelTableViewCell
                cell.selectionStyle = .default
                if title == StellarLocalizedString("SMART_AUTOONOFF") {
                    cell.setview(firstTitle: title, secondTitle: StellarLocalizedString("SMART_AUTOONOFF_DES"),rightImageName: "icon_gray_right_arrow")
                }else{
                    cell.setview(firstTitle: title, secondTitle: "",rightImageName: "icon_gray_right_arrow")
                }
                if self.devices.isEmpty {
                    cell.firstLabel.textColor = STELLAR_COLOR_C7
                    cell.selectionStyle = .none
                }else {
                    cell.firstLabel.textColor = STELLAR_COLOR_C4
                }
                cell.firstLabel.font = STELLAR_FONT_T16
                cell.secondLabel.textColor = STELLAR_COLOR_C6
                cell.secondLabel.font = STELLAR_FONT_T13
                return cell
            }
            actionTitleCellModel.selectRow = { [weak self] tableview, indexPath in
                if self?.devices.isEmpty ?? true {
                    TOAST(message: StellarLocalizedString("SCENE_ROOM_EMPTY_DEVICE"))
                    return
                }
                var actionType: ActionTriats = .on
                if let cell = tableview.cellForRow(at: indexPath) as? LeftTwoLabelTableViewCell {
                    switch cell.firstLabel.text {
                    case StellarLocalizedString("SMART_TRUN_ON"):
                        actionType = .on
                    case StellarLocalizedString("SMART_TRUN_OFF"):
                        actionType = .off
                    case StellarLocalizedString("SMART_AUTOONOFF"):
                        actionType = .autoOnOff
                    case StellarLocalizedString("SMART_MODIFY_BRIGHTNESS"):
                        actionType = .brightness
                    case StellarLocalizedString("SMART_MODIFY_COLOR"):
                        actionType = .color
                    default:
                        break
                    }
                    self?.actionChangeBlock?(actionType)
                }
            }
            sectionModel.cellModelsArr.append(actionTitleCellModel)
        }
        return tableViewDataArr
    }
    private func getSectionModel() -> TableViewSectionModel{
        var sectionModel = tableViewDataArr.first
        if sectionModel == nil {
            sectionModel = TableViewSectionModel()
            tableViewDataArr.append(sectionModel!)
        }
        return sectionModel!
    }
    private func getActionArr() -> [String] {
        var actionList = [String]()
        for action in self.actions {
            switch action {
            case .on:
                actionList.append(StellarLocalizedString("SMART_TRUN_ON"))
            case .off:
                actionList.append(StellarLocalizedString("SMART_TRUN_OFF"))
            case .autoOnOff:
                actionList.append(StellarLocalizedString("SMART_AUTOONOFF"))
            case .brightness:
                actionList.append(StellarLocalizedString("SMART_MODIFY_BRIGHTNESS"))
            case .color:
                actionList.append(StellarLocalizedString("SMART_MODIFY_COLOR"))
            }
        }
        return actionList
    }
}