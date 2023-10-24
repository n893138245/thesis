import UIKit
enum clickedType {
    case repet
    case afterEnd
}
class CreatStreamerHeaderView: UIView {
    let disposeBag = DisposeBag()
    var clickForTypeBlock: ((_ type :clickedType ,_ title: String) -> Void)?
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupActions()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupUI() {
        addSubview(leftArrow)
        addSubview(rightArrow)
        addSubview(loopButton)
        addSubview(afterEndButton)
        let leftCenterX = (frame.width/4.0)+10
        let rightCenterX = (frame.width*3/4.0)-10
        let leftTitleLabel = UILabel.init()
        leftTitleLabel.font = STELLAR_FONT_T12
        leftTitleLabel.textColor = STELLAR_COLOR_C6
        leftTitleLabel.text = "执行次数"
        addSubview(leftTitleLabel)
        leftTitleLabel.snp.makeConstraints {
            $0.centerX.equalTo(leftCenterX)
            $0.bottom.equalTo(loopButton.snp.top).offset(-4.fit)
        }
        afterEndLabel.snp.makeConstraints {
            $0.centerY.equalTo(leftTitleLabel)
            $0.centerX.equalTo(rightCenterX)
        }
        afterEndButton.snp.makeConstraints {
            $0.centerX.equalTo(rightCenterX-3.fit)
            $0.bottom.equalTo(self).offset(-48.fit)
        }
        loopButton.snp.makeConstraints {
            $0.centerX.equalTo(leftCenterX-3.fit)
            $0.bottom.equalTo(self).offset(-48.fit)
        }
        leftArrow.snp.makeConstraints {
            $0.centerY.equalTo(loopButton)
            $0.left.equalTo(loopButton.snp.right).offset(8.fit)
        }
        rightArrow.snp.makeConstraints {
            $0.centerY.equalTo(loopButton)
            $0.left.equalTo(afterEndButton.snp.right).offset(8.fit)
        }
    }
    private func setupActions() {
        loopButton.rx.tap.subscribe(onNext:{ [weak self] in
            self?.clickForTypeBlock!(.repet,self?.loopButton.currentTitle ?? "")
            self?.rotateArrow(withType: .repet, closed: false)
        }).disposed(by: disposeBag)
        afterEndButton.rx.tap.subscribe(onNext:{ [weak self] in
            self?.clickForTypeBlock!(.afterEnd,self?.afterEndButton.currentTitle ?? "")
            self?.rotateArrow(withType: .afterEnd, closed: false)
        }).disposed(by: disposeBag)
    }
    func rotateArrow(withType :clickedType, closed: Bool) {
        let angle: CGFloat = closed == true ? CGFloat(Double.pi*2) : CGFloat(-Double.pi)
        let transform = CGAffineTransform.init(rotationAngle: angle)
        if withType == .afterEnd {
            UIView.animate(withDuration: 0.25) {
                self.rightArrow.transform = transform
            }
        }else {
            UIView.animate(withDuration: 0.25) {
                self.leftArrow.transform = transform
            }
        }
    }
    private lazy var leftArrow: UIImageView = {
        let tempView = UIImageView.init(image: UIImage(named: "drop-down"))
        return tempView
    }()
    private lazy var rightArrow: UIImageView = {
        let tempView = UIImageView.init(image: UIImage(named: "drop-down"))
        return tempView
    }()
    lazy var loopButton: UIButton = {
        let tempView = UIButton.init(type: .custom)
        tempView.setTitle("循环执行", for: .normal)
        tempView.titleLabel?.font = STELLAR_FONT_MEDIUM_T14
        tempView.setTitleColor(STELLAR_COLOR_C4, for: .normal)
        return tempView
    }()
    lazy var afterEndButton: UIButton = {
        let tempView = UIButton.init(type: .custom)
        tempView.setTitle("关闭灯光", for: .normal)
        tempView.titleLabel?.font = STELLAR_FONT_MEDIUM_T14
        tempView.setTitleColor(STELLAR_COLOR_C4, for: .normal)
        return tempView
    }()
    lazy var afterEndLabel: UILabel = {
        let rightTitleLabel = UILabel.init()
        rightTitleLabel.font = STELLAR_FONT_T12
        rightTitleLabel.textColor = STELLAR_COLOR_C6
        rightTitleLabel.text = "执行结束后"
        addSubview(rightTitleLabel)
        return rightTitleLabel
    }()
}