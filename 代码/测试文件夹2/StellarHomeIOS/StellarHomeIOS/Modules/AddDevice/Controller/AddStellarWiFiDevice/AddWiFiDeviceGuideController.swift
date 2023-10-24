import UIKit
class AddWiFiDeviceGuideController: AddDeviceBaseViewController {
    private let socket: StellarLocalRequset = StellarLocalRequset.sharedInstance
    private var mac: String?
    private var timer: Timer?
    var wifiName: String = ""
    var wifiPsw: String = ""
    var deviceApSsid: String = ""
    var deviceToken: String = ""
    var addDetailModel: AddDeviceDetailModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fd_interactivePopDisabled = true
        setupUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.rx.notification(UIApplication.didBecomeActiveNotification).subscribe(onNext: { [weak self] (nitify) in
            self?.timer?.fireDate = Date()
        }).disposed(by: disposeBag)
        NotificationCenter.default.rx.notification(UIApplication.willResignActiveNotification).subscribe(onNext: { [weak self] (nitify) in
            self?.timer?.fireDate = Date.distantFuture
        }).disposed(by: disposeBag)
        timer = Timer.scheduledTimer(withTimeInterval: 1, block: { (t) in
            self.checkWiFi()
        }, repeats: true)
        timer?.fireDate = Date()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
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
        let desc = StellarLocalizedString("ADD_DEVICE_COOECT_WIFI_RETURN_APP")
        let descLabelW = cardView.bounds.width - 80.fit
        let descLabelH = NSString(string: desc).boundingRect(with: CGSize(width: descLabelW, height: CGFloat(MAXFLOAT)), options: [.usesFontLeading, .usesLineFragmentOrigin], attributes: [NSAttributedString.Key.font: STELLAR_FONT_T15 as Any], context: nil).size.height
        let secondDescLabel = UILabel(frame: CGRect(x: 40.fit, y: 40.fit, width: descLabelW, height: descLabelH))
        secondDescLabel.numberOfLines = 0
        secondDescLabel.text = desc
        secondDescLabel.textColor = UIColor(hexString: "#1D2739")
        secondDescLabel.font = STELLAR_FONT_T15
        cardView.addSubview(secondDescLabel)
        let deviceWiFiView = UIImageView(image: UIImage(named: "device_wifi"))
        deviceWiFiView.frame = CGRect(x: 59.fit, y: 145.fit, width: 240.fit, height: 196.fit)
        deviceWiFiView.contentMode = .scaleAspectFit
        cardView.addSubview(deviceWiFiView)
        cardView.addSubview(deviceWiFiLabel)
        cardView.addSubview(targetWiFiLabel)
        cardView.addSubview(currentWiFiLabel)
    }
    func checkWiFi() {
        guard let ssid = getWifiInfo().ssid else {
            deviceWiFiLabel.text = StellarLocalizedString("ADD_DEVICE_NOT_CONNECT_WIFI")
            currentWiFiLabel.text = StellarLocalizedString("ADD_DEVICE_CURRENT_WIFI") + ":" + StellarLocalizedString("ADD_DEVICE_DISCOOECT")
            return
        }
        if ssid.isEmpty {
            deviceWiFiLabel.text = StellarLocalizedString("ADD_DEVICE_NOT_CONNECT_WIFI")
            currentWiFiLabel.text = StellarLocalizedString("ADD_DEVICE_CURRENT_WIFI") + ":" + StellarLocalizedString("ADD_DEVICE_DISCOOECT")
        }else{
            deviceWiFiLabel.text = "\(ssid)"
            currentWiFiLabel.text = StellarLocalizedString("ADD_DEVICE_TARGET_WIFI") + "：\(ssid)"
            if ssid.prefix(6) == "Sansi-" {
                deviceApSsid = ssid
                socket.delegate = self
                socket.getDeviceInfo()
            }
        }
    }
    lazy var targetWiFiLabel: UILabel = {
        let targetWiFiLabel = UILabel(frame: CGRect(x: 40.fit, y: 477.fit, width: cardView.bounds.width - 80.fit, height: 44.fit))
        targetWiFiLabel.backgroundColor = UIColor(hexString: "#F0FBF3")
        targetWiFiLabel.text = StellarLocalizedString("ADD_DEVICE_TARGET_WIFI") + "：Sansi-XXXXXXXXXXXX"
        targetWiFiLabel.textAlignment = .center
        targetWiFiLabel.font = STELLAR_FONT_T14
        targetWiFiLabel.textColor = UIColor(hexString: "#2E8C5F")
        targetWiFiLabel.layer.cornerRadius = targetWiFiLabel.bounds.height*0.5
        targetWiFiLabel.layer.masksToBounds = true
        return targetWiFiLabel
    }()
    lazy var currentWiFiLabel: UILabel = {
        let currentWiFiLabel = UILabel(frame: CGRect(x: 40.fit, y: 417.fit, width: cardView.bounds.width - 80.fit, height: 44.fit))
        currentWiFiLabel.backgroundColor = UIColor(hexString: "#F5F9FF")
        currentWiFiLabel.text = StellarLocalizedString("ADD_DEVICE_CURRENT_WIFI") + "："
        currentWiFiLabel.textAlignment = .center
        currentWiFiLabel.font = STELLAR_FONT_T14
        currentWiFiLabel.textColor = STELLAR_COLOR_C1
        currentWiFiLabel.layer.cornerRadius = currentWiFiLabel.bounds.height*0.5
        currentWiFiLabel.layer.masksToBounds = true
        return currentWiFiLabel
    }()
    lazy var deviceWiFiLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 72.fit, y: 230.fit, width: 221.fit, height: 24.fit))
        label.text = "\(321)"
        label.font = STELLAR_FONT_T13
        label.textColor = UIColor(hexString: "#1D2739")
        return label
    }()
}
extension AddWiFiDeviceGuideController: StellarLocalRequsetDelegte {
    func didReceivedBulbInfo(mac: String, connType: StellarDeviceConnectionType, sVer: UInt8, hVer: UInt8, devType: StellarDeviceType, sn: String?) {
        if self.mac == nil {
            self.mac = mac
            let vc = DeviceConnectWIFiController()
            vc.mac = mac
            vc.wifiName = self.wifiName
            vc.wifiPsw = self.wifiPsw
            vc.sn = sn!
            vc.deviceApSsid = self.deviceApSsid
            vc.deviceToken = self.deviceToken
            vc.addDetailModel = self.addDetailModel
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}