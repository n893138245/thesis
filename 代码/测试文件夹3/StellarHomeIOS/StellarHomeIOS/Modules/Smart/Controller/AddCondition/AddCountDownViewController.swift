import UIKit
class AddCountDownViewController: BaseViewController {
    var condition:IntelligentDetailModelCondition?
    override func viewDidLoad() {
        super.viewDidLoad()
        loadSubViews()
        if condition == nil {
            condition = IntelligentDetailModelCondition()
            condition?.type = .countdown
            condition?.params.countdownTime = 15*60
        }
        var time = (condition?.params.countdownTime)!/60
        if time == 0 {
            time = 15
        }
        nDatePicker.pickerView.selectRow(time-1, inComponent: 0, animated: true)
    }
    func loadSubViews(){
        navView.backclickBlock = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        view.addSubview(navView)
        navView.snp.makeConstraints { (make) in
            make.top.equalTo(getAllVersionSafeAreaTopHeight())
            make.left.right.equalTo(0)
            make.height.equalTo(44.fit)
        }
        view.addSubview(bottomBtn)
        bottomBtn.frame = CGRect.init(x: kScreenWidth/2.0 - 146.fit, y: kScreenHeight - BOTTOMBUTTON_BOTTOM_CONSTRAINT, width: 290.fit , height: 46.fit)
        bottomBtn.rx.tap.subscribe(onNext:{ [weak self] (_) in
            for vc in self?.navigationController?.children ?? []{
                if vc is CreateSmartViewController{
                    guard let conditionVc = vc as? CreateSmartViewController else{
                        return
                    }
                    let pCondition = IntelligentDetailModelCondition()
                    pCondition.params.countdownTime = (self?.nDatePicker.minNum)! * 60
                    pCondition.type = .countdown
                    pCondition.params.weekdays = nil
                    NotificationCenter.default.post(name: .Smart_SetConditionsComplete, object: nil, userInfo: ["info":pCondition])
                    self?.navigationController?.popToViewController(conditionVc, animated: true)
                    break
                }
            }
        }).disposed(by: disposeBag)
        let titleView = UIView()
        titleView.bounds = CGRect.init(x: 0, y: 0, width: kScreenWidth, height: 82)
        let titleLabel = UILabel()
        titleLabel.text = StellarLocalizedString("SMART_SET_CUTDOWN")
        titleLabel.textColor = STELLAR_COLOR_C4
        titleLabel.font = STELLAR_FONT_BOLD_T30
        titleLabel.frame = CGRect.init(x: 20, y: 0, width: kScreenWidth-20, height: 58)
        titleView.addSubview(titleLabel)
        view.addSubview(titleView)
        titleView.snp.makeConstraints { (make) in
            make.top.equalTo(navView.snp.bottom)
            make.left.right.equalTo(0)
            make.height.equalTo(82)
        }
        view.addSubview(nDatePicker)
        nDatePicker.snp.makeConstraints { (make) in
            make.top.equalTo(titleView.snp.bottom)
            make.left.right.equalTo(0)
            make.bottom.equalTo(bottomBtn.snp.top).offset(-10)
        }
    }
    lazy var navView:NavView = {
        let view = NavView()
        view.myState = .kNavBlack
        view.setTitle(title: "")
        return view
    }()
    lazy var bottomBtn:StellarButton = {
        let view = StellarButton()
        view.setTitle(StellarLocalizedString("COMMON_CONFIRM"), for: .normal)
        view.style = .normal
        return view
    }()
    lazy var nDatePicker:CountdownView = {
        let datePicker = CountdownView.CountdownView()
        return datePicker
    }()
    override var preferredStatusBarStyle: UIStatusBarStyle
    {
        return .default
    }
}