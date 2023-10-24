import UIKit
class StreamerDetailViewController: BaseViewController {
    private var selecedModeBtn: UIButton?
    var playBlock: ((_ isPlay: Bool) -> Void)?
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
    private func setupUI() {
        view.backgroundColor = STELLAR_COLOR_C3
        view.addSubview(navBar)
        let modeLabel = UILabel.init()
        view.addSubview(modeLabel)
        modeLabel.text = "选择模式"
        modeLabel.font = STELLAR_FONT_MEDIUM_T20
        modeLabel.textColor = STELLAR_COLOR_C4
        modeLabel.snp.makeConstraints {
            $0.left.equalTo(20.fit)
            $0.top.equalTo(navBar.snp.bottom).offset(32.fit)
        }
        let titles = ["七彩渐变","七彩闪烁","七彩跳变"]
        for index in 0...titles.count-1 {
            let button = UIButton.init(type: .custom)
            button.frame = CGRect(x: 20.fit+CGFloat(index)*118.fit, y: navBar.frame.height+84.fit, width: 98.fit, height: 38.fit)
            button.layer.cornerRadius = 19.fit
            button.layer.masksToBounds = true
            button.setBackgroundImage(UIColor.ss.getImageWithColor(color: STELLAR_COLOR_C1), for: .selected)
            button.setBackgroundImage(UIColor.ss.getImageWithColor(color: STELLAR_COLOR_C8), for: .normal)
            button.setTitle(titles[index], for: .normal)
            button.setTitleColor(STELLAR_COLOR_C3, for: .selected)
            button.setTitleColor(STELLAR_COLOR_C4, for: .normal)
            button.titleLabel?.font = STELLAR_FONT_T14
            button.addTarget(self, action: #selector(clickMode), for: .touchUpInside)
            view.addSubview(button)
            if index == 0 {
                selecedModeBtn = button
                selecedModeBtn?.isSelected = true
            }
        }
        let frequLabel = UILabel.init()
        view.addSubview(frequLabel)
        frequLabel.text = "调整频率"
        frequLabel.font = STELLAR_FONT_MEDIUM_T20
        frequLabel.textColor = STELLAR_COLOR_C4
        frequLabel.snp.makeConstraints {
            $0.left.equalTo(20.fit)
            $0.top.equalTo(modeLabel.snp.bottom).offset(110.fit)
        }
        view.addSubview(slider)
        view.addSubview(playButton)
        playButton.addSubview(playIcon)
        playIcon.snp.makeConstraints {
            $0.center.equalTo(playButton)
        }
    }
    private func setupActions() {
        slider.sliderBlock = { value in
        }
        navBar.backButton.rx.tap.subscribe(onNext:{ [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }).disposed(by: disposeBag)
        playButton.rx.tap.subscribe(onNext:{ [weak self] in
            self?.playButton.isSelected = !(self?.playButton.isSelected)!
            self?.playIcon.image = (self?.playButton.isSelected)! ?  UIImage(named: "icon_red_stop") : UIImage(named: "icon_scence_play")
            if let block = self?.playBlock {
                block((self?.playButton.isSelected)!)
            }
        }).disposed(by: disposeBag)
    }
    @objc private func clickMode(button: UIButton) {
        if button.isEqual(selecedModeBtn) {
            return
        }
        selecedModeBtn?.isSelected = false
        button.isSelected = true
        selecedModeBtn = button
    }
    private lazy var navBar: DetailNavBar = {
        let tempView = DetailNavBar.init(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kNavigationH))
        tempView.titleLabel.text = "七彩流光"
        tempView.moreButton.isHidden = true
        tempView.style = .defaultStyle
        return tempView
    }()
    lazy var slider: StellarSlider = {
        let tempView = StellarSlider.init(frame: CGRect(x: 20.fit, y: kNavigationH+206.fit, width: kScreenWidth-40.fit, height: 32.fit))
        tempView.value = 0.3
        return tempView
    }()
    private lazy var playIcon: UIImageView = {
        let tempView = UIImageView.init(image: UIImage(named: "icon_scence_play") )
        tempView.backgroundColor = UIColor.init(hexString: "#E1ECFF")
        return tempView
    }()
    private lazy var playButton: UIButton = {
        let tempView = UIButton.init(type: .custom)
        tempView.setBackgroundImage(UIColor.ss.getImageWithColor(color: UIColor.init(hexString: "#E1ECFF")), for: .normal)
        tempView.setBackgroundImage(UIColor.ss.getImageWithColor(color: UIColor.init(hexString: "#FFE6E6")), for: .selected)
        tempView.frame = CGRect(x: 121.fit, y: kScreenHeight - 32.fit - 46.fit - getAllVersionSafeAreaBottomHeight(), width: 133.fit, height: 46.fit)
        tempView.layer.cornerRadius = 23.fit
        tempView.clipsToBounds = true
        tempView.adjustsImageWhenHighlighted = false
        return tempView
    }()
}