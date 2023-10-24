import UIKit
class StellarDatePickerView: UIView {
    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var rightBtn: UIButton!
    @IBOutlet weak var datePick: UIDatePicker!
    var selectedTime:String{
        get{
            let date = datePick.date
            return String.ss.dateConvertString(date: date)
        }
    }
    var rightClick:(()-> Void)? = nil
    class func StellarDatePickerView() ->StellarDatePickerView {
        let view = Bundle.main.loadNibNamed("StellarDatePickerView", owner: nil, options: nil)?.last as! StellarDatePickerView
        view.frame = CGRect.init(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight)
        if #available(iOS 13.4, *) {
            view.datePick.preferredDatePickerStyle = .wheels
        }
        return view
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    private func setupView(){
        backgroundColor = UIColor.clear
        leftLabel.text = StellarLocalizedString("SMART_START_TIME")
        leftLabel.textColor = UIColor.init(hexString: "#B7B7B7")
        leftLabel.font = STELLAR_FONT_T17
        rightBtn.setTitleColor(UIColor.init(hexString: "#007AFF"), for: .normal)
        rightBtn.titleLabel?.font = STELLAR_FONT_T17
        rightBtn.setTitle(StellarLocalizedString("COMMON_CONFIRM"), for: .normal)
        datePick.datePickerMode = .time
    }
    func show(time:String? = nil){
        isHidden = false
        if time != nil {
            datePick.date = Date.ss.stringConvertDate(string: time!)
        }
    }
    func hidden(){
        isHidden = true
    }
    @IBAction func rightBtnAction(_ sender: Any) {
        hidden()
        rightClick?()
    }
}