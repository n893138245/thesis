import UIKit
private enum TimerActionType {
    case socketConnectWiFi
    case queryDeviceOnline
    case addDeviceSuccess
}
class DeviceConnectWIFiController: AddDeviceBaseViewController {
    private var socket: StellarLocalRequset = StellarLocalRequset.sharedInstance
    private var timer: Timer?
    private var timerCount: Int = 0
    var wifiName: String = ""
    var wifiPsw: String = ""
    var mac: String = ""
    var sn: String = ""
    var deviceApSsid: String = ""
    var deviceToken: String = ""
    var addDetailModel: AddDeviceDetailModel?
    private var timerActionType: TimerActionType = .socketConnectWiFi
    private var isSendWifiSuccess: Bool = false
    private var isSendTokenSuccess: Bool = false
    private var isSendServerSuccess: Bool = false
    private var isStartRegisterSuccess: Bool = false
    private let queue = DispatchQueue.init(label: "setupWiFiDevice");
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fd_interactivePopDisabled = true
        setupUI()
        timerActionType = .socketConnectWiFi
        socket.delegate = self
        setupTimer()
    }
    func jumpToNameSetView() {
        DevicesStore.sharedStore().getSingleDeviceInfo(sn: self.sn, success: { (json) in
            self.storeWifiInfo()
            self.progress.setProgress(1.0, animated: true)
            let light =  json.kj.model(LightModel.self)
            let vc = ConnectSuccessViewController()
            vc.myDeviceType = light.type
            vc.device = light
            self.navigationController?.pushViewController(vc, animated: true)
        }) { (err) in
            let vc = ConnectFailedViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    func queryDeviceInfo() {
        DevicesStore.sharedStore().getSingleDeviceInfo(sn: self.sn, success: { (json) in
            let registerToken = json["registerToken"] as? String
            if registerToken == self.deviceToken{
                self.timerActionType = .addDeviceSuccess
            }
        }, failure: nil)
    }
    func setupTimer() {
        timerCount = 0
        timerActionType = .socketConnectWiFi
        timer = Timer.scheduledTimer(withTimeInterval: 1, block: { (t) in
            self.timerAction()
        }, repeats: true)
        timer?.fireDate = Date()
    }
    func startSendUDPFrame() {
        if self.isSendWifiSuccess == false{
            self.socket.connectToWifi(mac: self.mac, SSID: self.wifiName, password: self.wifiPsw)
        }
        if self.isSendTokenSuccess == false {
            self.socket.sendDeviceToken(mac: self.mac, token: self.deviceToken)
        }
        if self.isSendServerSuccess == false {
            self.socket.setupService(mac: self.mac, url: StellarHomeResourceUrl.wifi_device_reomte_url, port: StellarHomeResourceUrl.wifi_device_reomte_port)
        }
        if self.isSendTokenSuccess == true &&
            self.isSendServerSuccess == true &&
            self.isSendWifiSuccess == true &&
            self.isStartRegisterSuccess == false{
            self.socket.begainRegistAction(mac: self.mac)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        placeholderPic.stopAnimating()
        socket.delegate = nil
        if timer != nil {
            timer?.fireDate = Date.distantFuture
            timer?.invalidate()
            timer = nil
        }
    }
    func setupUI() {
        navBar.titleLabel.text = "添加\(addDetailModel?.appShownType ?? "WiFi灯")"
        navBar.titleLabel.font = STELLAR_FONT_MEDIUM_T18
        navBar.titleLabel.textColor = STELLAR_COLOR_C3
        navBar.backButton.isHidden = true
        navBar.exitButton.isHidden = true
        placeholderPic.snp.makeConstraints {
            $0.top.equalTo(self.cardView).offset(106.fit)
            $0.height.equalTo(164.fit)
            $0.width.equalTo(220.fit)
            $0.centerX.equalTo(self.view)
        }
        fristTipLabel.snp.makeConstraints {
            $0.centerX.equalTo(self.view)
            $0.top.equalTo(placeholderPic.snp.bottom).offset(24.fit)
        }
        secondTipLabel.snp.makeConstraints {
            $0.centerX.equalTo(self.view)
            $0.top.equalTo(fristTipLabel.snp.bottom).offset(8.fit)
        }
        view.addSubview(progress)
        progress.snp.makeConstraints {
            $0.top.equalTo(secondTipLabel.snp.bottom).offset(20.fit)
            $0.centerX.equalTo(view)
            $0.width.equalTo(195.fit)
        }
        placeholderPic.startAnimating()
    }
    private func timerAction() {
        timerCount += 1
        if timerCount == 60 {
            let vc = ConnectFailedViewController()
            self.navigationController?.pushViewController(vc, animated: true)
            return
        }
        switch timerActionType {
        case .socketConnectWiFi:
            let currentSSID = getWifiInfo().ssid
            if currentSSID != self.deviceApSsid {
                print(wifiName)
                self.timerCount = 0
                self.timerActionType = .queryDeviceOnline
                self.progress.setProgress(0.75, animated: true)
            }else{
                let value = Float((timerCount % 25) < 25 ? (Float(timerCount)/25)*0.4 : 0.4)
                self.progress.setProgress(0.2 + value, animated: true)
                self.startSendUDPFrame()
            }
        case .queryDeviceOnline:
            self.progress.setProgress(0.85, animated: true)
            queryDeviceInfo()
        case .addDeviceSuccess:
            timer?.fireDate = Date.distantFuture
            jumpToNameSetView()
        }
    }
    private func storeWifiInfo() {
        userDefaults.setValue(wifiName, forKey: WiFi_KEY())
        userDefaults.setValue(wifiPsw, forKey: wifiName)
    }
    lazy var placeholderPic: UIImageView = {
        let tempView = UIImageView.init()
        tempView.contentMode = .scaleToFill
        var imgsAry = [Any]()
        for i in 1...39 {
            let image = UIImage(named:"lianjie_"+String(i))
            imgsAry.append(image!)
        }
        tempView.animationImages = imgsAry as? [UIImage]
        tempView.animationDuration = 1.0
        tempView.animationRepeatCount = 0
        view.addSubview(tempView)
        return tempView
    }()
    lazy var fristTipLabel: UILabel = {
        let tempView = UILabel.init()
        tempView.text = StellarLocalizedString("ALERT_MATCHING") + "..."
        tempView.textColor = STELLAR_COLOR_C4
        tempView.font = STELLAR_FONT_T18
        view.addSubview(tempView)
        return tempView
    }()
    lazy var secondTipLabel: UILabel = {
        let tempView = UILabel.init()
        tempView.text = StellarLocalizedString("ALERT_NO_POWEROFF_MATCHING")
        tempView.numberOfLines = 0
        tempView.textAlignment = .center
        tempView.textColor = STELLAR_COLOR_C6
        tempView.font = STELLAR_FONT_T14
        view.addSubview(tempView)
        return tempView
    }()
    lazy var progress: UIProgressView = {
        let tempView = UIProgressView()
        tempView.trackTintColor = STELLAR_COLOR_C8
        tempView.progressTintColor = STELLAR_COLOR_C10
        return tempView
    }()
}
extension DeviceConnectWIFiController: StellarLocalRequsetDelegte {
    func didSendWifiSuccess(mac: String) {
        if mac == self.mac {
            isSendWifiSuccess = true
        }
    }
    func didReceivedSendTokenSuccess(mac: String) {
        if mac == self.mac {
            isSendTokenSuccess = true
        }
    }
    func didReceivedSendServerSuccess(mac: String) {
        if mac == self.mac {
            isSendServerSuccess = true
        }
    }
    func didReceivedStartRegisterSuccess(mac: String) {
        if mac == self.mac {
            isStartRegisterSuccess = true
        }
    }
}