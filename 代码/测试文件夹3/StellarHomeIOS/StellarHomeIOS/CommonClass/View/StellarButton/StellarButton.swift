import UIKit
enum StellarButtonStyle {
    case normal 
    case gray 
    case border 
    case red 
    case white
}
class StellarButton: UIButton {
    var tempImage:UIImage?
    var style: StellarButtonStyle = .normal{
        didSet{
            self.setupUI()
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.clipsToBounds = true
        self.layer.cornerRadius = self.frame.size.height/2.0
    }
    override func awakeFromNib() {
        setupUI()
    }
    func setupUI() {
        self.titleLabel?.font = STELLAR_FONT_T18
        switch style {
        case .normal:
            self.setTitleColor(STELLAR_COLOR_C3, for: .normal)
            self.setBackgroundImage(UIColor.ss.getImageWithColor(color: STELLAR_COLOR_C1), for: .normal)
//            self.setBackgroundImage(UIColor.ss.getImageWithColor(color: UIColor.ss.rgbColor(r: 30, g: 78, b: 189)), for: .highlighted)
            self.setBackgroundImage(UIColor.ss.getImageWithColor(color: UIColor.ss.rgbColor(r: 60, g: 179, b: 113)), for: .highlighted)
            self.setBackgroundImage(UIColor.ss.getImageWithColor(color: UIColor.ss.rgbColor(r: 232, g: 236, b: 246)), for: .disabled)
        case .gray:
            self.setTitleColor(STELLAR_COLOR_C2, for: .normal)
            self.setBackgroundImage(UIColor.ss.getImageWithColor(color: STELLAR_COLOR_C9), for: .normal)
            self.setBackgroundImage(UIColor.ss.getImageWithColor(color: UIColor.ss.rgbColor(r: 224, g: 226, b: 233)), for: .highlighted)
        case .border:
            self.layer.borderColor = STELLAR_COLOR_C7.cgColor
            self.layer.borderWidth = 1.0
            self.setTitleColor(STELLAR_COLOR_C1, for: .normal)
            self.setTitleColor(STELLAR_COLOR_C3, for: .highlighted)
            self.setBackgroundImage(UIColor.ss.getImageWithColor(color: .clear), for: .normal)
            self.setBackgroundImage(UIColor.ss.getImageWithColor(color: STELLAR_COLOR_C1), for: .highlighted)
        case .red:
            self.setTitleColor(STELLAR_COLOR_C3, for: .normal)
            self.setBackgroundImage(UIColor.ss.getImageWithColor(color: STELLAR_COLOR_C2), for: .normal)
            self.setBackgroundImage(UIColor.ss.getImageWithColor(color: UIColor.ss.rgbColor(r: 167, g: 39, b: 31)), for: .highlighted)
            self.setBackgroundImage(UIColor.ss.getImageWithColor(color: UIColor.ss.rgbColor(r: 247, g: 236, b: 235)), for: .disabled)
        case .white:
            self.setTitleColor(STELLAR_COLOR_C4, for: .normal)
            self.titleLabel?.font = STELLAR_FONT_T14
        }
    }
    private var tempTitle: String?
    func startIndicator() {
        self.isUserInteractionEnabled = false
        if style == .white {
            tempImage = imageView?.image
            setImage(UIImage.init(named: ""), for: .normal)
        }
        tempTitle = self.currentTitle
        self.setTitle("", for: .normal)
        indicator.startAnimating()
        self.addSubview(indicator)
        self.bringSubviewToFront(indicator)
    }
    func stopIndicator() {
        if style == .white {
            setImage(tempImage, for: .normal)
        }
        self.isUserInteractionEnabled = true
        if let tempStr = tempTitle {
            self.setTitle(tempStr, for: .normal)
        }
        let targetView = self.subviews.first { (view) -> Bool in
            return view.tag == 100
        }
        targetView?.removeFromSuperview()
    }
    lazy var indicator:UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView.init(frame: CGRect.init(x: 0, y: 0, width: 25, height: 25))
        indicator.center = CGPoint.init(x: self.bounds.size.width/2, y: self.bounds.size.height/2)
        indicator.tag = 100
        indicator.color = self.titleLabel?.textColor
        return indicator
    }()
}
