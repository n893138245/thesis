import UIKit
enum executeType {
    case frequency 
    case afterEnd  
}
class StreamerPullView: UIView {
    @IBOutlet weak var tableBgView: UIView!
    @IBOutlet weak var tableView: UITableView!
    let frequencyDataList = ["执行一次","循环执行"]
    let afterEndDataList = ["关闭灯光","恢复流光前状态","保持流光停止状态"]
    var currentText: String = "" {
        didSet {
            selectIndex = dataList.firstIndex(of: currentText) ?? 0
            tableView.reloadData()
        }
    }
    var selectIndex = 0
    var dataList: Array<String> = []
    var clickTitleBlock: ((_ title: String) -> Void)?
    var touchBlock: (() -> Void)?
    var type: executeType = .frequency {
        didSet {
            dataList = type == .frequency ? frequencyDataList:afterEndDataList
            tableView.frame = type == .frequency ? CGRect(x: 8.fit, y: kNavigationH+69.fit, width: 171.fit, height: 112.fit):CGRect(x: kScreenWidth/2+8.5.fit, y: kNavigationH+69.fit, width: 171.fit, height: 168.fit)
            tableBgView.frame = tableView.frame
            tableBgView.layer.shadowColor = UIColor.black.cgColor
            tableBgView.layer.shadowOpacity = 0.33
            tableBgView.layer.shadowRadius = 6
            tableBgView.layer.cornerRadius = 6
            tableBgView.layer.shadowOffset = CGSize(width: 0, height: 6)
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
        setupViews()
    }
    private func setupViews() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: "StreamerPullCell", bundle: nil), forCellReuseIdentifier: "StreamerPullCellId")
        tableView.layer.cornerRadius = 6
    }
    class func StreamerPullView() ->StreamerPullView {
        let view = Bundle.main.loadNibNamed("StreamerPullView", owner: nil, options: nil)?.last as! StreamerPullView
        return view
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let block = touchBlock {
            block()
        }
        dissmiss()
    }
    func dissmiss() {
        var frame = tableView.frame
        frame.size.height = 0
        UIView.animate(withDuration: 0.3, animations: {
            self.tableView.frame = frame
            self.tableBgView.frame = frame
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
extension StreamerPullView: UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StreamerPullCellId", for: indexPath) as! StreamerPullCell
        cell.selectionStyle = .none
        cell.mTitleLabel.text = dataList[indexPath.row]
        cell.isSelected = indexPath.row == selectIndex ? true : false
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56.fit
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! StreamerPullCell
        cell.isSelected = true
        let lastCell = tableView.cellForRow(at: IndexPath(row: selectIndex, section: 0))
        lastCell?.isSelected = false
        selectIndex = indexPath.row
        let title = dataList[indexPath.row]
        clickTitleBlock!(title)
        dissmiss()
    }
}