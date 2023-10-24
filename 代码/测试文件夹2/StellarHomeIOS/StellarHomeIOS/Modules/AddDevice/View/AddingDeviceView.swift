import UIKit
class AddingDeviceView: UIView {
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var showAnimationView: UIView!
    var circleProgressView:CircleProgressView = CircleProgressView(frame: .zero)
    var timeTask:SSTimeTask?
    var currentState:AddDeviceState = .wait {
        didSet{
            if currentState == .wait {
                stateLabel.text = StellarLocalizedString("ADD_DEVICE_WAIT_ADDING") + "..."
            }else if currentState == .adding {
                stateLabel.text = StellarLocalizedString("ADD_DEVICE_ESTABLISH_CONNECTION") + "..."
            }else if currentState == .fail {
                stateLabel.text = StellarLocalizedString("ALERT_ADD_FAIL")
            }else if currentState == .success {
                stateLabel.text = StellarLocalizedString("ALERT_ADD_SUCCESS")
            }
        }
    }
    class func AddingDeviceView() ->AddingDeviceView {
        let view = Bundle.main.loadNibNamed("AddingDeviceView", owner: nil, options: nil)?.last as! AddingDeviceView
        return view
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }
    private func setupViews(){
        stateLabel.textColor = STELLAR_COLOR_C6
        stateLabel.font = STELLAR_FONT_T12
        nameLabel.textColor = STELLAR_COLOR_C4
        nameLabel.font = STELLAR_FONT_T16
        circleProgressView.frame = showAnimationView.bounds
        circleProgressView.backgroundColor = UIColor.white
        circleProgressView.isHidden = true
        showAnimationView.addSubview(circleProgressView)
        stateLabel.text = StellarLocalizedString("ADD_DEVICE_WAIT_ADDING") + "..."
    }
    func setData(device: (BasicDeviceModel,AddDeviceState)){
        currentState = device.1
        nameLabel.text = device.0.name
    }
    func showAddingState(){
        if currentState == .wait {
            currentState = .adding
            circleProgressView.isHidden = false
            timeTask = SSTimeManager.shared.addTaskWith(timeInterval: 1, isRepeat: true) { task in
                if self.timeTask != nil{
                    if self.timeTask!.repeatCount == 5 {
                        self.circleProgressView.setProgress(81)
                    }else if self.timeTask!.repeatCount > 5{
                        if self.circleProgressView.progress < 97{
                            let randomProgress = Int(randomCustom(min: 1, max: 2))
                            let needTOSetProgress = self.circleProgressView.progress + randomProgress
                            self.circleProgressView.setProgress(needTOSetProgress)
                        }else{
                            self.timeTask?.isStop = true
                        }
                    }else{
                        let randomProgress = Int(randomCustom(min: 1, max: 20))
                        let needTOSetProgress = self.circleProgressView.progress + randomProgress
                        self.circleProgressView.setProgress(needTOSetProgress)
                    }
                }
            }
        }
    }
    func showAddedSuccessState(){
        if currentState == .adding {
            if timeTask != nil{
                SSTimeManager.shared.removeTask(task: timeTask!)
            }
            currentState = .success
            timeTask?.isStop = true
            circleProgressView.setProgress(100) {
                self.circleProgressView.isHidden = true
                StellarCheckHUD.showSuccessNotDismiss(inView: self.showAnimationView)
            }
        }
    }
    func showAddedFailState(){
        if currentState == .adding {
            if timeTask != nil{
                SSTimeManager.shared.removeTask(task: timeTask!)
            }
            currentState = .fail
            timeTask?.isStop = true
            circleProgressView.isHidden = true
            StellarCheckHUD.showFailNotDismiss(inView: self.showAnimationView, hideBlock: nil)
        }
    }
}