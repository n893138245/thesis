import UIKit
class HBottomCodeVerifyFactory: HBottomSelectionBaseFactory {
    private var tableViewDataArr = [TableViewSectionModel]()
    var verifySuccessBlock: (() ->Void)?
    var verifyType: UserVerifyType = .emailCode
    var actionChangeBlock:((_ actionType: ActionTriats) -> Void)?
    override func getSectionModelData() -> [TableViewSectionModel] {
        let sectionModel = getSectionModel()
        let verificationCellModel = CellModel()
        verificationCellModel.cellHeight = { table,index in
            return 200
        }
        verificationCellModel.cell = { [weak self] table,index in
            let cell = CodeVerifyCell.initWithXIb() as! CodeVerifyCell
            cell.selectionStyle = .none
            if self?.verifyType == .emailCode {
                cell.mTitleLabel.text = "\(StellarLocalizedString("MINE_CHANGEPHONE_SEND_TO")) \(StellarAppManager.sharedManager.user.userInfo.email)"
            }else {
                var cellPhone = StellarAppManager.sharedManager.user.userInfo.cellphone
                if cellPhone.contains("-") {
                    cellPhone = cellPhone.replacingOccurrences(of: "-", with: " ")
                }
                cell.mTitleLabel.text = "\(StellarLocalizedString("MINE_CHANGEPHONE_SEND_TO")) \(cellPhone)"
            }
            cell.verificateCodeBlock = { [weak cell] in 
                self?.checkCode(cell: cell ?? CodeVerifyCell())
            }
            cell.reSendCodeBlock = {
                self?.getCode(type: self?.verifyType ?? UserVerifyType.phoneCode, cell: cell)
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
    private func checkFailure(cell : CodeVerifyCell) {
        TOAST(message: StellarLocalizedString("MINE_CHANGEPHONE_CODE_ERROR")) { 
            cell.clear()
        }
    }
    private func checkCode(cell :CodeVerifyCell) {
        StellarProgressHUD.showHUD()
        let request = LoginRequestModel()
        if verifyType == .phoneCode {
            request.cellphone = StellarAppManager.sharedManager.user.userInfo.cellphone
        }else {
            request.email = StellarAppManager.sharedManager.user.userInfo.email
        }
        request.smscode = cell.sendCodeView.getTextString()
        StellarUserStore.sharedStore.checkIdentify(loginRequestModel: request, success: { [weak self] (jsonDic) in
            StellarProgressHUD.dissmissHUD()
            guard let model = jsonDic.kj.model(type: CommonResponseModel.self) as? CommonResponseModel else {
                self?.checkFailure(cell: cell)
                return
            }
            if !model.accessCode.isEmpty {
                FeedBackTimeTool.sharedTool.saveCurrentVerificationTime(accessCode: model.accessCode) 
                self?.verifySuccessBlock?() 
            }else {
                self?.checkFailure(cell: cell)
            }
        }) { [weak self] (error) in
            StellarProgressHUD.dissmissHUD()
            self?.checkFailure(cell: cell)
        }
    }
    private func getCode(type: UserVerifyType,cell: CodeVerifyCell) {
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
            TOAST(message: StellarLocalizedString("MINE_CHANGEPHONE_SEND_SUCCESS"))
            cell.clear()
            cell.reStartTimer()
        }) { (error) in
            StellarProgressHUD.dissmissHUD()
            TOAST(message: error)
        }
    }
}