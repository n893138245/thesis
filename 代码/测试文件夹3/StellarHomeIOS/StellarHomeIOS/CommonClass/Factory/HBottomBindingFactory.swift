import UIKit
class HBottomBindingFactory: HBottomSelectionBaseFactory {
    private var tableViewDataArr = [TableViewSectionModel]()
    var actions: [UserBindType] = [.bindPhone,.bindEmail]
    var clickBlock:((_ bindType: UserBindType)-> Void)?
    override func getSectionModelData() -> [TableViewSectionModel] {
        let sectionModel = getSectionModel()
        let textCellModel = CellModel()
        textCellModel.cellHeight = { table, index in
            return 70
        }
        textCellModel.cell = { table, index in
            let cell = SafetyVerficationTipCell.initWithXIb() as! SafetyVerficationTipCell
            cell.mTipLabel.text = "为了保障您的账号安全，请选择下方一种方式完成绑定"
            cell.selectionStyle = .none
            return cell
        }
        sectionModel.cellModelsArr.append(textCellModel)
        for type in self.actions {
            let bindingCellModel = CellModel()
            bindingCellModel.cellHeight = { table,index in
                return 75
            }
            bindingCellModel.cell = { table,index in
                let cell = VerificationModeCell.initWithXIb() as! VerificationModeCell
                cell.selectionStyle = .default
                switch type {
                case .bindPhone:
                    cell.iconImage.image = UIImage(named: "icon_login_phone")
                    cell.mTitleLabel.text = "绑定手机号"
                case .bindEmail:
                    cell.iconImage.image = UIImage(named: "icon_login_email")
                    cell.mTitleLabel.text = "绑定邮箱"
                default:
                    break
                }
                return cell
            }
            bindingCellModel.selectRow = { [weak self] tableview, indexPath in
                guard let cell = tableview.cellForRow(at: indexPath) as? VerificationModeCell else { return }
                var type: UserBindType = .changePhone
                switch cell.mTitleLabel.text {
                case "绑定手机号":
                    type = .bindPhone
                case "绑定邮箱":
                    type = .bindEmail
                default:
                    break
                }
                self?.clickBlock?(type)
            }
            sectionModel.cellModelsArr.append(bindingCellModel)
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
}