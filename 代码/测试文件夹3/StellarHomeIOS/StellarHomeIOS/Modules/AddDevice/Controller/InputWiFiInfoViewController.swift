import UIKit
import SwiftRichString
class InputWiFiInfoViewController: AddDeviceBaseViewController {
    var isAddWifiDevice = false
    var deviceToken: String = ""
    var bleEquipmentModel:BleEquipmentModel?
    var deviceDetailModel:AddDeviceDetailModel = AddDeviceDetailModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupReactive()
        checkWifi()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.wifiNameTf.textField.resignFirstResponder()
        self.passwordTf.textField.resignFirstResponder()
    }
    private func setupUI() {
        if isAddWifiDevice {
            navBar.titleLabel.text = "添加\(deviceDetailModel.appShownType ?? "WiFi灯")"
            navBar.titleLabel.font = STELLAR_FONT_MEDIUM_T18
            navBar.titleLabel.textColor = STELLAR_COLOR_C3
            navBar.backButton.isHidden = true
            fd_interactivePopDisabled = true
        }else {
            navBar.titleLabel.text = StellarLocalizedString("GATEWAY_CONNECT")
            navBar.exitButton.isHidden = true
        }
        cardView.addSubview(wifiNameTf)
        cardView.addSubview(passwordTf)
        placeholderPic.snp.makeConstraints {
            $0.top.equalTo(self.cardView).offset(21.fit)
            $0.height.equalTo(80.fit)
            $0.width.equalTo(109.fit)
            $0.centerX.equalTo(self.cardView)
        }
        fristTipLabel.snp.makeConstraints {
            $0.centerX.equalTo(self.view)
            $0.top.equalTo(placeholderPic.snp.bottom).offset(19.fit)
        }
        secondTipLabel.snp.makeConstraints {
            $0.centerX.equalTo(self.view)
            $0.top.equalTo(fristTipLabel.snp.bottom).offset(9.fit)
        }
        confirmButton.snp.makeConstraints {
            $0.top.equalTo(secondTipLabel.snp.bottom).offset(203.fit)
            $0.left.equalTo(self.cardView.snp.left).offset(33.fit)
            $0.right.equalTo(self.cardView.snp.right).offset(-33.fit)
            $0.height.equalTo(46.fit)
        }
    }
    private func setupReactive() {
        confirmButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.clickConfirm()
            }).disposed(by: disposeBag)
        navBar.backButton.rx.tap
            .subscribe(onNext:{ [weak self] in
                if self?.deviceDetailModel.type == .hub { 
                    self?.popToViewController(withClass: CommonGuideViewController.className())
                }else {
                    self?.navigationController?.popViewController(animated: true)
                }
            }).disposed(by: disposeBag)
        wifiNameTf.changeWifiBtn?.rx.tap
            .subscribe(onNext:{
                UIApplication.shared.open(URL.init(string: UIApplication.openSettingsURLString)! , options: [:], completionHandler: nil)
            }).disposed(by: disposeBag)
        wifiNameTf.textField.rx.controlEvent([.editingChanged])
            .asObservable()
            .subscribe(onNext: { [weak self] _ in
                if self?.wifiNameTf.textField.text?.isEmpty ?? false {
                    self?.confirmButton.isEnabled = false
                }else {
                    self?.confirmButton.isEnabled = true
                    guard let pwd = userDefaults.value(forKey: self?.wifiNameTf.textField.text ?? "") as? String else {
                        self?.passwordTf.textField.text = ""
                        self?.passwordTf.bottomTitleLabel.isHidden = true
                        return
                    }
                    if self?.passwordTf.textField.text?.isEmpty ?? true { 
                        self?.passwordTf.textField.text = pwd
                    }
                }
            })
            .disposed(by: disposeBag)
        passwordTf.textField.rx.controlEvent([.editingChanged]).asObservable().subscribe(onNext: { [weak self] _ in
            if self?.wifiNameTf.textField.text == nil {
                self?.confirmButton.isEnabled = false
                return
            }
            let pwText = self?.passwordTf.textField.text ?? ""
            if (pwText.count > 0 && pwText.count < 8) || (pwText.count >= 64) {
                self?.confirmButton.isEnabled = false
            }else {
                self?.confirmButton.isEnabled = true
            }
        }).disposed(by: disposeBag)
        NotificationCenter.default.rx.notification(UIApplication.didBecomeActiveNotification)
            .subscribe(onNext: { [weak self] (_) in
                self?.checkWifi()
            }).disposed(by: disposeBag)
    }
    private func clickConfirm() {
        if wifiNameTf.textField.text?.isEmpty ?? true {
            TOAST(message: StellarLocalizedString("ADD_DEVICE_WI-FI_EMPTY_TIP"))
            return
        }
        if (passwordTf.textField.text?.isEmpty ?? true) {
            showOpenWifiTip()
        }else {
            isAddWifiDevice ? pushToWifiGuide() : pushToPair()
        }
    }
    private func showOpenWifiTip() {
        let alert = StellarContentTitleAlertView.stellarContentTitleAlertView()
        alert.setTitleAndContentType(content: StellarLocalizedString("ALERT_NO_PASSWORD_WIFI"), leftClickString: StellarLocalizedString("COMMON_CANCEL"), rightClickString: StellarLocalizedString("COMMON_CONFIRM"), title: "")
        alert.rightButtonBlock = {
            self.isAddWifiDevice ? self.pushToWifiGuide() : self.pushToPair()
        }
        view.addSubview(alert)
        alert.showView()
    }
    private func pushToWifiGuide() {
        let vc = AddWiFiDeviceGuideController()
        vc.wifiName = wifiNameTf.textField.text ?? ""
        vc.wifiPsw = passwordTf.textField.text ?? ""
        vc.deviceToken = deviceToken
        vc.addDetailModel = deviceDetailModel
        navigationController?.pushViewController(vc, animated: true)
        storeWifiInfo() 
    }
    private func pushToPair() {
        view.endEditing(true)
        storeWifiInfo()
        let ssid = transferredSpecialCharacter(wifiNameTf.textField.text ?? "")
        let password = transferredSpecialCharacter(passwordTf.textField.text ?? "")
        let vc = PairGatewayViewController.init()
        vc.networkInfo["ssid"] = ssid
        vc.networkInfo["password"] = password
        vc.bleEquipmentModel = bleEquipmentModel
        vc.myDeviceType = .hub
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    private func transferredSpecialCharacter(_ character:String)->String{
        var newString = ""
        for c in character {
            newString.append(c)
        }
        return newString
    }
    private func checkWifi() {
        if getWifiInfo().ssid?.isEmpty ?? true {
            showConnectWiFiAlert()
        }else {
            autoFillPassword()
        }
    }
    private func showConnectWiFiAlert() {
        let alert = StellarContentTitleAlertView.stellarContentTitleAlertView()
        alert.setTitleAndContentType(content: StellarLocalizedString("ALERT_NO_PHONE_CONNECT_WIFI"), leftClickString: StellarLocalizedString("COMMON_CANCEL"), rightClickString: StellarLocalizedString("GATEWAY_CONNECT_WIFI"), title: "")
        alert.rightButtonBlock = {
            UIApplication.shared.open(URL.init(string: UIApplication.openSettingsURLString)! , options: [:], completionHandler: nil)
        }
        self.view.addSubview(alert)
        alert.showView()
    }
    private func autoFillPassword() {
        wifiNameTf.textField.text = getWifiInfo().ssid ?? ""
        confirmButton.isEnabled = true
        guard let pwd = userDefaults.value(forKey: getWifiKey()) as? String else {
            passwordTf.textField.text = ""
            return
        }
        if passwordTf.textField.text?.isEmpty ?? true {
            passwordTf.textField.text = pwd
        }
    }
    private func storeWifiInfo() {
        userDefaults.set(passwordTf.textField.text, forKey: getWifiKey())
    }
    private func getWifiKey() ->String {
        return "WIFI" + transferredSpecialCharacter(wifiNameTf.textField.text ?? "" + "KEY")
    }
    private lazy var placeholderPic: UIImageView = {
        let tempView = UIImageView.init()
        tempView.image = UIImage(named: "icon_input_wifi")
        tempView.contentMode = .scaleAspectFit
        view.addSubview(tempView)
        return tempView
    }()
    private lazy var fristTipLabel: UILabel = {
        let tempView = UILabel.init()
        tempView.text = StellarLocalizedString("GATEWAY_INPUT_WIFI_PASSWORD")
        tempView.textColor = STELLAR_COLOR_C4
        tempView.font = STELLAR_FONT_MEDIUM_T20
        view.addSubview(tempView)
        return tempView
    }()
    private lazy var secondTipLabel: UILabel = {
        let tempView = UILabel.init()
        let str1 = StellarLocalizedString("GATEWAY_UNSUPPORTED")
        let str2 = " 5G "
        let str3 = StellarLocalizedString("GATEWAY_USE_CONNECT_WIFI")
        let style1 = Style{
            $0.font = STELLAR_FONT_T14
            $0.color = STELLAR_COLOR_C6
        }
        let style2 = Style{
            $0.font = STELLAR_FONT_BOLD_T14
            $0.color = STELLAR_COLOR_C4
        }
        let atrre = str1.set(style: style1) + str2.set(style: style2) + str3.set(style: style1)
        tempView.attributedText = atrre
        view.addSubview(tempView)
        return tempView
    }()
    private lazy var confirmButton: UIButton = {
        let tempView = StellarButton.init(frame: CGRect(x: 0, y: 0, width: 291.fit, height: 46.fit))
        tempView.setTitle(StellarLocalizedString("COMMON_CONFIRM"), for: .normal)
        tempView.style = .normal
        tempView.isEnabled = false
        view.addSubview(tempView)
        return tempView
    }()
    private lazy var wifiNameTf: StellarTextField = {
        let tempView = StellarTextField.init(frame: CGRect(x: 23.fit, y: 201.fit, width: 311.fit, height: 79.fit))
        tempView.title = "Wi-Fi"
        tempView.style = .wifiName
        return tempView
    }()
    private lazy var passwordTf: StellarTextField = {
        let tempView = StellarTextField.init(frame: CGRect(x: 23.fit, y: 285.fit, width: 311.fit, height: 79.fit))
        tempView.title = StellarLocalizedString("GATEWAY_INPUT_WIFI_PASSWORD")
        tempView.style = .wifiPassword
        return tempView
    }()
}