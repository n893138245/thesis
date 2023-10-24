import UIKit
class ElectricView: UIView {
    var electricValue: CGFloat = 0 {
        didSet {
            if electricValue < 0 || electricValue > 1 {
               return
            }
            if electricValue == 0.01 {
                electricImage.image = UIImage(named: "electricity_1")
                electricLabel.text = "1%"
                return
            }
            if electricValue == 1.0 {
                electricImage.image = UIImage(named: "electricity_100")
                electricLabel.text = "100%"
                return
            }
            if electricValue > 0.01 && electricValue <= 0.09 {
               electricImage.image = UIImage(named: "electricity_2~9")
            }
            if electricValue > 0.09 && electricValue <= 0.19 {
                electricImage.image = UIImage(named: "electricity_10~19")
            }
            if electricValue > 0.19 && electricValue <= 0.29 {
                electricImage.image = UIImage(named: "electricity_20~29")
            }
            if electricValue > 0.29 && electricValue <= 0.39 {
                electricImage.image = UIImage(named: "electricity_30~39")
            }
            if electricValue > 0.39 && electricValue <= 0.49 {
                electricImage.image = UIImage(named: "electricity_40~49")
            }
            if electricValue > 0.49 && electricValue <= 0.59 {
                electricImage.image = UIImage(named: "electricity_50~59")
            }
            if electricValue > 0.59 && electricValue <= 0.69 {
                electricImage.image = UIImage(named: "electricity_60~69")
            }
            if electricValue > 0.69 && electricValue <= 0.79 {
                electricImage.image = UIImage(named: "electricity_70~79")
            }
            if electricValue > 0.79 && electricValue <= 0.89 {
                electricImage.image = UIImage(named: "electricity_80~89")
            }
            if electricValue > 0.89 && electricValue <= 0.99 {
                electricImage.image = UIImage(named: "electricity_90~99")
            }
            electricLabel.text = "\(Int(electricValue*100))%"
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        setupUI()
    }
    private func setupUI() {
        electricLabel.snp.makeConstraints {
            $0.right.equalTo(self)
            $0.top.equalTo(self)
        }
        electricImage.snp.makeConstraints {
            $0.right.equalTo(electricLabel.snp.left).offset(-4.fit)
            $0.centerY.equalTo(electricLabel)
        }
    }
    private lazy var electricImage: UIImageView = {
        let tempView = UIImageView.init(image: UIImage(named: "electricity_1"))
        addSubview(tempView)
        return tempView
    }()
    private lazy var electricLabel: UILabel = {
        let tempView = UILabel.init()
        tempView.font = STELLAR_FONT_NUMBER_T12
        tempView.text = "1%"
        tempView.textColor = STELLAR_COLOR_C5
        addSubview(tempView)
        return tempView
    }()
}