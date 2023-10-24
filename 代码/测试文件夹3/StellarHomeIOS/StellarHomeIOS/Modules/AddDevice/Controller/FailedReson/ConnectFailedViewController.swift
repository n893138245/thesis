import UIKit
class ConnectFailedViewController: AddDeviceBaseViewController {
    var isFailedReson = false
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupReactive()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !isFailedReson {
            fd_interactivePopDisabled = true
        }else {
            fd_interactivePopDisabled = false
        }
    }
    private func setupUI() {
        lineImage.isHidden = true
        if isFailedReson {
            navBar.titleLabel.text = StellarLocalizedString("ALERT_WHT_FAILED")
            navBar.exitButton.isHidden = true
            hintPic.isHidden = true
            placeholderPic.snp.makeConstraints {
                $0.left.equalTo(self.cardView).offset(122.fit)
                $0.top.equalTo(self.cardView)
                $0.width.equalTo(0)
                $0.height.equalTo(0)
            }
            aginButton.setTitle(StellarLocalizedString("COMMON_CONFIRM"), for: .normal)
        }else {
            navBar.titleLabel.text = StellarLocalizedString("ADD_DEVICE_CONNECT_FAILED")
            navBar.backButton.isHidden = true
            placeholderPic.snp.makeConstraints {
                $0.left.equalTo(self.cardView).offset(122.fit)
                $0.top.equalTo(self.cardView).offset(45.fit)
                $0.width.equalTo(138.fit)
                $0.height.equalTo(101.fit)
            }
        }
        aginButton.snp.makeConstraints {
            $0.bottom.equalTo(self.cardView.snp.bottom).offset(-40.fit)
            $0.left.equalTo(self.cardView.snp.left).offset(33.fit)
            $0.right.equalTo(self.cardView.snp.right).offset(-33.fit)
            $0.height.equalTo(46.fit)
        }
        hintPic.snp.makeConstraints {
            $0.centerX.equalTo(self.cardView)
            $0.bottom.equalTo(placeholderPic.snp.top).offset(-15.fit)
            $0.width.equalTo(40.fit)
            $0.height.equalTo(40.fit)
        }
        fristNumLabel.snp.makeConstraints {
            $0.left.equalTo(self.cardView).offset(22.fit)
            $0.top.equalTo(placeholderPic.snp.bottom).offset(52.fit)
            $0.width.equalTo(18.fit)
            $0.height.equalTo(18.fit)
        }
        secondNumLabel.snp.makeConstraints {
            $0.left.equalTo(self.cardView).offset(22.fit)
            $0.top.equalTo(fristNumLabel.snp.bottom).offset(61.fit)
            $0.width.equalTo(18.fit)
            $0.height.equalTo(18.fit)        }
        thirdNumLabel.snp.makeConstraints {
            $0.left.equalTo(self.cardView).offset(22.fit)
            $0.top.equalTo(secondNumLabel.snp.bottom).offset(34.fit)
            $0.width.equalTo(18.fit)
            $0.height.equalTo(18.fit)
        }
        fristTipLabel.snp.makeConstraints {
            $0.left.equalTo(self.cardView).offset(52.fit)
            $0.right.equalTo(self.view).offset(-23.fit)
            $0.top.equalTo(fristNumLabel)
        }
        secondTipLabel.snp.makeConstraints {
            $0.left.equalTo(self.cardView).offset(52.fit)
            $0.right.equalTo(self.view).offset(-23.fit)
            $0.top.equalTo(secondNumLabel)
        }
        thirdTipLabel.snp.makeConstraints {
            $0.left.equalTo(self.cardView).offset(52.fit)
            $0.right.equalTo(self.view).offset(-23.fit)
            $0.top.equalTo(thirdNumLabel)
        }
    }
    private func setupReactive() {
        aginButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.back()
            }).disposed(by: disposeBag)
        navBar.backButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.back()
            }).disposed(by: disposeBag)
    }
    private func back() {
        if isFailedReson {
            navigationController?.popViewController(animated: true)
        }else {
            popToViewController(withClass: AddDeviceVC.className())
        }
    }
    private lazy var placeholderPic: UIImageView = {
        let tempView = UIImageView.init()
        tempView.image = UIImage(named: "icon_input_wifi_failure")
        tempView.contentMode = .scaleToFill
        view.addSubview(tempView)
        return tempView
    }()
    private lazy var hintPic: UIImageView = {
        let tempView = UIImageView.init()
        tempView.image = UIImage(named: "icon_add_failure_small")
        tempView.contentMode = .scaleToFill
        view.addSubview(tempView)
        return tempView
    }()
    private lazy var fristTipLabel: UILabel = {
        let tempView = UILabel.init()
        tempView.text = StellarLocalizedString("ALERT_CHECK_NET_SELECT")
        tempView.textColor = STELLAR_COLOR_C5
        tempView.font = STELLAR_FONT_T15
        tempView.numberOfLines = 0
        tempView.textAlignment = .left
        view.addSubview(tempView)
        return tempView
    }()
    private lazy var secondTipLabel: UILabel = {
        let tempView = UILabel.init()
        tempView.text = StellarLocalizedString("ALERT_CHECK_WIFI_PASSWORD")
        tempView.textColor = STELLAR_COLOR_C5
        tempView.font = STELLAR_FONT_T15
        tempView.numberOfLines = 0
        tempView.textAlignment = .left
        view.addSubview(tempView)
        return tempView
    }()
    private lazy var thirdTipLabel: UILabel = {
        let tempView = UILabel.init()
        tempView.text = StellarLocalizedString("ALERT_CHECK_WIFI_ISOLATION")
        tempView.textColor = STELLAR_COLOR_C5
        tempView.font = STELLAR_FONT_T15
        tempView.numberOfLines = 0
        tempView.textAlignment = .left
        view.addSubview(tempView)
        return tempView
    }()
    private lazy var fristNumLabel: UILabel = {
        let tempView = UILabel.init()
        tempView.text = "1"
        tempView.backgroundColor = STELLAR_COLOR_C8
        tempView.layer.cornerRadius = 9.fit
        tempView.clipsToBounds = true
        tempView.textColor = STELLAR_COLOR_C5
        tempView.font = STELLAR_FONT_T14
        tempView.textAlignment = .center
        view.addSubview(tempView)
        return tempView
    }()
    private lazy var secondNumLabel: UILabel = {
        let tempView = UILabel.init()
        tempView.text = "2"
        tempView.backgroundColor = STELLAR_COLOR_C8
        tempView.layer.cornerRadius = 9.fit
        tempView.clipsToBounds = true
        tempView.textColor = STELLAR_COLOR_C5
        tempView.font = STELLAR_FONT_T14
        tempView.textAlignment = .center
        view.addSubview(tempView)
        return tempView
    }()
    private lazy var thirdNumLabel: UILabel = {
        let tempView = UILabel.init()
        tempView.text = "3"
        tempView.backgroundColor = STELLAR_COLOR_C8
        tempView.layer.cornerRadius = 9.fit
        tempView.clipsToBounds = true
        tempView.textColor = STELLAR_COLOR_C5
        tempView.font = STELLAR_FONT_T14
        tempView.textAlignment = .center
        view.addSubview(tempView)
        return tempView
    }()
    private lazy var aginButton: UIButton = {
        let tempView = StellarButton.init(frame: CGRect(x: 0, y: 0, width: 291.fit, height: 46.fit))
        tempView.setTitle(StellarLocalizedString("ALERT_TRY_AGAIN"), for: .normal)
        tempView.style = .normal
        view.addSubview(tempView)
        return tempView
    }()
}