import UIKit
class BackgroundAddDevicesView: UIView {
    let disposeBag = DisposeBag()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupViews(){
        addSubview(bgView)
        bgView.addSubview(radarView)
        leftLabel.text = "网关正在批量添加设备"
        bgView.addSubview(leftLabel)
        rightBtn.setTitle("终止添加", for: .normal)
        rightBtn.rx.tap.subscribe(onNext:{
        }).disposed(by: disposeBag)
        bgView.addSubview(rightBtn)
        isHidden = true
        bgView.alpha = 0
    }
    func dismissView(){
        UIView.animate(withDuration: 0.5, animations: {
            self.bgView.frame.origin.y = -self.bgView.bounds.size.height
            self.bgView.alpha = 0
            self.radarView.stopScan()
        }) { (_) in
            self.isHidden = true
        }
    }
    func showView(){
        self.bgView.frame.origin.y = 0
        isHidden = false
        radarView.startScan()
        UIView.animate(withDuration: 0.5) {
            self.bgView.alpha = 1
        }
    }
    lazy var bgView:UIView = {
       let view = UIView.init(frame: self.bounds)
        view.backgroundColor = STELLAR_COLOR_C10
        return view
    }()
    lazy var radarView: RadarView = {
        let temView = RadarView.init(frame: CGRect(x: 12, y: self.frame.height - 12 - 20 , width: 20, height: 20))
        return temView
    }()
    lazy var leftLabel:UILabel = {
        let label = UILabel.init()
        label.backgroundColor = UIColor.clear
        label.frame = CGRect.init(x: self.radarView.frame.maxX + 8, y: self.radarView.frame.origin.y, width: self.bounds.width - (self.radarView.frame.maxX + 8) - 72, height: 18)
        label.font = STELLAR_FONT_T13
        label.textColor = STELLAR_COLOR_C3
        return label
    }()
    lazy var rightBtn:UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.frame = CGRect.init(x: self.leftLabel.frame.maxX, y: self.radarView.frame.origin.y, width: 60, height: 18)
        btn.titleLabel?.font = STELLAR_FONT_T13
        btn.setTitleColor(STELLAR_COLOR_C3, for: .normal)
        btn.addTarget(self, action: #selector(terminationAction), for: .touchUpInside)
        return btn
    }()
    @objc func terminationAction(){
    }
}