import UIKit
enum cellType {
    case normal
    case add
}
class CreatStreamerCell: UITableViewCell {
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var brightnessLabel: UILabel!
    @IBOutlet weak var blueLine: UIView!
    @IBOutlet weak var colorTitleLabel: UILabel!
    var type: cellType = .normal {
        didSet {
            switch type {
            case .normal:
                addLabel.isHidden = true
                blueLine.isHidden = false
            case .add:
                addLabel.isHidden = false
                blueLine.isHidden = true
            }
        }
    }
    var object: AddStreamerLocalModel? {
        didSet {
            if let color = object?.color {
                colorView.isHidden = false
                colorView.backgroundColor = color
                colorTitleLabel.isHidden = false
            }else {
                colorView.isHidden = true
                colorTitleLabel.isHidden = true
            }
            timeLabel.text = object?.time
            let bri = Int( object!.brightness! * 100 )
            brightnessLabel.text = "\(bri)%"
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        colorView.layer.cornerRadius = 12.5
        colorView.clipsToBounds = true
        bgView.layer.shadowOffset = CGSize(width: 0, height: 3)
        bgView.layer.shadowColor = UIColor.black.cgColor
        bgView.layer.shadowOpacity = 0.08
        bgView.layer.cornerRadius = 6
        bgView.layer.shadowRadius = 6
        contentView.addSubview(addLabel)
        addLabel.snp.makeConstraints {
            $0.top.equalTo(bgView).offset(2)
            $0.bottom.equalTo(bgView).offset(-2)
            $0.left.equalTo(bgView).offset(2)
            $0.right.equalTo(bgView).offset(-2)
        }
        brightnessLabel.font = STELLAR_FONT_NUMBER_T22
        brightnessLabel.textColor = STELLAR_COLOR_C4
        timeLabel.font = STELLAR_FONT_NUMBER_T22
        timeLabel.textColor = STELLAR_COLOR_C6
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    lazy var addLabel: UILabel = {
        let tempView = UILabel.init()
        tempView.text = "添加"
        tempView.font = STELLAR_FONT_MEDIUM_T18
        tempView.textColor = STELLAR_COLOR_C5
        tempView.textAlignment = .center
        tempView.backgroundColor = .white
        return tempView
    }()
}