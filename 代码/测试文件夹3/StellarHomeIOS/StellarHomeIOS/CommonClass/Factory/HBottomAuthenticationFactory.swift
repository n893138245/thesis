import UIKit
enum UserVerifyType {
    case phoneCode,emailCode,password
}
class HBottomAuthenticationFactory: HBottomSelectionBaseFactory {
    private var tableViewDataArr = [TableViewSectionModel]()
    var actions:[UserVerifyType] = [.phoneCode,.password,.emailCode]
    var clickBlock:((_ verifyType: UserVerifyType) -> Void)?
    override func getSectionModelData() -> [TableViewSectionModel] {
        let sectionModel = getSectionModel()
        let tipCellModel = CellModel()
        tipCellModel.cellHeight = { table, index in
            if isChinese() {
                return 70
            }
            return 85
        }
        tipCellModel.cell = { table, index in
            let cell = SafetyVerficationTipCell.initWithXIb() as! SafetyVerficationTipCell
            cell.selectionStyle = .none
            return cell
        }
        sectionModel.cellModelsArr.append(tipCellModel)
        if StellarAppManager.sharedManager.user.userInfo.email.isEmpty {
            actions.removeAll(where: {$0 == .emailCode})
        }else if StellarAppManager.sharedManager.user.userInfo.cellphone.isEmpty {
            actions.removeAll(where: {$0 == .phoneCode})
        }
        let actionArr = getActionArr()
        for title in actionArr {
            let verificationCellModel = CellModel()
            verificationCellModel.cellHeight = {table,index in
                return 75
            }
            verificationCellModel.cell = {table,index in
                let cell = VerificationModeCell.initWithXIb() as! VerificationModeCell
                cell.selectionStyle = .default
                cell.mTitleLabel.text = title
                switch title {
                case StellarLocalizedString("MINE_SECURITY_CODE_VRIFY"):
                    cell.iconImage.image = UIImage(named: "icon_login_phone")
                case StellarLocalizedString("MINE_SECURITY_PWD_VERIFY"):
                    cell.iconImage.image = UIImage(named: "icon_login_password")
                case StellarLocalizedString("MINE_SECURITY_EMAIL_VERIFY"):
                    cell.iconImage.image = UIImage(named: "icon_login_email")
                default:
                    break
                }
                return cell
            }
            verificationCellModel.selectRow = { [weak self] tableview, indexPath in
                if let cell = tableview.cellForRow(at: indexPath) as? VerificationModeCell {
                    var type: UserVerifyType = .password
                    switch cell.mTitleLabel.text {
                    case StellarLocalizedString("MINE_SECURITY_CODE_VRIFY"): 
                        type = .phoneCode
                        self?.getCode(type: type)
                    case StellarLocalizedString("MINE_SECURITY_PWD_VERIFY"):
                        type = .password
                        self?.clickBlock?(type) 
                    case StellarLocalizedString("MINE_SECURITY_EMAIL_VERIFY"):
                        type = .emailCode
                        self?.getCode(type: type)
                    default:
                        break
                    }
                }
            }
            sectionModel.cellModelsArr.append(verificationCellModel)
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
            case .phoneCode:
                actionList.append(StellarLocalizedString("MINE_SECURITY_CODE_VRIFY"))
            case .password:
                actionList.append(StellarLocalizedString("MINE_SECURITY_PWD_VERIFY"))
            case .emailCode:
                actionList.append(StellarLocalizedString("MINE_SECURITY_EMAIL_VERIFY"))
            }
        }
        return actionList
    }
    private func getCode(type: UserVerifyType) {
        StellarProgressHUD.showHUD()
        let sendCodeModel = SendCodeModel()
        sendCodeModel.codeUsage = CodeUsage.check_identify
        if type == .phoneCode {
            sendCodeModel.cellphone = StellarAppManager.sharedManager.user.userInfo.cellphone
        }else {
            sendCodeModel.email = StellarAppManager.sharedManager.user.userInfo.email
        }
        StellarUserStore.sharedStore.sendCode(sendCodeModel: sendCodeModel, success: {jsonDic in
            StellarProgressHUD.dissmissHUD()
            self.clickBlock?(type)
        }) { (error) in
            StellarProgressHUD.dissmissHUD()
            error.isEmpty ? TOAST(message: StellarLocalizedString("MINE_SECURITY_CODEFAIL")):TOAST(message: error)
        }
    }
}