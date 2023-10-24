import UIKit
import IQKeyboardManagerSwift
class CodeVerifyCell: UITableViewCell {
    @IBOutlet weak var mTitleLabel: UILabel!
    var verificateCodeBlock: (() ->Void)?
    var reSendCodeBlock: (() ->Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        initSubViews()
        IQKeyboardManager.shared.enableAutoToolbar = false
    }
    private func initSubViews() {
        contentView.addSubview(sendCodeView)
        sendCodeView.snp.makeConstraints {
            $0.width.equalTo(kScreenWidth-18)
            $0.centerX.equalTo(contentView)
            $0.height.equalTo(160)
            $0.top.equalTo(contentView).offset(40)
        }
        sendCodeView.verificateCodeBlock = { [weak self] in
            self?.verificateCodeBlock?()
        }
        sendCodeView.clickBlock = { [weak self] in
            self?.sendCodeView.clear()
            self?.reSendCodeBlock?()
        }
    }
    func clear() {
        sendCodeView.clear()
        sendCodeView.textfield.becomeFirstResponder()
    }
    func reStartTimer() {
        sendCodeView.initCountDownClock()
    }
    func removeTimer() {
        if let timer = sendCodeView.timeTask {
            SSTimeManager.shared.removeTask(task: timer)
        }
    }
    static func initWithXIb() -> UITableViewCell{
        let arrayOfViews = Bundle.main.loadNibNamed("CodeVerifyCell", owner: nil, options: nil)
        guard let firstView = arrayOfViews?.first as? UITableViewCell else {
            return UITableViewCell()
        }
        return firstView
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    lazy var sendCodeView:SendCodeView = {
        let view = SendCodeView.SendCodeView()
        return view
    }()
    deinit {
        removeTimer()
    }
}