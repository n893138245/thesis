import UIKit
enum StreamerColorState {
    case red
    case yellow
    case green
    case cyan
    case blue
    case purple
    case white
    case noColor
}
class StreamerCell: UICollectionViewCell {
    @IBOutlet weak var bgImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var selectedButton: UIButton! 
    @IBOutlet weak var playButton: UIButton! 
    var moreBlock: (() -> Void)?
    var selectBlock: (() -> Void)?
    @IBAction func clickMore(_ sender: UIButton) {
        if let more = moreBlock {
            more()
        }
    }
    @IBAction func clickSelect(_ sender: UIButton) {
        if let select = selectBlock {
            select()
        }
    }
    var colorState :StreamerColorState = .noColor {
        didSet {
            bgView.layer.sublayers = []
            if nameLabel.textColor != STELLAR_COLOR_C3 {
                nameLabel.textColor = STELLAR_COLOR_C3
            }
            switch colorState {
            case .red:
                addSublayerWithColor(colors: [UIColor.init(hexString: "#D50000").cgColor,UIColor.init(hexString: "#EF9A9A").cgColor])
            case .yellow:
                addSublayerWithColor(colors: [UIColor.init(hexString: "#FBC02C").cgColor,UIColor.init(hexString: "#FFF176").cgColor])
            case .green:
                addSublayerWithColor(colors: [UIColor.init(hexString: "#5CC64A").cgColor,UIColor.init(hexString: "#A5D6A7").cgColor])
            case .cyan:
                addSublayerWithColor(colors: [UIColor.init(hexString: "#00B8D3 ").cgColor,UIColor.init(hexString: "#B3EBF2").cgColor])
            case .blue:
                addSublayerWithColor(colors: [UIColor.init(hexString: "#2D70EC").cgColor,UIColor.init(hexString: "#81D4FB").cgColor])
            case .purple:
                addSublayerWithColor(colors: [UIColor.init(hexString: "#AA00FF ").cgColor,UIColor.init(hexString: "#CE93D8").cgColor])
            case .white:
                addSublayerWithColor(colors: [UIColor.init(hexString: "#EFEEEE").cgColor,UIColor.init(hexString: "FAF9FB").cgColor])
                nameLabel.textColor = STELLAR_COLOR_C5
            case .noColor:
                break
            }
        }
    }
    var isSamrt: Bool = false {
        didSet {
            if isSamrt {
                selectedButton.isHidden = false
                playButton.isHidden = true
            }else {
                selectedButton.isHidden = true
                playButton.isHidden = false
            }
        }
    }
    var recommendObject: RecommendModel? = nil {
        didSet {
            colorState = recommendObject!.colorState!
            if isSamrt {
                (recommendObject?.selected)! ? selectedButton.setImage(UIImage(named: "icon_streamer_white28_s"), for: .normal) : selectedButton.setImage(UIImage(named: "icon_streamer_white28"), for: .normal)
            }else {
                (recommendObject?.selected)! ? playButton.setImage(UIImage(named: "icon_streamer_pause"), for: .normal) : playButton.setImage(UIImage(named: "icon_streamer_more28"), for: .normal)
            }
        }
    }
    var myCreatObject: MyStreamerModel? = nil {
        didSet {
            var colors :[CGColor] = []
            if let fristColor = myCreatObject?.fristColor {
                colors.append(fristColor.cgColor)
            }
            if let lastColor = myCreatObject?.lastColor {
                colors.append(lastColor.cgColor)
            }
            if colors.count > 0 {
                addSublayerWithColor(colors: colors)
            }
            nameLabel.text = myCreatObject?.name
            if isSamrt {
                (myCreatObject?.selected)! ? selectedButton.setImage(UIImage(named: "icon_streamer_white28_s"), for: .normal) : selectedButton.setImage(UIImage(named: "icon_streamer_white28"), for: .normal)
            }else {
                (myCreatObject?.selected)! ? playButton.setImage(UIImage(named: "icon_streamer_pause"), for: .normal) : playButton.setImage(UIImage(named: "icon_streamer_more28"), for: .normal)
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.backgroundColor = .clear
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = 10.fit
        contentView.addSubview(bgView)
        bgView.snp.makeConstraints {
            $0.left.equalTo(contentView)
            $0.right.equalTo(contentView)
            $0.top.equalTo(contentView)
            $0.bottom.equalTo(contentView)
        }
        contentView.sendSubviewToBack(bgView)
        nameLabel.font = STELLAR_FONT_T16
        nameLabel.textColor = STELLAR_COLOR_C3
        layer.shadowOffset = CGSize(width: 0, height: 3.fit)
        layer.shadowOpacity = 0.15
        layer.shadowColor = UIColor.black.cgColor
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
        layer.cornerRadius = 10.fit
        layer.shadowRadius = 6.fit
        layer.masksToBounds = false
    }
    private func addSublayerWithColor(colors :[CGColor]) {
        let gradientLayer = UIColor.ss.drawWithColors(colors: colors)
        gradientLayer.frame = CGRect(x: 0, y: 0, width: kScreenWidth/2-20.fit-11.fit/2, height: 98.fit)
        bgView.layer.insertSublayer(gradientLayer, at: 0)
    }
    lazy var bgView: UIView = {
        let tempView = UIView.init()
        tempView.layer.cornerRadius = 10.fit
        tempView.layer.masksToBounds = true
        return tempView
    }()
}