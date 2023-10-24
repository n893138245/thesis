import UIKit
enum addType {
    case brightness 
    case color 
    case temperature
}
class AddStreamerViewController: BaseViewController {
    var compeletBlock: ((_ obj: AddStreamerLocalModel) ->Void)?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fd_interactivePopDisabled = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fd_interactivePopDisabled = false
    }
    var addType:addType = .color {
        didSet {
            switch addType {
            case .temperature:
                navBar.titleLabel.text = "添加色温"
                temperView.isHidden = false
                colorPicker.isHidden = true
            case .color:
                navBar.titleLabel.text = "添加色彩"
                temperView.isHidden = true
                colorPicker.isHidden = false
            case .brightness:
                navBar.titleLabel.text = "添加亮度"
                temperView.isHidden = true
                colorPicker.isHidden = true
                slider.frame = CGRect(x: 20.fit, y: kScreenHeight/2, width: kScreenWidth-40.fit, height: 32.fit)
                timeButton.snp.makeConstraints {
                    $0.top.equalTo(lightingLabel.snp.bottom).offset(93.fit)
                    $0.right.equalTo(self.view).offset(-33.fit)
                }
            }
        }
    }
    func setupUI() {
        view.backgroundColor = STELLAR_COLOR_C3
        view.addSubview(lightingLabel)
        view.addSubview(colorPicker)
        view.addSubview(temperView)
        view.addSubview(slider)
        view.addSubview(timeButton)
        view.addSubview(navBar)
        view.addSubview(comfrimButton)
        lightingLabel.snp.makeConstraints {
            $0.right.equalTo(self.view).offset(-33.fit)
            $0.bottom.equalTo(slider.snp.top).offset(-16.fit)
        }
        timeButton.snp.makeConstraints {
            $0.right.equalTo(self.view).offset(-33.fit)
            $0.top.equalTo(lightingLabel.snp.bottom).offset(93.fit)
        }
        let britnessTitleLb = UILabel.init()
        britnessTitleLb.text = "亮度"
        britnessTitleLb.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        britnessTitleLb.textColor = STELLAR_COLOR_C6
        view.addSubview(britnessTitleLb)
        britnessTitleLb.snp.makeConstraints {
            $0.centerY.equalTo(lightingLabel)
            $0.left.equalTo(self.view).offset(20.fit)
        }
        let timeTitleLb = UILabel.init()
        timeTitleLb.text = "执行时长"
        timeTitleLb.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        timeTitleLb.textColor = STELLAR_COLOR_C6
        view.addSubview(timeTitleLb)
        timeTitleLb.snp.makeConstraints {
            $0.centerY.equalTo(timeButton)
            $0.left.equalTo(self.view).offset(20.fit)
        }
        let arrow = UIImageView.init(image: UIImage(named: "icon_gray_right_arrow"))
        view.addSubview(arrow)
        arrow.snp.makeConstraints {
            $0.right.equalTo(self.view).offset(-20.fit)
            $0.centerY.equalTo(timeButton)
        }
        let line = UIView.init()
        line.backgroundColor = STELLAR_COLOR_C8
        view.addSubview(line)
        line.snp.makeConstraints {
            $0.bottom.equalTo(timeTitleLb.snp.top).offset(-26.fit)
            $0.left.equalTo(self.view).offset(20.fit)
            $0.right.equalTo(self.view).offset(-20.fit)
            $0.height.equalTo(1)
        }
    }
    private func setupActions() {
        object.time = "00:01.0"
        object.brightness = 0.01
        timeButton.rx.tap.subscribe(onNext:{ [weak self] in
            let timePicker = StreamerDatePickerView.StreamerDatePickerView()
            timePicker.currentDate = self?.timeButton.currentTitle ?? "00:01.0"
            timePicker.comfrimBlock = { (timeString) in
                self?.timeButton.setTitle(timeString, for: .normal)
                self?.object.time = timeString
            }
        }).disposed(by: disposeBag)
        slider.sliderBlock = { [weak self] (value) in
            let pValue:Int = Int(value*100)
            self?.lightingLabel.text = "\(pValue)%"
            self?.object.brightness = value
        }
        navBar.backButton.rx.tap.subscribe(onNext:{ [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }).disposed(by: disposeBag)
        colorPicker.pickerEndCallBack = { [weak self] (color) in
            self?.object.color = color
        }
        comfrimButton.rx.tap.subscribe(onNext:{ [weak self] in
            if let block = self?.compeletBlock {
                block(self!.object)
            }
            self?.navigationController?.popViewController(animated: true)
        }).disposed(by: disposeBag)
        temperView.sliderEndBlock = { [weak self] (color) in
            self?.object.color = color
        }
    }
    private lazy var object: AddStreamerLocalModel = {
        let obj = AddStreamerLocalModel()
        return obj
    }()
    private lazy var comfrimButton: StellarButton = {
        let tempView = StellarButton.init(frame: CGRect(x: 42.fit, y: kScreenHeight-24.fit-46.fit, width: 291.fit, height: 46.fit))
        var frame = tempView.frame
        if #available(iOS 11.0, *) {
            frame.origin.y -= getAllVersionSafeAreaBottomHeight()
        }
        tempView.frame = frame
        tempView.style = .normal
        tempView.setTitle(StellarLocalizedString("COMMON_CONFIRM"), for: .normal)
        return tempView
    }()
    private lazy var timeButton: UIButton = {
        let tempView = UIButton.init(type: .custom)
        tempView.setTitle("00:01.0", for: .normal)
        tempView.titleLabel?.font = STELLAR_FONT_NUMBER_T19
        tempView.setTitleColor(STELLAR_COLOR_C4, for: .normal)
        return tempView
    }()
    private lazy var lightingLabel: UILabel = {
        let tempView = UILabel.init()
        tempView.text = "1%"
        tempView.font = STELLAR_FONT_NUMBER_T19
        tempView.textColor = STELLAR_COLOR_C4
        return tempView
    }()
    private lazy var slider: StellarSlider = {
        let tempView = StellarSlider.init(frame: CGRect(x: 20.fit, y: kScreenHeight-172.fit-32.fit , width: kScreenWidth-40.fit , height: 32.fit))
        var frame = tempView.frame
        if #available(iOS 11.0, *) {
            frame.origin.y -= getAllVersionSafeAreaBottomHeight()
        }
        tempView.frame = frame
        tempView.value = 0.01
        return tempView
    }()
    lazy var navBar: DetailNavBar = {
        let tempView = DetailNavBar.init(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kNavigationH))
        tempView.moreButton.isHidden = true
        tempView.style = .defaultStyle
        return tempView
    }()
    private lazy var colorPicker: TheColorPickerView = {
        let tempView = TheColorPickerView(frame:  CGRect(x: 24.fit, y: kNavigationH+44.fit, width: kScreenWidth-48.fit, height: kScreenWidth-48.fit), theRGB: RGB.init(255/255.0, 255/255.0, 255/255.0, 1.0))
        return tempView
    }()
    private lazy var temperView: CircleSlider = {
        let tempView = CircleSlider(frame: CGRect(x: 25, y: kNavigationH+44.fit, width: kScreenWidth-50, height: kScreenWidth-50))
        tempView.setProgress(value: 0)
        return tempView
    }()
}