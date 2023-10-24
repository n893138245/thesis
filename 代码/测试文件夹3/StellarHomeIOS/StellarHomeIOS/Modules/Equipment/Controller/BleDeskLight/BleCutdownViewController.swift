import UIKit
class BleCutdownViewController: BaseViewController {
    private let timeValue = [30,60,90]
    private var currentIndex: Int = 0
    private let tag_start = 1000
    var lightModel: LightModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupRx()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getCurrentCutdownState()
    }
    private func setupUI() {
        view.backgroundColor = STELLAR_COLOR_C3
        view.addSubview(progressView)
        view.addSubview(bottomButton)
        let bottomSpace = 126.fit+24.fit + getAllVersionSafeAreaBottomHeight()
        bottomButton.snp.makeConstraints {
            $0.width.equalTo(178.fit)
            $0.height.equalTo(46.fit)
            $0.centerX.equalTo(view)
            $0.bottom.equalTo(view).offset(-bottomSpace)
        }
        setTimeButtons()
    }
    private func setTimeButtons() {
        let bottomSpace = 126.fit + 24.fit + 46.fit + 43.fit + 42.fit + getAllVersionSafeAreaBottomHeight()
        for idx in 0..<timeValue.count {
            let timeBtn = UIButton.init(type: .custom)
            timeBtn.frame = CGRect(x: 34.fit+CGFloat(idx)*(94.fit+12.fit), y: kScreenHeight - bottomSpace, width: 94.fit, height: 42.fit)
            timeBtn.setTitle("\(timeValue[idx])\(StellarLocalizedString("EQUIPMENT_SEC"))", for: .normal)
            timeBtn.tag = idx + tag_start
            timeBtn.layer.cornerRadius = 4.fit
            timeBtn.clipsToBounds = true
            timeBtn.setBackgroundImage(UIColor.ss.getImageWithColor(color: STELLAR_COLOR_C1), for: .selected)
            timeBtn.setBackgroundImage(UIColor.ss.getImageWithColor(color: STELLAR_COLOR_C9), for: .normal)
            timeBtn.setTitleColor(STELLAR_COLOR_C5, for: .normal)
            timeBtn.setTitleColor(STELLAR_COLOR_C3, for: .selected)
            timeBtn.setTitleColor(STELLAR_COLOR_C3, for: .disabled)
            timeBtn.titleLabel?.font = STELLAR_FONT_T16
            view.addSubview(timeBtn)
            timeBtn.addTarget(self, action: #selector(timeClick), for:.touchUpInside)
        }
        updateButtons(buttonIdx: currentIndex)
    }
    private func setupRx() {
        bottomButton.rx.tap.subscribe(onNext:{ [weak self] in
            self?.bottonClick()
        }).disposed(by: disposeBag)
    }
    private func bottonClick() {
        bottomButton.startIndicator()
        if bottomButton.style == .normal { 
            let time = timeValue[currentIndex]
            StellarHomeBleManger.sharedManager.setupDelayCloseLight(light: lightModel ?? LightModel(), delay: time ) { [weak self] (success, model, _) in
                self?.bottomButton.stopIndicator()
                if success {
                    self?.startCutdown(restime: time, totalTime: time)
                    let userInfo = ["time":time]
                    NotificationCenter.default.post(name: .NOTIFY_BLE_CUTDOWN_START, object: nil, userInfo: userInfo)
                }else {
                    TOAST(message: "执行失败")
                }
            }
        }else if bottomButton.style == .gray { 
            StellarHomeBleManger.sharedManager.setupDelayCloseLight(light: lightModel ?? LightModel(), delay: 0 ) { [weak self] (success, model, _) in
                self?.bottomButton.stopIndicator()
                if success {
                    self?.stopCutdown()
                    NotificationCenter.default.post(name:.NOTIFY_BLE_CUTDOWN_CLOSE, object: nil, userInfo: nil)
                }else {
                    TOAST(message: "执行失败")
                }
            }
        }
    }
    @objc func timeClick(btn: UIButton) {
        if btn.tag == currentIndex + tag_start {
            return
        }
        currentIndex = btn.tag - tag_start
        updateButtons(buttonIdx: currentIndex)
        updateProgressTitle(sec: timeValue[currentIndex])
    }
    private func getCurrentCutdownState() {
        stopCutdown()
        StellarHomeBleManger.sharedManager.queryDelayCloseLight(light: lightModel ?? LightModel()) { (success, light, totalTime, restTime) in
            if let rest = restTime,let total = totalTime {  
                print("倒计时----过去时间\(rest)   总时间\(total)")
                if rest != 0 {
                    self.startCutdown(restime: (total-rest), totalTime: total)
                }
            }
        }
    }
    private func startCutdown(restime: Int,totalTime: Int) {
        if let index = self.timeValue.firstIndex(where: {$0 == totalTime}) {
            currentIndex = index
            self.updateButtons(buttonIdx: index)
            self.setTimeButtonEnabled(enable: false)
            let progress = CGFloat(restime)/CGFloat(totalTime)
            self.progressView.updateProgress(remainingProgress: progress, duration: CFTimeInterval(restime))
            self.bottomButton.style = .gray
            self.bottomButton.setTitle(StellarLocalizedString("EQUIPMENT_STOP_CD"), for: .normal)
            self.progressView.titleLabel.text = StellarLocalizedString("EQUIPMENT_DELAT_OFF_TIP")
        }
    }
    private func stopCutdown() {
        progressView.cancelCutDwon()
        setTimeButtonEnabled(enable: true)
        self.bottomButton.style = .normal
        self.bottomButton.setTitle(StellarLocalizedString("EQUIPMENT_START_CD"), for: .normal)
        updateProgressTitle(sec: timeValue[currentIndex])
    }
    private func updateButtons(buttonIdx: Int) {
        for i in 0...2 {
            if let button = self.view.viewWithTag(i + tag_start) as? UIButton {
                if buttonIdx == i {
                    button.isSelected = true
                    updateProgressTitle(sec: timeValue[buttonIdx])
                }else {
                    button.isSelected = false
                }
            }
        }
    }
    private func setTimeButtonEnabled(enable: Bool) {
        for i in 0...2 {
            if let button = self.view.viewWithTag(i + tag_start) as? UIButton {
                if button.isSelected {
                    if enable {
                        button.setBackgroundImage(UIColor.ss.getImageWithColor(color: STELLAR_COLOR_C9), for: .normal)
                        button.setTitleColor(STELLAR_COLOR_C5, for: .normal)
                    }else {
                        button.setBackgroundImage(UIColor.ss.getImageWithColor(color: STELLAR_COLOR_C7), for: .normal)
                        button.setTitleColor(STELLAR_COLOR_C3, for: .normal)
                    }
                }else {
                    button.setBackgroundImage(UIColor.ss.getImageWithColor(color: STELLAR_COLOR_C9), for: .disabled)
                    button.setTitleColor(STELLAR_COLOR_C7, for: .disabled)
                }
                button.isEnabled = enable
            }
        }
    }
    private func updateProgressTitle(sec: Int) {
        var titleSet = "设置"
        let titleTime = "\(sec)"
        var titleS = "秒"
        var titleTip = "后关灯"
        if !isChinese() {
            titleSet = "After "
            titleS = "S"
            titleTip = " Trun off"
        }
        let styleC5 = Style{
            $0.font = STELLAR_FONT_MEDIUM_T18
            $0.color = STELLAR_COLOR_C5
        }
        let styleC1 = Style{
            $0.font = STELLAR_FONT_MEDIUM_T18
            $0.color = STELLAR_COLOR_C1
        }
        let styleNum = Style{
            $0.font = STELLAR_FONT_NUMBER_T18
            $0.color = STELLAR_COLOR_C1
        }
        let atrre = titleSet.set(style: styleC5) + titleTime.set(style: styleNum) + titleS.set(style: styleC1) + titleTip.set(style: styleC5)
        progressView.titleLabel.attributedText = atrre
    }
    private lazy var progressView: DelayOffProgressView = {
        let bottomSpace = 126.fit + 24.fit + 46.fit + 43.fit + 42.fit + getAllVersionSafeAreaBottomHeight()
        let contentH = kScreenHeight-kNavigationH-bottomSpace
        let tempView = DelayOffProgressView.init(frame: CGRect(x: (kScreenWidth-231.fit)/2.0, y: contentH/2-231.fit/2+kNavigationH, width: 231.fit, height: 231.fit))
        return tempView
    }()
    private lazy var bottomButton: StellarButton = {
        let tempView = StellarButton()
        tempView.setTitle(StellarLocalizedString("EQUIPMENT_START_CD"), for: .normal)
        tempView.style = .normal
        return tempView
    }()
}