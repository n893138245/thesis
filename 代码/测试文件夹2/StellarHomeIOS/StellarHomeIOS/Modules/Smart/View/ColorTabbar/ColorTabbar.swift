import UIKit
class ColorTabbar: UIView {
    private let resList: [(String,String)] = [
        ("btn_light_color_",StellarLocalizedString("SMART_COLOR_CHANGE")),
        ("btn_light_streamer_",StellarLocalizedString("SMART_STREAMER"))
    ]
    private let TAG_START = 1000
    var selectIndexBlock: ((_ row :Int) -> Void)?
    var currentModeBlock: ((_ mode :DetailChildState) -> Void)?
    private var selectedButton: UIButton?
    private var colorItem: DetailItem?
    private var streamerItem: DetailItem?
    var currentLight: LightModel? {
        didSet {
            setupViews(light: currentLight!)
        }
    }
    var currentAction: ExecutionModel? {
        didSet {
            setupViews(action: currentAction!)
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupUI() {
        addSubview(topLine)
        backgroundColor = STELLAR_COLOR_C3
        let width = frame.width/2
        for i in 0...1 {
            let item = DetailItem.init(frame: CGRect(x: width*CGFloat(i), y: 0, width: width, height: frame.size.height))
            item.tabGorupCount = 2
            item.setImage(UIImage(named: resList[i].0 + "n"), for: .normal)
            item.setImage(UIImage(named: resList[i].0 + "n"), for: .highlighted)
            item.setImage(UIImage(named: resList[i].0 + "s"), for: .selected)
            item.setTitle(resList[i].1, for: .normal)
            item.setTitle(resList[i].1, for: .highlighted)
            item.setTitleColor(STELLAR_COLOR_C1, for: .selected)
            item.setTitleColor(STELLAR_COLOR_C6, for: .normal)
            item.titleLabel?.font = STELLAR_FONT_T14
            item.tag = TAG_START + i
            item.addTarget(self, action: #selector(selectItemWithIndex), for: .touchUpInside)
            addSubview(item)
            if i == 0 {
                colorItem = item
            }else {
                streamerItem = item
            }
        }
    }
    private func setupViews(light: LightModel) {
        if light.status.currentMode == .color || light.status.currentMode == .cct {
            selectedButton = colorItem
            colorItem?.isSelected = true
        }else if currentLight?.status.currentMode == .internalScene { 
            selectedButton = streamerItem
            streamerItem?.isSelected = true
        }
    }
    private func setupViews(action: ExecutionModel) {
        guard let detail = action.execution.first else {
            return
        }
        switch detail.command {
        case .color,.colorTemperature:
            selectedButton = colorItem
            colorItem?.isSelected = true
        case .internalScene:
            selectedButton = streamerItem
            streamerItem?.isSelected = true
        default:
            break
        }
    }
    @objc private func selectItemWithIndex(button: DetailItem) {
        if selectedButton != nil {
            if selectedButton!.isEqual(button) {
                return
            }
            selectedButton!.isSelected = false
        }
        button.isSelected = true
        selectedButton = button
        let tag = button.tag
        if tag == streamerItem?.tag {
            currentModeBlock?(.streamer)
        }else {
            currentModeBlock?(.color)
        }
    }
    lazy var topLine: UIView = {
        let line = UIView.init(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 1))
        line.backgroundColor = STELLAR_COLOR_C8
        return line
    }()
}