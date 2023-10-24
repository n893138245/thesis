import UIKit
class SelectDateViewController: BaseViewController {
    var device: BasicDeviceModel?
    private let defaultDateTextColor = STELLAR_COLOR_C5
    private var dataList: [Date] = []
    private var hourList: [(hour: String, isHaveHistorty: Bool)] = []
    private var queryTimeList: [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRX()
        setupUI()
        setupData()
    }
    private func setupUI() {
        setupBaseUI()
        setupCalender()
        setupHourView()
    }
    private func setupData() {
        setTodayData()
        setCalenderData()
    }
    private func setTodayData() {
        for h in 1...24 {
            h < 10 ?  hourList.append((hour: "0\(h):00", isHaveHistorty: false)) : hourList.append((hour: "\(h):00", isHaveHistorty: false))
        }
        let time = getStartAndEndTime(date: Date())
        netQueryDatas(startTime: time.start, endTime: time.end)
    }
    private func setCalenderData() {
        self.dataList.append(today)
        for i in 1...7 {
            let fDate = Calendar.current.date(byAdding: .day, value: -i, to: today) ?? Date()
            let time = getStartAndEndTime(date: fDate)
            DevicesStore.instance.getLocationsExistanceByTime(sn: device?.sn ?? "", startTime: time.start, endTime: time.end) { (dateList) in
                if dateList.count > 0 {
                    self.dataList.append(fDate)
                }
                self.setDefautCalenderCell(position: .current, date: fDate)
                self.setDefautCalenderCell(position: .previous, date: fDate)
                self.setDefautCalenderCell(position: .next, date: fDate)
                self.calender.reloadData()
            } failure: { (_) in
            }
        }
    }
    private func setDefautCalenderCell(position: FSCalendarMonthPosition,date: Date) {
        let cell = self.calender.cell(for: date, at: position)
        cell?.preferredFillDefaultColor = STELLAR_COLOR_C8
        cell?.preferredTitleDefaultColor = defaultDateTextColor
        cell?.configureAppearance()
    }
    private func updateHourView() {
        for index in 0..<hourList.count {
            hourList[index].isHaveHistorty = false
        }
        collectionView.reloadData()
        var dates = [String]()
        for dateSring in self.queryTimeList {
            let hs = String.ss.localTimeWithUTCString(UTCtimeString: dateSring)
            let hArray = hs.components(separatedBy: ":")
            guard let h = hArray.first else {
                return
            }
            if !dates.contains("\(h):00") {
                dates.append("\(h):00")
            }
        }
        for _ in 0..<hourList.count {
            for h in dates {
                if let index = hourList.firstIndex(where: {$0.hour == h}) {
                    hourList[index].isHaveHistorty = true
                }
            }
        }
        collectionView.reloadData()
    }
    private func setupBaseUI() {
        view.backgroundColor = STELLAR_COLOR_C3
        view.addSubview(navBar)
        view.addSubview(hourTitleLabel)
    }
    private func setupCalender() {
        view.addSubview(calender)
    }
    private func setupHourView() {
        view.addSubview(collectionView)
        collectionView.frame = CGRect(x: 20, y: 321.fit + 32 + kNavigationH + 46, width: kScreenWidth - 40, height: 180)
    }
    private func setupRX() {
        navBar.backButton.rx.tap
            .subscribe(onNext:{ [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }).disposed(by: disposeBag)
    }
    private func getStartAndEndTime(date: Date) ->(start: String,end: String) {
        let calender = Calendar.current
        let dateString = "\(calender.component(.year, from: date))-\(calender.component(.month, from: date))-\(calender.component(.day, from: date))"
        let startTime = dateString + " 00:00:00"
        let endString = dateString + " 23:59:59"
        return (String.ss.getUtcString(with: startTime),String.ss.getUtcString(with: endString))
    }
    private func netQueryDatas(startTime: String, endTime: String) {
        StellarProgressHUD.showHUD()
        DevicesStore.instance.getLocationsExistanceByTime(sn: device?.sn ?? "", startTime: startTime, endTime: endTime) { [weak self] (utcDateList) in
            StellarProgressHUD.dissmissHUD()
            self?.queryTimeList.removeAll()
            self?.queryTimeList.append(contentsOf: utcDateList)
            self?.updateHourView()
        } failure: { [weak self] (_) in
            StellarProgressHUD.dissmissHUD()
            self?.queryTimeList.removeAll()
            self?.updateHourView()
        }
    }
    private lazy var hourTitleLabel: UILabel = {
        let tempView = UILabel()
        tempView.frame = CGRect(x: 20, y: 321.fit + 32 + kNavigationH, width: 100, height: 30)
        tempView.text = "选择小时"
        tempView.font = STELLAR_FONT_MEDIUM_T20
        return tempView
    }()
    private lazy var navBar: DetailNavBar = {
        let tempView = DetailNavBar.init(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kNavigationH))
        tempView.style = .defaultStyle
        tempView.titleLabel.text = "运动轨迹历史"
        tempView.moreButton.isHidden = true
        return tempView
    }()
    private lazy var collectionView: UICollectionView = {
        let tempView = UICollectionView.init(frame: CGRect.zero,collectionViewLayout: UICollectionViewFlowLayout())
        tempView.backgroundColor = STELLAR_COLOR_C3
        tempView.delegate = self
        tempView.dataSource = self
        tempView.register(UINib.init(nibName: "SelectHourCell", bundle: nil), forCellWithReuseIdentifier: "SelectHourCell")
        return tempView
    }()
    private lazy var calender: FSCalendar = {
        let calendar = FSCalendar(frame: CGRect(x: 10, y: kNavigationH, width: kScreenWidth-20, height: 321.fit))
        calendar.dataSource = self
        calendar.delegate = self
        calendar.pagingEnabled = true
        calendar.allowsMultipleSelection = false
        calendar.rowHeight = 60
        calendar.placeholderType = .fillHeadTail
        calendar.swipeToChooseGesture.isEnabled = true
        calendar.backgroundColor = STELLAR_COLOR_C3
        calendar.appearance.headerTitleColor = STELLAR_COLOR_C4
        calendar.appearance.titleDefaultColor = defaultDateTextColor
        calendar.appearance.titlePlaceholderColor = STELLAR_COLOR_C7
        calendar.appearance.weekdayTextColor = defaultDateTextColor;
        calendar.appearance.selectionColor = STELLAR_COLOR_C1;
        calendar.appearance.titleSelectionColor = STELLAR_COLOR_C3;
        calendar.appearance.titleFont = STELLAR_FONT_NUMBER_T16
        calendar.appearance.todayColor = STELLAR_COLOR_C10
        calendar.today = Date()
        return calendar
    }()
    private lazy var today: Date = {
        let tempCalender = NSCalendar.current
        let now = Date()
        let components = tempCalender.dateComponents([.year,.month,.day], from: now)
        return tempCalender.date(from: components) ?? now
    }()
} 
extension SelectDateViewController: FSCalendarDataSource , FSCalendarDelegate , FSCalendarDelegateAppearance {
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        return dataList.contains(date)
    }
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        if !self.dataList.contains(date) {
            return
        }
        let time = getStartAndEndTime(date: date)
        netQueryDatas(startTime: time.start, endTime: time.end)
    }
    func minimumDate(for calendar: FSCalendar) -> Date {
        let pCalender = NSCalendar.current
        return pCalender.date(byAdding: .day, value: -7, to: today) ?? Date()
    }
    func maximumDate(for calendar: FSCalendar) -> Date {
        return today
    }
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
        if date == today {
            return STELLAR_COLOR_C10
        }
        if dataList.contains(date) {
            return STELLAR_COLOR_C8
        }
        return UIColor.clear
    }
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        if date == today {
            return UIColor.white
        }
        if dataList.contains(date) {
            return STELLAR_COLOR_C5
        }
        return STELLAR_COLOR_C7
    }
}
extension SelectDateViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hourList.count
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectHourCell", for: indexPath) as! SelectHourCell
        cell.setupData(model: hourList[indexPath.row])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !hourList[indexPath.row].isHaveHistorty {
            TOAST(message: "没有历史数据")
            return
        }
        let vc = TrajectHistoryViewController()
        vc.device = device
        var times: [String] = []
        for time in queryTimeList {
            let transTime = String.ss.localTimeWithUTCString(UTCtimeString: time)
            let temp = transTime.components(separatedBy: ":")
            guard let pTime = temp.first else {
                return
            }
            if hourList[indexPath.row].hour == "\(pTime):00" {
                times.append(time)
            }
        }
        vc.timeList = times
        navigationController?.pushViewController(vc, animated: true)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (kScreenWidth - 85)/6, height: 36)
    }
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 9
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 9
    }
}