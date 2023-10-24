import UIKit
class StellarSeleListView: UIView {
    private var titles = [String]()
    private var seleNum = 0
    var selectTypeBlock:((_ type: String) -> Void)?
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadSubView()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setTypes(types:[String]){
        var names = [String]()
        for type in types{
            names.append(type)
        }
        self.titles = names
        tableView.reloadData()
    }
    private func loadSubView(){
        tableView.backgroundColor = STELLAR_COLOR_C8
        addSubview(tableView)
    }
    private lazy var tableView: UITableView = {
        let tempView = UITableView.init(frame: CGRect(x: 0, y: 0, width: self.width, height: self.height))
        tempView.showsVerticalScrollIndicator = false
        tempView.delegate = self
        tempView.dataSource = self
        tempView.register(UINib(nibName: "StellarSeleCardCell", bundle: nil), forCellReuseIdentifier: "StellarSeleCardCell")
        tempView.separatorStyle = .none
        return tempView
    }()
}
extension StellarSeleListView: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.titles.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "StellarSeleCardCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! StellarSeleCardCell
        cell.selectionStyle = .none
        let name = titles[indexPath.row]
        cell.setData(name: name, isSelect: indexPath.row == seleNum)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        seleNum = indexPath.row
        tableView.reloadData()
        let name = titles[indexPath.row]
        selectTypeBlock?(name)
    }
}