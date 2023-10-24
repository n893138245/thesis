import UIKit
class FullColorTableViewCell: UITableViewCell {
    @IBOutlet weak var collectionView: UICollectionView!
    private let cellIdentifier = "FullColorDetailCellID"
    var devices: [LightModel]?
    var roomId: Int?
    var lastSelectRow: Int?
    var cctDataList: [FullColorModel] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    static func initWithXIb() -> UITableViewCell {
        let arrayOfViews = Bundle.main.loadNibNamed("FullColorTableViewCell", owner: nil, options: nil)
        guard let firstView = arrayOfViews?.first as? UITableViewCell else {
            return UITableViewCell()
        }
        return firstView
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.register(UINib.init(nibName: "FullColorDetailCell", bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    private func sendCommand(row: Int) {
        if let lastRow = lastSelectRow {
            cctDataList[lastRow].isSelected = false
            if let cell = collectionView.cellForItem(at: IndexPath(row: lastRow, section: 0)) as? FullColorDetailCell {
                cell.hiddenSelected()
            }
        }
        guard let cell = collectionView.cellForItem(at: IndexPath(row: row, section: 0)) as? FullColorDetailCell else { return }
        let model = cctDataList[row]
        StellarProgressHUD.showHUD()
        cell.showLoading()
        if roomId != nil {
            guard let room = roomId else { return }
            CommandManager.shared.creatRoomTemperatureCammand(roomId: room, cct: model.cct, success: { (_) in
                self.stopLoading(cell: cell, row: row)
            }) { (_, _) in
                self.stopLoading(cell: cell, row: row)
            }
        }else {
            guard let lights = devices else { return }
            CommandManager.shared.creatCCTCommandAndSend(deviceGroup: lights, cct: model.cct, success: { (_) in
                self.stopLoading(cell: cell, row: row)
            }) { (_, _) in
                self.stopLoading(cell: cell, row: row)
            }
        }
    }
    private func stopLoading(cell: FullColorDetailCell, row: Int) {
        StellarProgressHUD.dissmissHUD()
        cell.stopLoading()
        cctDataList[row].isSelected = true
        cell.showSelected()
        lastSelectRow = row
        collectionView.reloadData()
        NotificationCenter.default.post(name: .NOTIFY_CCT_CHANGE, object: nil, userInfo: ["cct" :cctDataList[row].cct])
    }
}
extension FullColorTableViewCell: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cctDataList.count
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! FullColorDetailCell
        let model = cctDataList[indexPath.row]
        cell.setupViews(cctModel: model)
        cell.clickBlock = { [weak self] in
            self?.sendCommand(row: indexPath.row)
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        sendCommand(row: indexPath.row)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (kScreenWidth - 30)/5, height: 78)
    }
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: kScreenWidth - 30, height: 12)
    }
}