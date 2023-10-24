import UIKit
enum BleConnectStatus {
    case poweroff 
    ,failure 
    ,connecting 
    ,unkonwning
}
class BleConnectBottomView: UIView {
    private let disposeBag = DisposeBag()
    var clickBlock: (() ->Void)?
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(connectButton)
        addSubview(titleLabel)
        connectButton.backgroundColor = UIColor.ss.rgbColor(240, 242, 245)
        connectButton.snp.makeConstraints {
            $0.centerX.equalTo(self)
            $0.top.equalTo(self).offset(24.fit)
            $0.width.height.equalTo(50.fit)
        }
        connectButton.layer.cornerRadius = 25.fit
        connectButton.clipsToBounds = true
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(connectButton.snp.bottom).offset(8)
            $0.centerX.equalTo(self)
        }
        connectButton.rx.tap.subscribe(onNext:{ [weak self] in
            self?.clickBlock?()
        }).disposed(by: disposeBag)
    }
    var myConnectStatus: BleConnectStatus = .unkonwning {
        didSet {
          setBleStatus()
        }
    }
    private func setBleStatus() {
        layoutIfNeeded() 
        switch myConnectStatus {
        case .connecting:
            connectButton.ss.startActivityIndicator()
            connectButton.backgroundColor = UIColor.ss.rgbColor(240, 242, 245)
            titleLabel.textColor = STELLAR_COLOR_C6
            titleLabel.text = StellarLocalizedString("EQUIPMENT_CONNECTING")
        case .failure:
            connectButton.ss.stopActivityIndicator(isShowImage: false, isShowTitle: false)
            connectButton.setImage(UIImage(named: "btn_light_refresh"), for: .normal)
            connectButton.setImage(UIImage(named: "btn_light_refresh_s"), for: .highlighted)
            connectButton.backgroundColor = .clear
            titleLabel.textColor = STELLAR_COLOR_C1
            titleLabel.text = StellarLocalizedString("EQUIPMENT_RETRY")
        case .poweroff:
            connectButton.ss.stopActivityIndicator(isShowImage: false, isShowTitle: false)
            connectButton.setImage(UIImage(named: "icon_light_bluetooth.png"), for: .normal)
            connectButton.backgroundColor = .clear
            titleLabel.textColor = STELLAR_COLOR_C6
            titleLabel.text = StellarLocalizedString("EQUIPMENT_POWER_OFF")
        case .unkonwning:
            break
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    lazy var titleLabel: UILabel = {
        let tempView = UILabel()
        tempView.font = STELLAR_FONT_T14
        return tempView
    }()
    lazy var connectButton: UIButton = {
        let tempView = UIButton(type: .custom)
        return tempView
    }()
}