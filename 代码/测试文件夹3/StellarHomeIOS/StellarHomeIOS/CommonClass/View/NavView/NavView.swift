import UIKit
enum NavStyle {
    case kNavInit
    case kNavBlack
    case kNavWhite
}
class NavView: UIView {
    let disposeBag = DisposeBag()
    var myState:NavStyle = .kNavInit{
        didSet{
            if oldValue ==  myState{
                return
            }
            setupViews(state:myState)
        }
    }
    var backclickBlock:(()->Void)? = nil
    var titleClickBlock:((String)->Void)? = nil
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadSubView()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func loadSubView(){
        addSubview(backButton)
        backButton.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.width.equalTo(44)
            make.height.equalTo(44)
            make.centerY.equalTo(self.snp.bottom).offset(-21)
        }
        addSubview(titleBtn)
        titleBtn.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.centerY.equalTo(backButton)
            make.left.equalTo(self).offset(50.fit)
            make.right.equalTo(self).offset(-50.fit)
        }
        titleBtn.adjustsImageWhenHighlighted = false
        backButton.rx.tap.subscribe(onNext: { [weak self] (_) in
            if self?.backclickBlock != nil{
                self?.backclickBlock!()
            }
        }).disposed(by: disposeBag)
        titleBtn.rx.tap.subscribe(onNext: { [weak self] (_) in
            if self?.titleClickBlock != nil{
                self?.titleClickBlock!(self?.titleBtn.titleLabel?.text ?? "")
            }
        }).disposed(by: disposeBag)
    }
    func setTitle(title:String,imageName:String = ""){
        titleBtn.setTitle(title, for: .normal)
        let MAX_TEXT_WIDTH = kScreenWidth - 110
        if imageName != "" {
            titleBtn.setImage(UIImage.init(named: imageName), for: .normal)
            let buttonRect = String.ss.getTextRectSize(text: title,font: STELLAR_FONT_BOLD_T18,size: CGSize.init(width: CGFloat.greatestFiniteMagnitude, height: 22))
            if buttonRect.size.width > MAX_TEXT_WIDTH {
                titleBtn.snp.remakeConstraints { (make) in
                    make.centerY.equalTo(backButton)
                    make.left.equalTo(self).offset(50)
                    make.right.equalTo(self).offset(-50)
                }
            }else {
                titleBtn.snp.remakeConstraints { (make) in
                    make.centerX.equalTo(self)
                    make.centerY.equalTo(backButton)
                    make.width.equalTo(buttonRect.size.width+26)
                }
            }
        }
    }
    func setupViews(state:NavStyle){
        switch state {
        case .kNavInit:
            break
        case .kNavWhite:
            backButton.setImage(UIImage.init(named: "bar_icon_white"), for: .normal)
            titleBtn.setTitleColor(STELLAR_COLOR_C3, for: .normal)
            break
        case .kNavBlack:
            backButton.setImage(UIImage.init(named: "bar_icon_back"), for: .normal)
            titleBtn.setTitleColor(STELLAR_COLOR_C4, for: .normal)
            break
        }
    }
    lazy var titleBtn:NavViewTitleImageButton = {
        let btn = NavViewTitleImageButton.init()
        btn.adjustsImageWhenHighlighted = false
        btn.setTitleColor(STELLAR_COLOR_C3, for: .normal)
        btn.titleLabel?.font = STELLAR_FONT_BOLD_T18
        return btn
    }()
    lazy var backButton:UIButton = {
        let btn = UIButton()
        btn.setTitleColor(STELLAR_COLOR_C3, for: .normal)
        btn.titleLabel!.font = STELLAR_FONT_BOLD_T18
        btn.setImage(UIImage.init(named: "bar_icon_white"), for: .normal)
        return btn
    }()
}