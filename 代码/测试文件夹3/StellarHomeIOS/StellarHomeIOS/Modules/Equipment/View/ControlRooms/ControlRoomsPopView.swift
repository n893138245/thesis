import UIKit
class ControlRoomsPopView: UIView {
    let disposeBag = DisposeBag()
    var rooms = [String]()
    var dataList = [(power: RoomPowerModel, isOnline: Bool)]()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupData()
        setupActions()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupUI() {
        setupRooms()
        addSubview(contentView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(closeButton)
        let width = kScreenWidth-20.fit
        contentView.snp.makeConstraints {
            $0.center.equalTo(self)
            $0.width.equalTo(width)
            if rooms.count > 3 {
                $0.height.equalTo(width*284.0/357.0)
            }else {
                $0.height.equalTo(width*165.0/357.0)
            }
        }
        titleLabel.snp.makeConstraints {
            $0.centerX.equalTo(contentView)
            $0.top.equalTo(contentView).offset(12.fit)
        }
        closeButton.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel)
            $0.height.width.equalTo(44.fit)
            $0.right.equalTo(contentView).offset(-4.fit)
        }
        contentView.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.top.equalTo(contentView).offset(46.fit)
            $0.left.right.bottom.equalTo(contentView)
        }
        let line = UIView()
        line.backgroundColor = STELLAR_COLOR_C9
        collectionView.addSubview(line)
        line.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.width.equalTo(kScreenWidth-40.fit)
            $0.centerX.equalTo(collectionView)
        }
    }
    private func setupRooms() {
        rooms.append(contentsOf: DevicesStore.instance.hasLightsAllRoomsName)
        rooms.insert("全部", at: 0)
        rooms.forEach { (roomName) in
            let roomId = StellarRoomManager.shared.getRoom(roomName: roomName).id ?? 0
            if roomId != 0 {
                let roomLights = DevicesStore.instance.sortedLightsDic[roomId]!.filter({$0.remoteType != .locally})
                if roomLights.isEmpty { 
                    self.rooms.removeAll(where: {$0 == roomName})
                }
            }
        }
    }
    private func setupActions() {
        closeButton.rx.tap.subscribe(onNext: { [weak self] (_) in
            self?.close()
        }).disposed(by: disposeBag)
    }
    private func setupData() {
        let count = DevicesStore.instance.lights.count
        let titleLeft = StellarLocalizedString("EQUIPMENT_TOTAL")
        let titleCenter = " \(count) "
        let titleRight = StellarLocalizedString("EQUIPMENT_LINGHTS")
        let styleTxt = Style{
            $0.font = STELLAR_FONT_MEDIUM_T17
            $0.color = STELLAR_COLOR_C4
        }
        let styleNum = Style{
            $0.font = STELLAR_FONT_NUMBER_T17
            $0.color = STELLAR_COLOR_C4
        }
        titleLabel.attributedText = titleLeft.set(style: styleTxt) + titleCenter.set(style: styleNum) + titleRight.set(style: styleTxt)
        setupCollectionViewLayout()
        setPowerData()
        collectionView.reloadData()
    }
    private func setupCollectionViewLayout() {
        let defaultLayout = UICollectionViewFlowLayout()
        defaultLayout.scrollDirection = UICollectionView.ScrollDirection.vertical
        defaultLayout.sectionInset = UIEdgeInsets.init(top: 0, left: 10.fit, bottom: 0, right: 10.fit)
        if rooms.count == 1 {
            defaultLayout.itemSize = CGSize(width: (kScreenWidth-40.fit), height: 116.fit)
        }else if rooms.count == 2 {
            defaultLayout.itemSize = CGSize(width: (kScreenWidth-40.fit)/2, height: 116.fit)
        }else {
            defaultLayout.itemSize = CGSize(width: (kScreenWidth-40.fit)/3, height: 116.fit)
        }
        defaultLayout.minimumLineSpacing = 0 
        defaultLayout.minimumInteritemSpacing = 0.0 
        defaultLayout.headerReferenceSize = CGSize.zero
        defaultLayout.footerReferenceSize = CGSize.zero
        collectionView.collectionViewLayout = defaultLayout
    }
    private func setPowerData() {
        for roomName in rooms {
            var isOnline = true
            let roomPower = RoomPowerModel()
            roomPower.roomName = roomName
            if roomName == "全部" {
                for light in DevicesStore.instance.lights {
                    if light.status.onOff == "on" && light.status.online {
                        roomPower.powerStatus = .powerOn
                        break
                    }
                }
            }else {
                let roomId = StellarRoomManager.shared.getRoom(roomName: roomName).id ?? 0
                let roomLights = DevicesStore.instance.sortedLightsDic[roomId]!
                for light in roomLights {
                    if light.status.onOff == "on" && light.status.online {
                        roomPower.powerStatus = .powerOn
                        break
                    }
                }
                let onlineLights = roomLights.filter({$0.status.online})
                isOnline = !onlineLights.isEmpty
            }
            dataList.append((roomPower,isOnline))
        }
    }
    private func changeStatusByRoomAndCommand(room: String, command: String, currentRow: Int) {
        let allPower = dataList.first!.power
        let currentPower = dataList[currentRow].power
        if room == "全部" { 
            allOnOff(onOff: command)
        }else { 
            if command == "on" {
                allPower.powerStatus = .powerOn
                currentPower.powerStatus = .powerOn
                collectionView.reloadData()
            }else {
                var otherPower = dataList
                otherPower.remove(at: 0)
                currentPower.powerStatus = .powerOff
                let arr = otherPower.filter({$0.power.powerStatus == .powerOff})
                if arr.count == otherPower.count {
                    allPower.powerStatus = .powerOff
                }
                collectionView.reloadData()
            }
        }
    }
    private func allOnOff(onOff: String) {
        for powerModel in dataList {
            if onOff == "on" {
                powerModel.power.powerStatus = .powerOn
            }else {
                powerModel.power.powerStatus = .powerOff
            }
        }
        collectionView.reloadData()
    }
    class func shareView() {
        let view = ControlRoomsPopView.init(frame: UIScreen.main.bounds)
        DispatchQueue.main.async {
            let window = getFrontWindow() ?? UIWindow()
            window.addSubview(view)
        }
        view.contentView.pop_add(view.ss.popScaleAnimation(), forKey: "scale")
    }
    func close() {
        subviews.forEach { (view) in
            view.removeFromSuperview()
        }
        removeFromSuperview()
    }
    private lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = STELLAR_COLOR_C3
        view.layer.cornerRadius = 12.fit
        view.clipsToBounds = true
        return view
    }()
    private lazy var titleLabel: UILabel = {
        let tempView = UILabel()
        return tempView
    }()
    private lazy var closeButton: UIButton = {
        let tempView = UIButton.init(type: .custom)
        tempView.setImage(UIImage(named: "icon_close_gray22"), for: .normal)
        return tempView
    }()
    private lazy var collectionView: UICollectionView = {
        let tempView = UICollectionView.init(frame: CGRect.zero,collectionViewLayout: UICollectionViewFlowLayout())
        tempView.backgroundColor = STELLAR_COLOR_C3
        tempView.delegate = self
        tempView.dataSource = self
        tempView.register(UINib.init(nibName: "SwitchPowerCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SwitchPowerCollectionViewCell")
        return tempView
    }()
    deinit {
    }
}
extension ControlRoomsPopView:UICollectionViewDelegate,UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return rooms.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:SwitchPowerCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "SwitchPowerCollectionViewCell", for: indexPath) as! SwitchPowerCollectionViewCell
        cell.setData(model: dataList[indexPath.row], currentRow: indexPath.row, dataCount: rooms.count)
        cell.powerBlock = { [weak self] in
            guard let copySelf = self else { return }
            if !copySelf.dataList[indexPath.row].isOnline {
                TOAST(message: "该房间内没有设备在线")
                return
            }
            var onOffComm = ""
            onOffComm = cell.powerStatus == .powerOff ?"on":"off"
            let room = self?.rooms[indexPath.row]
            cell.startLoading()
            var roomId = 0
            if let pRoom = StellarRoomManager.shared.getRoom(roomName: room!).id {
                roomId = pRoom
            }
            CommandManager.shared.creatRoomOnOffCammand(roomId: roomId, onOff: onOffComm, success: { (pResponse) in
                self?.executeSuccess(cell: cell, room: room ?? "", row: indexPath.row, command: onOffComm)
            }, failure: { (code, message) in
                self?.executeFailure(cell: cell)
            })
        }
        return cell
    }
    private func executeSuccess(cell: SwitchPowerCollectionViewCell, room: String, row: Int, command: String) {
        cell.showSuccess(finished: {
            self.changeStatusByRoomAndCommand(room: room, command: command, currentRow: row)
        })
        TOAST(message: StellarLocalizedString("COMMON_EXECUTE_SUCCESS"),completeBlock: {
            self.close()
        })
    }
    private func executeFailure(cell: SwitchPowerCollectionViewCell) {
        cell.stopLoading()
        TOAST(message: StellarLocalizedString("COMMON_EXECUTE_FAIL"),completeBlock: {
            self.close()
        })
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
}