import UIKit
class StallerHeaderScanView: UIView {
    init(frame: CGRect, title: String) {
        super.init(frame: frame)
        titleLabel.text = title
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        radarView.snp.makeConstraints {
            $0.centerY.equalTo(self)
            $0.left.equalTo(self).offset(87.fit)
            $0.width.equalTo(27.fit)
            $0.height.equalTo(27.fit)
        }
        titleLabel.snp.makeConstraints {
            $0.centerY.equalTo(self)
            $0.left.equalTo(radarView.snp.right).offset(16.fit)
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func startScan() {
        radarView.startScan()
    }
    func stopScan() {
        radarView.stopScan()
    }
    lazy var titleLabel: UILabel = {
        let tempView = UILabel.init()
        tempView.font = STELLAR_FONT_T14
        tempView.textColor = UIColor.init(hexString: "#D1D3DB")
        addSubview(tempView)
        return tempView
    }()
    lazy var radarView: RadarView = {
        let temView = RadarView.init(frame: CGRect(x: 0, y: 0, width: 27.fit, height: 27.fit))
        addSubview(temView)
        return temView
    }()
}