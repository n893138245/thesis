import UIKit
class ScanView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
       setupUI()
    }
    var type: DeviceType = .unknown {
        didSet {
            if type == .hub {
                tipLabel.text = StellarLocalizedString("ADD_DEVICE_SEARCHING_GATEWAY") + "..."
            }else {
               tipLabel.text = StellarLocalizedString("ADD_DEVICE_SEARCHING_DEVICE") + "..."
            }
        }
    }
    private func setupUI() {
        layer.cornerRadius = 12.fit
        clipsToBounds = true
        backgroundColor = STELLAR_COLOR_C3
        scanView.snp.makeConstraints {
            $0.top.equalTo(self.snp.top).offset(100.fit)
            $0.centerX.equalTo(self)
            $0.width.equalTo(336.fit)
            $0.height.equalTo(336.fit)
        }
        tipLabel.snp.makeConstraints {
            $0.bottom.equalTo(self.snp.bottom).offset(-72.fit)
            $0.centerX.equalTo(self.snp.centerX)
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func stopScan() {
       scanView.stopScan()
    }
    private lazy var scanView: StallerScanView = {
    let tempView = StallerScanView.init(frame: CGRect(x: 0, y: 0, width: 336.fit, height: 336.fit))
    addSubview(tempView)
    return tempView
    }()
   private lazy var tipLabel: UILabel = {
        let tempView = UILabel.init()
        tempView.textColor = STELLAR_COLOR_C6
        tempView.font = STELLAR_FONT_T16
        addSubview(tempView)
        return tempView
    }()
    deinit {
        stopScan()
    }
}