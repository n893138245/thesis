import UIKit
class TableViewDataModel: NSObject {
    var tableViewDataArr = [TableViewSectionModel]()
    var tableView:UITableView?
    override init() {
    }
    func targetTableView(myTableview:UITableView){
        self.tableView = myTableview
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        self.tableView?.separatorInset = UIEdgeInsets.init(top: 0, left: kScreenWidth, bottom: 0, right: 0)
    }
}
extension TableViewDataModel:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableViewDataArr.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section < tableViewDataArr.count {
            let sectionModel = tableViewDataArr[section]
            return sectionModel.cellModelsArr.count
        }
        return tableViewDataArr.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height:CGFloat = 0
        if indexPath.section < tableViewDataArr.count {
            let sectionModel = tableViewDataArr[indexPath.section]
            if indexPath.row < sectionModel.cellModelsArr.count {
                let cellmodel = sectionModel.cellModelsArr[indexPath.row]
                if cellmodel.cellHeight != nil {
                    height = cellmodel.cellHeight!(tableView,indexPath)
                }
            }
        }
        return height
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section < tableViewDataArr.count {
            let sectionModel = tableViewDataArr[indexPath.section]
            if indexPath.row < sectionModel.cellModelsArr.count {
                let cellmodel = sectionModel.cellModelsArr[indexPath.row]
                var modelcell:UITableViewCell? = nil
                if cellmodel.cell != nil {
                    modelcell = cellmodel.cell!(tableView,indexPath)
                    if modelcell != nil {
                        return modelcell!
                    }
                }
            }
        }
        let identifier = "mycell"
        var cell = tableView.dequeueReusableCell(withIdentifier:identifier)
        if cell != nil {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: identifier)
            cell?.selectionStyle = .none
        }
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section < tableViewDataArr.count {
            let sectionModel = tableViewDataArr[indexPath.section]
            if indexPath.row < sectionModel.cellModelsArr.count {
                let cellmodel = sectionModel.cellModelsArr[indexPath.row]
                if cellmodel.selectRow != nil {
                    cellmodel.selectRow!(tableView, indexPath)
                }
            }
        }
    }
}
class TableViewSectionModel: NSObject {
    var viewForHeaderInSection:((UITableView,NSInteger)->UIView)? = nil
    var heightForHeaderInSection:((UITableView,NSInteger)->UIView)? = nil
    var cellModelsArr = [CellModel]()
}
class CellModel: NSObject {
    var cellHeight:((UITableView,IndexPath)->CGFloat)? = nil
    var cell:((UITableView,IndexPath)->UITableViewCell)? = nil
    var selectRow:((UITableView,IndexPath)->Void)? = nil
}