import UIKit
class CountdownView: UIView {
    @IBOutlet weak var pickerView: UIPickerView!
    var minNum = 1
    var dataList = [Int]()
    class func CountdownView() ->CountdownView {
        let view = Bundle.main.loadNibNamed("CountdownView", owner: nil, options: nil)?.last as! CountdownView
        return view
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    private func setupView(){
        pickerView.delegate = self
        for second in 1...60 {
            dataList.append(second)
        }
        pickerView.reloadAllComponents()
    }
}
extension CountdownView:UIPickerViewDelegate,UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataList.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        minNum = dataList[row]
        return "\(dataList[row])\(StellarLocalizedString("SMART_MIN"))"
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
       minNum = dataList[row]
    }
}