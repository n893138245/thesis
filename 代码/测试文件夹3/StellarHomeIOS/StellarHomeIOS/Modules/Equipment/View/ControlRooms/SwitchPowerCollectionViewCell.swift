import UIKit
enum PowerStatus {
    case powerOn
    case powerOff
    case unknowing
}
class SwitchPowerCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var rightLine: UIView!
    @IBOutlet weak var bottomLine: UIView!
    @IBOutlet weak var powerButton: UIButton!
    @IBOutlet weak var roomNameLabel: UILabel!
    var powerBlock: (() ->Void)?
    var powerStatus: PowerStatus = .unknowing {
        didSet {
            if powerStatus == oldValue {
                return
            }
            setupStatus()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }
    @IBAction func powerAction(_ sender: Any) {
        powerBlock?()
    }
    private func setupStatus() {
        if powerStatus == .powerOff {
            powerButton.setImage(UIImage(named: "battery_switch"), for: .normal)
            powerButton.setImage(UIImage(named: "icon_power_gray"), for: .disabled)
        }else {
            powerButton.setImage(UIImage(named: "icon_power_red33"), for: .normal)
            powerButton.setImage(UIImage(named: "icon_power_red33_s"), for: .disabled)
        }
    }
    func startLoading() {
        powerButton.ss.startNVIndicator(color: STELLAR_COLOR_C10)
    }
    func showSuccess(finished: (() ->Void)?) {
        powerButton.ss.stopNVIndicator()
        powerButton.setImage(UIImage(named: "icon_power_red_h"), for: .normal)
        powerButton.ss.showSuccessCheck {
            if self.powerStatus == .powerOn {
                self.powerStatus = .powerOff
                if self.roomNameLabel.text == "全部关灯" {
                    self.roomNameLabel.text = "全部开灯"
                }
            }else {
                self.powerStatus = .powerOn
                if self.roomNameLabel.text == "全部开灯" {
                    self.roomNameLabel.text = "全部关灯"
                }
            }
            finished?()
        }
    }
    func stopLoading() {
        powerButton.ss.stopNVIndicator()
    }
    private func setupViews() {
        roomNameLabel.text = "书房"
        roomNameLabel.font = STELLAR_FONT_T14
        roomNameLabel.textColor = STELLAR_COLOR_C4
        powerStatus = .powerOff
    }
    func setData(model: (power: RoomPowerModel, isOnline: Bool), currentRow: Int, dataCount: Int ) {
        powerStatus = model.power.powerStatus
        if model.power.roomName == "全部" {
            roomNameLabel.text = powerStatus == .powerOff ? "全部开灯":"全部关灯"
        }else {
            roomNameLabel.text = model.power.roomName
            if model.isOnline {
                roomNameLabel.textColor = STELLAR_COLOR_C4
            }else {
                roomNameLabel.textColor = STELLAR_COLOR_C4.withAlphaComponent(0.4)
                powerButton.setImage(UIImage(named: "icon_power_gray"), for: .normal)
            }
        }
        hideenLines(currentRow: currentRow, dataCount: dataCount)
    }
    private func hideenLines(currentRow: Int, dataCount: Int) {
        if (currentRow + 1) % 3 == 0 || currentRow == dataCount - 1 {
            rightLine.isHidden = true
        }else {
            rightLine.isHidden = false
        }
        if dataCount < 4 { 
            bottomLine.isHidden = true
        }else {
            let line = (currentRow) / 3 
            let lastLine = dataCount / 3 
            if dataCount % 3 == 0 { 
                if line == lastLine - 1 { 
                    bottomLine.isHidden = true
                }else {
                    bottomLine.isHidden = false
                }
            }else { 
                if line == lastLine { 
                    bottomLine.isHidden = true
                }else {
                    bottomLine.isHidden = false
                }
            }
        }
    }
}