import UIKit
class BrightnessViewController: BaseViewController {
    var lampModel: LightModel? {
        didSet {
          brightnessView.light = lampModel
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    func setupUI() {
        view.backgroundColor = STELLAR_COLOR_C3
        view.addSubview(brightnessView)
        brightnessView.snp.makeConstraints {
            $0.centerY.equalTo(self.view).offset(-60.fit)
            $0.centerX.equalTo(self.view)
            $0.width.equalTo(187.fit)
            $0.height.equalTo(366.fit)
        }
    }
    lazy var brightnessView: TheBrightnessView = {
        let tempView = TheBrightnessView.init(frame: CGRect(x: 0, y: 0, width: 187.fit, height: 366.fit))
        return tempView
    }()
}