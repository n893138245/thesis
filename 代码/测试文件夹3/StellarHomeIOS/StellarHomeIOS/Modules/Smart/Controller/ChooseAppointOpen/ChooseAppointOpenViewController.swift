import UIKit
class ChooseAppointOpenViewController: BaseViewController {
    var dataArr:Array<CoupleModel> = []
    var condition:IntelligentDetailModelCondition?
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = STELLAR_COLOR_C3
        loadSubViews()
        loadData()
    }
    func loadData(){
        dataArr.removeAll()
        if condition == nil{
            condition = IntelligentDetailModelCondition()
            condition?.type = .timing
            condition?.params.time = String.ss.dateConvertString(date: Date())
        }
        let model1 = CoupleModel()
        model1.name = StellarLocalizedString("SMART_TIME")
        model1.content = condition?.params.time == "" ? String.ss.dateConvertString(date: Date()) : (condition?.params.time)!
        dataArr.append(model1)
        let model3 = CoupleModel()
        model3.name = StellarLocalizedString("SMART_REPEAT")
        model3.content = IntelligentDetailModel.getDayStringWithWeekDays(week: condition?.params.weekdays)
        dataArr.append(model3)
        tableview.reloadData()
    }
    func loadSubViews(){
        navView.myState = .kNavBlack
        navView.backclickBlock = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        view.addSubview(navView)
        navView.frame = CGRect.init(x: 0, y: getAllVersionSafeAreaTopHeight(), width: kScreenWidth, height: NAVVIEW_HEIGHT_DISLODGE_SAFEAREA)
        let headView = UIView()
        headView.frame = CGRect.init(x: 0, y: 0, width: kScreenWidth, height: 82)
        titleLabel.frame = CGRect.init(x: 20.fit, y: 8.fit, width: kScreenWidth - 20.fit, height: 42)
        titleLabel.text = StellarLocalizedString("SMART_AT_TIME")
        headView.addSubview(titleLabel)
        tableview.register(UINib(nibName: "LeftRightLabelCell", bundle: nil), forCellReuseIdentifier: "LeftRightLabelCell")
        tableview.tableHeaderView = headView
        tableview.frame = CGRect.init(x: 0, y: navView.frame.maxY, width: kScreenWidth, height: kScreenHeight)
        view.addSubview(tableview)
        view.addSubview(bottomBtn)
        bottomBtn.frame = CGRect.init(x: kScreenWidth/2.0 - 146.fit, y: kScreenHeight - BOTTOMBUTTON_BOTTOM_CONSTRAINT, width: 290.fit , height: 46.fit)
        bottomBtn.rx.tap.subscribe(onNext: { [weak self] (_) in
            for vc in self?.navigationController?.children ?? []{
                if vc is CreateSmartViewController{
                    guard let conditionVc = vc as? CreateSmartViewController else{
                        return
                    }
                    let pCondition = IntelligentDetailModelCondition()
                    pCondition.params.time = (self?.dataArr.first!.content)!
                    pCondition.type = .timing
                    if self?.dataArr[1].content == StellarLocalizedString("SMART_ONLY_ONECE") {
                        pCondition.params.weekdays = nil
                    }else if self?.dataArr[1].content == StellarLocalizedString("SMART_EVERY_DAY") {
                        pCondition.params.weekdays = [0,1,2,3,4,5,6]
                    }else if self?.dataArr[1].content == StellarLocalizedString("SMART_WORKING_DAY") {
                        pCondition.params.weekdays = [1,2,3,4,5]
                    }else { 
                        if let temp = self?.condition?.params.weekdays {
                            pCondition.params.weekdays = temp
                        }
                    }
                    pCondition.params.countdownTime = 0
                    NotificationCenter.default.post(name: .Smart_SetConditionsComplete, object: nil, userInfo: ["info":pCondition])
                    self?.navigationController?.popToViewController(conditionVc, animated: true)
                    break
                }
            }
        }).disposed(by: disposeBag)
        view.addSubview(nDatePicker)
        nDatePicker.hidden()
        nDatePicker.rightClick = { [weak self] in
            guard let model = self?.dataArr.first else { return }
            guard let time = self?.nDatePicker.selectedTime else { return }
            model.content = time
            self?.dataArr[0] = model
            self?.condition?.params.time = model.content
            self?.tableview.reloadData()
        }
    }
    lazy var tableview:UITableView = {
        let view = UITableView(frame: CGRect.zero, style: .plain)
        view.backgroundColor = STELLAR_COLOR_C3
        view.delegate = self
        view.dataSource = self
        view.separatorInset = UIEdgeInsets.init(top: 0, left: kScreenWidth, bottom: 0, right: 0)
        view.separatorColor = UIColor.clear
        return view
    }()
    lazy var navView:NavView = {
        let view = NavView()
        return view
    }()
    lazy var titleLabel:UILabel = {
        let label = UILabel()
        label.textColor = STELLAR_COLOR_C4
        label.font = STELLAR_FONT_BOLD_T30
        return label
    }()
    lazy var bottomBtn:StellarButton = {
        let view = StellarButton()
        view.setTitle(StellarLocalizedString("COMMON_CONFIRM"), for: .normal)
        view.style = .normal
        return view
    }()
    lazy var nDatePicker:StellarDatePickerView = {
        let datePicker = StellarDatePickerView.StellarDatePickerView()
        return datePicker
    }()
    override var preferredStatusBarStyle: UIStatusBarStyle
    {
        return .default
    }
}
extension ChooseAppointOpenViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LeftRightLabelCell", for: indexPath) as! LeftRightLabelCell
        let model = dataArr[indexPath.row]
        cell.setTitles(leftString: model.name, rightString: model.content)
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            nDatePicker.show(time: self.dataArr[0].content)
        }else if indexPath.row == 1{
            let alertController: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
            alertController.addAction(UIAlertAction(title:StellarLocalizedString("SMART_ONLY_ONECE"), style: UIAlertAction.Style.default, handler: { (UIAlertAction) in
                let model = self.dataArr[1]
                model.content = StellarLocalizedString("SMART_ONLY_ONECE")
                self.dataArr[1] = model
                self.condition?.params.weekdays = nil
                self.tableview.reloadData()
            }))
            alertController.addAction(UIAlertAction(title:StellarLocalizedString("SMART_EVERY_DAY"), style: UIAlertAction.Style.default, handler: { (UIAlertAction) in
                let model = self.dataArr[1]
                model.content = StellarLocalizedString("SMART_EVERY_DAY")
                self.dataArr[1] = model
                self.condition?.params.weekdays = [0,1,2,3,4,5,6]
                self.tableview.reloadData()
            }))
            alertController.addAction(UIAlertAction(title:StellarLocalizedString("SMART_WORKING_DAY"), style: UIAlertAction.Style.default, handler: { (UIAlertAction) in
                let model = self.dataArr[1]
                model.content = StellarLocalizedString("SMART_WORKING_DAY")
                self.dataArr[1] = model
                self.condition?.params.weekdays = [1,2,3,4,5]
                self.tableview.reloadData()
            }))
            alertController.addAction(UIAlertAction(title:StellarLocalizedString("SMART_CUSTOM"), style: UIAlertAction.Style.default, handler: { (UIAlertAction) in
                let vc = CustomTimeViewController()
                vc.condition = self.condition
                self.navigationController?.pushViewController(vc, animated: true)
            }))
            alertController.addAction(UIAlertAction(title:StellarLocalizedString("COMMON_CANCEL"), style:
                UIAlertAction.Style.cancel,handler:{ (UIAlertAction) in
            }))
            present(alertController, animated: true, completion: nil)
        }
    }
}