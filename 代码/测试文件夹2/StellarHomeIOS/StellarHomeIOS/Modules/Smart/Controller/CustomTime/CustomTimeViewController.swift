class CustomTimeViewController: BaseViewController {
    var condition:IntelligentDetailModelCondition?
    var dateArr: [(aDate: String, isSelected: Bool)] = [(StellarLocalizedString("SMART_MONDAY"),false),
                   (StellarLocalizedString("SMART_TUESDAY"),false),
                   (StellarLocalizedString("SMART_WEDNESDAY"),false),
                   (StellarLocalizedString("SMART_THURSDAY"),false),
                   (StellarLocalizedString("SMART_FRIDAY"),false),
                   (StellarLocalizedString("SMART_SATURDAY"),false),
                   (StellarLocalizedString("SMART_SUNDAY"),false)]
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = STELLAR_COLOR_C3
        loadSubViews()
        loadDate()
        setupRx()
    }
    func loadSubViews(){
        loadHead()
        loadTabelView()
    }
    func loadDate(){
        guard let weekdays = condition?.params.weekdays else {
            return
        }
        for day in weekdays {
            if day == 0 {
                var date = dateArr[6]
                date.isSelected = true
                dateArr[6] = date
            }else {
                var date = dateArr[day - 1]
                date.isSelected = true
                dateArr[day - 1] = date
            }
        }
        tableview.reloadData()
    }
    func loadHead(){
        navView.myState = .kNavBlack
        navView.setTitle(title: StellarLocalizedString("SMART_CUSTOM"))
        navView.backclickBlock = {
            self.navigationController?.popViewController(animated: true)
        }
        view.addSubview(navView)
        navView.frame = CGRect.init(x: 0, y: getAllVersionSafeAreaTopHeight(), width: kScreenWidth, height: NAVVIEW_HEIGHT_DISLODGE_SAFEAREA)
    }
    func loadTabelView(){
        tableview.register(UINib(nibName: "LeftLabelTableViewCell", bundle: nil), forCellReuseIdentifier: "LeftLabelTableViewCell")
        tableview.frame = CGRect.init(x: 0, y: navView.frame.maxY, width: kScreenWidth, height: 64*7)
        view.addSubview(tableview)
        view.addSubview(bottomBtn)
        bottomBtn.frame = CGRect.init(x: kScreenWidth/2.0 - 146.fit, y: kScreenHeight - BOTTOMBUTTON_BOTTOM_CONSTRAINT, width: 290.fit , height: 46.fit)
    }
    private func setupRx() {
        bottomBtn.rx.tap
            .subscribe(onNext: { [weak self] (_) in
                guard let copy_self = self else {
                    return
                }
                for vc in copy_self.navigationController?.children ?? [] {
                    if vc is ChooseAppointOpenViewController {
                        guard let conditionVc = vc as? ChooseAppointOpenViewController else {
                            return
                        }
                        conditionVc.condition?.type = .timing
                        var weekdays = [Int]()
                        var index = 0
                        for model in copy_self.dateArr {
                            if model.isSelected {
                                var dayRepresentative = index + 1
                                if dayRepresentative == 7 {
                                    dayRepresentative = 0
                                }
                                weekdays.append(dayRepresentative)
                            }
                            index += 1
                        }
                        weekdays.sort(by: { $0 < $1})
                        conditionVc.condition?.params.weekdays = weekdays
                        conditionVc.condition?.type = .timing
                        conditionVc.loadData()
                        copy_self.navigationController?.popToViewController(conditionVc, animated: true)
                        break
                    }
                }
            }).disposed(by: disposeBag)
    }
    lazy var tableview:UITableView = {
        let view = UITableView(frame: CGRect.zero, style: .plain)
        view.backgroundColor = STELLAR_COLOR_C3
        view.delegate = self
        view.dataSource = self
        view.separatorInset = UIEdgeInsets.init(top: 0, left: kScreenWidth, bottom: 0, right: 0)
        return view
    }()
    lazy var navView:NavView = {
        let view = NavView()
        return view
    }()
    lazy var bottomBtn:StellarButton = {
        let view = StellarButton()
        view.setTitle(StellarLocalizedString("COMMON_CONFIRM"), for: .normal)
        view.style = .normal
        return view
    }()
}
extension CustomTimeViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dateArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LeftLabelTableViewCell", for: indexPath) as! LeftLabelTableViewCell
        cell.leftLabel.text = dateArr[indexPath.row].0
        if dateArr[indexPath.row].1 {
            cell.setSelected()
        }else{
            cell.setUnselected()
        }
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var selectModel = dateArr[indexPath.row]
        selectModel.1 = !selectModel.1
        dateArr[indexPath.row] = selectModel
        var weekdays = [Int]()
        var index = 0
        for model in dateArr{
            if model.1{
                weekdays.append(index)
            }
            index += 1
        }
        if weekdays.count == 0{
            bottomBtn.isEnabled = false
        }else{
            bottomBtn.isEnabled = true
        }
        tableView.reloadData()
    }
}