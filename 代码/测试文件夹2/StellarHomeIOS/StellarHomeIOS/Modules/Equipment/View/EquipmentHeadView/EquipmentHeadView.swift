import UIKit
enum HeadViewStyle{
    case upStyle
    case downStyle
}
class EquipmentHeadView: UIView {
    let disposeBag = DisposeBag()
    var style: HeadViewStyle = .downStyle
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadSubViews()
    }
    var popPowerSwitchBlock:(()->Void)?
    var popAddBlock:(()->Void)?
    private func loadSubViews(){
        addSubview(bottomViewBG)
        bottomViewBG.snp.makeConstraints {
            $0.left.equalTo(0)
            $0.right.equalTo(0)
            $0.bottom.top.equalTo(0)
        }
        addSubview(bottomView)
        bottomView.snp.makeConstraints {
            $0.left.equalTo(0)
            $0.right.equalTo(0)
            $0.bottom.equalTo(-7)
            $0.height.equalTo(30.fit)
        }
        addSubview(topView)
        topView.snp.makeConstraints {
            $0.left.top.right.equalTo(self)
            $0.bottom.equalTo(bottomView.snp.top)
        }
        topView.addSubview(leftButton)
        leftButton.snp.makeConstraints {
            $0.left.equalTo(11)
            $0.centerY.equalTo(self)
            $0.height.equalTo(32)
        }
        topView.addSubview(rightButton)
        rightButton.snp.makeConstraints {
            $0.right.equalTo(-20)
            $0.centerY.equalTo(leftButton)
            $0.height.equalTo(30)
            $0.width.equalTo(30)
        }
    }
    func setHeadViewClick(leftClickBlock:(()->Void)?,rightClickBlock:(()->Void)?){
        popPowerSwitchBlock = {
            leftClickBlock?()
        }
        popAddBlock = {
           rightClickBlock?()
        }
    }
    func setRoomsTitles(_ title:String){
        let titleString = " " + title
        leftButton.setTitle(titleString, for: .normal)
        let buttonRect = String.ss.getTextRectSize(text: titleString,font: STELLAR_FONT_T13,size: CGSize.init(width: CGFloat.greatestFiniteMagnitude, height: 32.fit))
        let width = buttonRect.size.width + 13 + 6 + 20
        leftButton.snp.remakeConstraints {
            $0.left.equalTo(11)
            $0.centerY.equalTo(self)
            $0.height.equalTo(32)
            $0.width.equalTo(width)
        }
    }
    func setDownStyle(alpha:CGFloat){
        if bottomView.style == .upStyle {
            layer.shadowColor = UIColor.clear.cgColor
            layer.shadowOpacity = 0
            layer.shadowRadius = 0
            layer.shadowOffset = CGSize.init(width: 0, height: 0)
        }
        bottomViewBG.alpha = 0
        topView.alpha = alpha
        bottomView.style = .downStyle
    }
    func setUpStyle(){
        if bottomView.style == .downStyle {
            layer.shadowColor = UIColor.black.cgColor
            layer.shadowOpacity = 0.2
            layer.shadowRadius = 10
            layer.shadowOffset = CGSize.zero
        }
        bottomViewBG.alpha = 1
        bottomView.style = .upStyle
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    lazy var leftButton:UIButton = {
        let button = UIButton.init(type: .custom)
        button.setImage(UIImage.init(named: "lamp_black"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: -6, bottom: 0, right: 0)
        button.titleLabel?.font = STELLAR_FONT_BOLD_T13
        button.setTitleColor(STELLAR_COLOR_C5, for: .normal)
        button.backgroundColor = STELLAR_COLOR_C3
        button.layer.cornerRadius = 16;
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(leftClick), for: .touchUpInside)
        return button
    }()
    @objc func leftClick(){
        popPowerSwitchBlock?()
    }
    @objc func rightClick(){
        popAddBlock?()
    }
    lazy var rightButton:UIButton = {
        let button = UIButton.init(type: .custom)
        button.setImage(UIImage.init(named: "icon_add_big"), for: .normal)
        button.layer.cornerRadius = 15;
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(rightClick), for: .touchUpInside)
        return button
    }()
    lazy var bottomView:TitleScrollView = {
        let view = TitleScrollView()
        view.titles = ["全部"]
        return view
    }()
    lazy var bottomViewBG:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.alpha = 0
        return view
    }()
    lazy var topView:UIView = {
        let view = UIView()
        return view
    }()
}