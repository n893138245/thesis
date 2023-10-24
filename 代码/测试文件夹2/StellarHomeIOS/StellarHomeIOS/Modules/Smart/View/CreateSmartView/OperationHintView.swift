import UIKit
class OperationHintView: UIView {
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadSubView()
    }
    func loadSubView(){
        addSubview(operationLeftLabel)
        operationLeftLabel.snp.makeConstraints { (make) in
            make.left.equalTo(20.fit)
            make.top.equalTo(0)
        }
        addSubview(operationRightBtn)
        var buttonWidth = 90.fit
        if !isChinese() {
            buttonWidth = 120
        }
        operationRightBtn.snp.makeConstraints { (make) in
            make.right.equalTo(-20.fit)
            make.centerY.equalTo(operationLeftLabel.snp.centerY)
            make.width.equalTo(buttonWidth)
            make.height.equalTo(self)
        }
    }
    lazy var operationLeftLabel:UILabel = {
        let lab = UILabel()
        lab.text = StellarLocalizedString("SMART_EXE_AN_OPREATION")
        lab.textColor = STELLAR_COLOR_C4
        lab.font = STELLAR_FONT_BOLD_T16
        return lab
    }()
    lazy var operationRightBtn:UIButton = {
        let btn = UIButton()
        btn.setTitle(StellarLocalizedString("ALERT_ADD_OPERATION"), for: .normal)
        btn.setImage(UIImage.init(named: "icon_add_blue"), for: .normal)
        btn.setTitleColor(STELLAR_COLOR_C1, for: .normal)
        btn.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: -5, bottom: 0, right: 0)
        btn.titleLabel?.font = STELLAR_FONT_BOLD_T14
        return btn
    }()
    deinit {
    }
}