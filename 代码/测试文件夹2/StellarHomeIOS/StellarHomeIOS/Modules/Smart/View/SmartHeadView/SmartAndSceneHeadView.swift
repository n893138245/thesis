import UIKit
class SmartAndSceneHeadView: UIView {
    var leftClickBlock:(()->Void)? = nil
    var rightClickBlock:(()->Void)? = nil
    var addClickBlock:((_ isDefault:Bool)->Void)? = nil
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadSubViews()
    }
    func setTitles(leftTitle:String,rightTitle:String)
    {
        leftBtn.setTitle(leftTitle, for: .normal)
        rightBtn.setTitle(rightTitle, for: .normal)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func loadSubViews(){
        addSubview(leftBtn)
        leftBtn.snp.makeConstraints {
            $0.right.equalTo(self.snp.centerX).offset(-10.fit)
            $0.centerY.equalTo(self.snp.centerY)
        }
        addSubview(rightBtn)
        rightBtn.snp.makeConstraints {
            $0.left.equalTo(self.snp.centerX).offset(10.fit)
            $0.centerY.equalTo(self.snp.centerY)
        }
        addSubview(lineView)
        lineView.snp.makeConstraints {
            $0.centerX.equalTo(leftBtn.snp.centerX)
            $0.top.equalTo(leftBtn.snp.bottom).offset(2.fit)
            $0.width.equalTo(leftBtn.snp.width)
            $0.height.equalTo(3.fit)
        }
        addSubview(addBtn)
        addBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(rightBtn)
            make.right.equalTo(-20.fit)
            make.width.height.equalTo(30.fit)
        }
    }
    func switchDefaultState(){
        if leftBtn.isSelected == true {
            return
        }
        leftBtn.isSelected = true
        rightBtn.isSelected = false
        lineView.snp.remakeConstraints {
            $0.centerX.equalTo(leftBtn.snp.centerX)
            $0.top.equalTo(leftBtn.snp.bottom).offset(2.fit)
            $0.width.equalTo(leftBtn.snp.width)
            $0.height.equalTo(3.fit)
        }
        UIView.animate(withDuration: 0.25) {
            self.layoutIfNeeded()
        }
    }
    func switchCustomState(){
        if rightBtn.isSelected == true {
            return
        }
        leftBtn.isSelected = false
        rightBtn.isSelected = true
        lineView.snp.remakeConstraints {
            $0.centerX.equalTo(rightBtn.snp.centerX)
            $0.top.equalTo(leftBtn.snp.bottom).offset(2.fit)
            $0.width.equalTo(rightBtn.snp.width)
            $0.height.equalTo(3.fit)
        }
        UIView.animate(withDuration: 0.25) {
            self.layoutIfNeeded()
        }
    }
    lazy var leftBtn:UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setTitleColor(STELLAR_COLOR_C6, for: .normal)
        btn.setTitleColor(STELLAR_COLOR_C1, for: .selected)
        btn.titleLabel?.font = STELLAR_FONT_BOLD_T17
        btn.setTitle("默认智能", for: .normal)
        btn.isSelected = true
        btn.addTarget(self, action: #selector(leftAction), for: .touchUpInside)
        return btn
    }()
    lazy var rightBtn:UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setTitleColor(STELLAR_COLOR_C6, for: .normal)
        btn.setTitleColor(STELLAR_COLOR_C1, for: .selected)
        btn.titleLabel?.font = STELLAR_FONT_BOLD_T17
        btn.setTitle(StellarLocalizedString("SCENE_CUSTOM"), for: .normal)
        btn.addTarget(self, action: #selector(rightAction), for: .touchUpInside)
        return btn
    }()
    lazy var lineView:UIView = {
        let line = UIView()
        line.backgroundColor = STELLAR_COLOR_C1
        return line
    }()
    lazy var addBtn:UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setImage(UIImage.init(named: "icon_add_scene"), for: .normal)
        btn.addTarget(self, action: #selector(addAction), for: .touchUpInside)
        return btn
    }()
    @objc func leftAction(){
        if leftClickBlock != nil {
            leftClickBlock!()
        }
    }
    @objc func rightAction(){
        if rightClickBlock != nil {
            rightClickBlock!()
        }
    }
    @objc func addAction(){
        if addClickBlock != nil {
            if leftBtn.isSelected {
                addClickBlock!(true)
            }
            else{
                addClickBlock!(false)
            }
        }
    }
}