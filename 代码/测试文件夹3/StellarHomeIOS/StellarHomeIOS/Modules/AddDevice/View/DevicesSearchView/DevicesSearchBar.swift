import UIKit
class DevicesSearchBar: UIView {
    private let bag: DisposeBag = DisposeBag()
    var editStateBlock:((Bool) -> Void)?
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    private func setupUI() {
        backgroundColor = STELLAR_COLOR_C9
        layer.cornerRadius = 12
        layer.masksToBounds = true
        addSubview(magnifyingGlassImageView)
        addSubview(textfield)
        magnifyingGlassImageView.snp.makeConstraints {
            $0.left.equalTo(16)
            $0.centerY.equalTo(self)
            $0.width.equalTo(12)
            $0.height.equalTo(12)
        }
        textfield.snp.makeConstraints {
            $0.left.equalTo(magnifyingGlassImageView.snp.right).offset(10)
            $0.centerY.equalTo(magnifyingGlassImageView)
            $0.right.equalTo(20)
        }
        textfield.rx.controlEvent([.editingChanged]).asObservable().subscribe(onNext: { [weak self] _ in
            self?.editStateBlock?(self?.textfield.text?.count != 0)
        }).disposed(by: bag)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private lazy var magnifyingGlassImageView: UIImageView = {
        let tempView = UIImageView()
        tempView.image = UIImage.init(named: "magnifyingGlass")
        return tempView
    }()
    lazy var textfield: UITextField = {
        let tempView = UITextField.init()
        let placeholserAttributes = [NSAttributedString.Key.foregroundColor:STELLAR_COLOR_C6,NSAttributedString.Key.font:STELLAR_FONT_T13]
        tempView.attributedPlaceholder = NSAttributedString(string: "请输入设备型号或关键字",attributes: placeholserAttributes)
        tempView.textColor = STELLAR_COLOR_C4
        tempView.font = STELLAR_FONT_T13
        return tempView
    }()
}