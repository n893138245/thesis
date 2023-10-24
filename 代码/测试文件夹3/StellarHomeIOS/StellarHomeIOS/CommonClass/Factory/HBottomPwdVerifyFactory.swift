import UIKit
class HBottomPwdVerifyFactory: HBottomSelectionBaseFactory {
    private var tableViewDataArr = [TableViewSectionModel]()
    var verifySuccessBlock: (() ->Void)?
    override func getSectionModelData() -> [TableViewSectionModel] {
        let sectionModel = getSectionModel()
        let verificationCellModel = CellModel()
        verificationCellModel.cellHeight = {table,index in
            return 220
        }
        verificationCellModel.cell = { [weak self] table,index in
            let cell = PwdVerifyCell.initWithXIb() as! PwdVerifyCell
            cell.selectionStyle = .none
            cell.verifyBlock = { [weak cell] in
                StellarProgressHUD.showHUD()
                cell?.bottomButton.startIndicator()
                let request = LoginRequestModel()
                let password = cell?.pwdTextField.textField.text ?? ""
                request.password = password.sha256()
                StellarUserStore.sharedStore.checkIdentify(loginRequestModel: request, success: { (jsonDic) in
                    StellarProgressHUD.dissmissHUD()
                    cell?.bottomButton.stopIndicator()
                    guard let model = jsonDic.kj.model(type: CommonResponseModel.self) as? CommonResponseModel else {
                        TOAST(message: StellarLocalizedString("MINE_CHANGEPHONE_PWD_ERROR"))
                        return
                    }
                    if !model.accessCode.isEmpty { 
                        FeedBackTimeTool.sharedTool.saveCurrentVerificationTime(accessCode: model.accessCode)
                        self?.verifySuccessBlock?()
                    }else {
                        TOAST(message: StellarLocalizedString("MINE_CHANGEPHONE_PWD_ERROR"))
                    }
                }) { (error) in
                    cell?.bottomButton.stopIndicator()
                    StellarProgressHUD.dissmissHUD()
                    TOAST(message: StellarLocalizedString("MINE_CHANGEPHONE_PWD_ERROR")) 
                }
            }
            return cell
        }
        sectionModel.cellModelsArr.append(verificationCellModel)
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