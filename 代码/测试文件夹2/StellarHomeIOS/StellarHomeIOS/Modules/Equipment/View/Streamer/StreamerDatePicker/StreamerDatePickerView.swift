import UIKit
class StreamerDatePickerView: UIView {
    @IBOutlet weak var bottomConstranit: NSLayoutConstraint!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var selectedBgView: UIView!
    private var selectedString = "00:01.0"
    private var minString = "00"
    private var secString = "01"
    private var msecString = "000"
    var comfrimBlock:((_ selectedStr: String) -> Void)?
    @IBAction func confrimClicked(_ sender: UIButton) {
        if let block = comfrimBlock {
            block(selectedString)
        }
        dissmiss()
    }
    private var dataList: [Array<String>] = []
    var currentDate:String = "" {
        didSet {
            selectedString = currentDate
            let bigArr = currentDate.components(separatedBy: ":")
            let secArr = bigArr[1].components(separatedBy: ".")
            let min = bigArr[0]
            minString = min
            let sec = secArr[0]
            secString = sec
            let pMsec = secArr[1]
            let msec = pMsec+"00"
            msecString = msec
            if let rowInMin = dataList[0].firstIndex(of: min) {
                pickerView.selectRow(rowInMin, inComponent: 0, animated: false)
            }
            if let rowInSec = dataList[1].firstIndex(of: sec) {
                pickerView.selectRow(rowInSec, inComponent: 1, animated: false)
            }
            if let rowInMsec = dataList[2].firstIndex(of: msec) {
                pickerView.selectRow(rowInMsec, inComponent: 2, animated: false)
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        setupData()
        pickerView.delegate = self
        pickerView.dataSource = self
        setupViews()
    }
    private func setupData() {
        var minList:[String] = []
        for min in 0...59 {
            if min <= 9 {
                minList.append("0\(min)")
            }else {
                minList.append("\(min)")
            }
        }
        dataList.append(minList)
        var secList:[String] = []
        for sec in 0...59 {
            if sec <= 9 {
                secList.append("0\(sec)")
            }else {
                secList.append("\(sec)")
            }
        }
        dataList.append(secList)
        var msecList:[String] = []
        for msec in 0...9 {
            msecList.append("\(msec)00")
        }
        dataList.append(msecList)
    }
    private func setupViews() {
        selectedBgView.layer.cornerRadius = 22
        selectedBgView.clipsToBounds = true
        let width = (kScreenWidth-40)/4
        let minLabel = UILabel.init()
        minLabel.text = "分"
        minLabel.font = STELLAR_FONT_MEDIUM_T14
        addSubview(minLabel)
        minLabel.snp.makeConstraints {
            $0.left.equalTo(self).offset(width-10)
            $0.centerY.equalTo(pickerView)
        }
        let secLabel = UILabel.init()
        secLabel.text = "秒"
        secLabel.font = STELLAR_FONT_MEDIUM_T14
        addSubview(secLabel)
        secLabel.snp.makeConstraints {
            $0.left.equalTo(self.snp.centerX)
            $0.centerY.equalTo(pickerView)
        }
        let msecLabel = UILabel.init()
        msecLabel.text = "毫秒"
        msecLabel.font = STELLAR_FONT_MEDIUM_T14
        addSubview(msecLabel)
        msecLabel.snp.makeConstraints {
            $0.left.equalTo(self).offset(width*3+60)
            $0.centerY.equalTo(pickerView)
        }
    }
    class func StreamerDatePickerView() ->StreamerDatePickerView {
        let view = Bundle.main.loadNibNamed("StreamerDatePickerView", owner: nil, options: nil)?.last as! StreamerDatePickerView
        StellarAppManager.sharedManager.currVc!.view.addSubview(view)
        view.frame = StellarAppManager.sharedManager.currVc!.view.bounds
        return view
    }
    private func dissmiss() {
        self.bottomConstranit.constant = 266
        UIView.animate(withDuration: 0.25, animations: {
            self.layoutIfNeeded()
        }) { (finished) in
            if finished {
                self.subviews.forEach { (subView) in
                    subView.removeFromSuperview()
                }
                self.removeFromSuperview()
            }
        }
    }
}
extension StreamerDatePickerView: UIPickerViewDelegate,UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return dataList.count
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        let list = dataList[component]
        return list.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let list = dataList[component]
        return list[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            minString = dataList[component][row]
        }else if component == 1 {
            secString = dataList[component][row]
        }else if component == 2 {
            msecString = dataList[component][row]
        }
        let pMsec = msecString.prefix(1)
        selectedString = minString+":"+secString+"."+pMsec
    }
}