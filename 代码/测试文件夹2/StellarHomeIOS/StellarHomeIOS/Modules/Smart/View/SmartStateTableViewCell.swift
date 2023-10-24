import UIKit
enum SmartState{
    case kInit
    case kSmartOn
    case kSmartOffWithEqipment
    case kSmartOffWithNoEqipment
}
class SmartStateTableViewCell: UITableViewCell {
    @IBOutlet weak var contentBgView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var controlLabel: UILabel!
    @IBOutlet weak var useEquipmentButton: UIButton!
    @IBOutlet weak var equipmentSwitch: UISwitch!
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var smartStateBgView: UIView!
    @IBOutlet weak var smartStateBgImageView: UIImageView!
    var pushToDetailBlock: (() ->Void)?
    var switchBlock: ((_ on: Bool) ->Void)?
    var timeStopBlock: (() ->Void)?
    var layerFrame = CGRect.zero
    var switchFrame = CGRect.zero
    var myState:SmartState = .kInit{
        didSet{
            if oldValue ==  myState{
                return
            }
            setupCell(state:myState)
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
        layerFrame = CGRect(x: 0, y: 0, width: kScreenWidth - 20, height: 146)
        switchFrame = CGRect(x: kScreenWidth - 20 - 16 - 51, y: 156 - 31 - 36, width: 51, height: 31)
        useEquipmentButton.setTitle(StellarLocalizedString("SMART_USE"), for: .normal)
    }
    func setupData(model: IntelligentDetailModel, index: Int) {
        titleLabel.text = model.name
        functionView.setData(model: model) 
        if model.condition.first != nil { 
            setupCellStatus(model: model, index: index)
        }
        if !model.available { 
            setupCell(state: .kSmartOffWithNoEqipment)
            return
        }
        if model.enable { 
            setupCell(state: .kSmartOn)
        }else { 
            setupCell(state: .kSmartOffWithEqipment)
        }
    }
    func openBgAnimation(model :IntelligentDetailModel, index: Int,finished: (() ->Void)?) {
        if smartStateBgView.layer.sublayers == nil {
            let gradientLayer = UIColor.ss.drawWithColors(colors: [UIColor.init(hexString: "#0945B0").cgColor,UIColor.init(hexString: "#1878D7").cgColor])
            gradientLayer.frame = layerFrame
            smartStateBgView.layer.insertSublayer(gradientLayer, at: 0)
        }
        self.smartStateBgView.isHidden = false
        self.smartStateBgImageView.isHidden = false
        self.smartStateBgView.frame = self.switchFrame
        self.smartStateBgImageView.frame = self.switchFrame
        UIView.animate(withDuration: 0.25, animations: {
            self.smartStateBgView.frame = self.layerFrame
            self.smartStateBgImageView.frame = self.layerFrame
            self.smartStateBgImageView.layer.cornerRadius = 8
            self.smartStateBgView.layer.cornerRadius = 8
            self.smartStateBgImageView.layer.masksToBounds = true
            self.smartStateBgView.layer.masksToBounds = true
        }) { (_) in
            finished?()
        }
    }
    func closeBgAnimation(finished: (() ->Void)?) {
        self.smartStateBgImageView.isHidden = false
        UIView.animate(withDuration: 0.25, animations: {
            self.smartStateBgImageView.layer.cornerRadius = 8
            self.smartStateBgView.layer.cornerRadius = 8
            self.smartStateBgImageView.layer.masksToBounds = true
            self.smartStateBgView.layer.masksToBounds = true
            self.smartStateBgView.frame = self.switchFrame
            self.smartStateBgImageView.frame = self.switchFrame
            self.titleLabel.textColor = STELLAR_COLOR_C4
            self.controlLabel.textColor = STELLAR_COLOR_C6
            self.controlLabel.alpha = 1
            self.moreButton.setImage(UIImage.init(named: "icon_details_white"), for: .normal)
        }) { (_) in
            finished?()
        }
    }
    private func setupCellStatus(model: IntelligentDetailModel, index: Int) {
        guard let condition = model.condition.first else {
            return
        }
        switch condition.type {
        case .countdown:
            if !model.enable || !model.available {
                controlLabel.text = "\(StellarLocalizedString("SMART_CUTDOWN")) \(condition.params.countdownTime/60)\(StellarLocalizedString("SMART_MIN_LATER"))"
            }
        case .timing:
            let timeString = IntelligentDetailModel.getDayStringWithWeekDays(week: condition.params.weekdays)
            controlLabel.text = "\(timeString) \(condition.params.time)"
        default:
            break
        }
    }
    private func setupCell(state:SmartState)
    {
        switch state {
        case .kInit:
            break
        case .kSmartOn: 
            smartStateBgView.frame = layerFrame
            smartStateBgImageView.frame = layerFrame
            smartStateBgImageView.isHidden = false
            if smartStateBgView.layer.sublayers == nil {
                let gradientLayer = UIColor.ss.drawWithColors(colors: [UIColor.init(hexString: "#0945B0").cgColor,UIColor.init(hexString: "#1878D7").cgColor])
                gradientLayer.frame = layerFrame
                smartStateBgView.layer.insertSublayer(gradientLayer, at: 0)
            }
            equipmentSwitch.isHidden = false
            equipmentSwitch.isOn = true
            useEquipmentButton.isHidden = true
            smartStateBgView.isHidden = false
            titleLabel.textColor = STELLAR_COLOR_C3
            controlLabel.textColor = STELLAR_COLOR_C3
            controlLabel.alpha = 0.6
            moreButton.setImage(UIImage.init(named: "icon_details_black"), for: .normal)
            break
        case .kSmartOffWithEqipment: 
            smartStateBgView.layer.sublayers = []
            titleLabel.textColor = STELLAR_COLOR_C4
            controlLabel.textColor = STELLAR_COLOR_C6
            controlLabel.alpha = 1
            equipmentSwitch.isHidden = false
            equipmentSwitch.isOn = false
            useEquipmentButton.isHidden = true
            moreButton.setImage(UIImage.init(named: "icon_details_white"), for: .normal)
            smartStateBgView.isHidden = true
            smartStateBgImageView.isHidden = true
            break
        case .kSmartOffWithNoEqipment: 
            smartStateBgView.layer.sublayers = []
            titleLabel.textColor = STELLAR_COLOR_C4
            controlLabel.textColor = STELLAR_COLOR_C6
            controlLabel.alpha = 1
            equipmentSwitch.isHidden = true
            useEquipmentButton.isHidden = false
            useEquipmentButton.setTitle(StellarLocalizedString("SMART_EDIT"), for: .normal)
            useEquipmentButton.setTitleColor(STELLAR_COLOR_C4, for: .normal)
            useEquipmentButton.titleLabel?.font = STELLAR_FONT_BOLD_T14
            useEquipmentButton.backgroundColor = STELLAR_COLOR_C3
            moreButton.setImage(UIImage.init(named: "icon_details_white"), for: .normal)
            smartStateBgView.isHidden = true
            smartStateBgImageView.isHidden = true
            break
        }
    }
    private func setupViews(){
        smartStateBgView.isHidden = true
        titleLabel.textColor = STELLAR_COLOR_C4
        titleLabel.font = STELLAR_FONT_BOLD_T18
        titleLabel.text = StellarLocalizedString("SMART_TIME_SWITCH")
        controlLabel.textColor = STELLAR_COLOR_C6
        controlLabel.font = STELLAR_FONT_T14
        controlLabel.alpha = 1
        controlLabel.text = "工作日   22:00关灯"
        equipmentSwitch.isHidden = true
        useEquipmentButton.setTitle(StellarLocalizedString("SMART_EDIT"), for: .normal)
        useEquipmentButton.setTitleColor(STELLAR_COLOR_C4, for: .normal)
        useEquipmentButton.titleLabel?.font = STELLAR_FONT_BOLD_T14
        useEquipmentButton.backgroundColor = STELLAR_COLOR_C3
        moreButton.setImage(UIImage.init(named: "icon_details_white"), for: .normal)
        addSubview(functionView)
        functionView.snp.makeConstraints { (make) in
            make.left.equalTo(25)
            make.centerY.equalTo(useEquipmentButton.snp.centerY)
            make.height.equalTo(32)
            make.right.equalTo(equipmentSwitch.snp.left)
        }
    }
    lazy var functionView:SmartFunctionDetailView = {
        let view = SmartFunctionDetailView()
        return view
    }()
    @IBAction func moreAction(_ sender: Any) {
        pushToDetailBlock?()
    }
    @IBAction func useEquipmentAction(_ sender: Any) {
        pushToDetailBlock?()
    }
    @IBAction func switchAction(_ sender: Any) {
        if let sw = sender as? UISwitch {
            switchBlock?(sw.isOn)
        }
    }
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}