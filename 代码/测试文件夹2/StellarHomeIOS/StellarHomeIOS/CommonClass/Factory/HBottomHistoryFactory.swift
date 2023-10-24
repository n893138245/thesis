import UIKit
class HBottomHistoryFactory: HBottomSelectionBaseFactory {
    var locations: [RadarLocationInfo]?
    private var tableViewDataArr = [TableViewSectionModel]()
    override func getSectionModelData() -> [TableViewSectionModel] {
        let sectionModel = getSectionModel()
        let historyCellModel = CellModel()
        historyCellModel.cellHeight = { table, index in
            return 226.fit + getAllVersionSafeAreaBottomHeight()
        }
        historyCellModel.cell = { [weak self] table, index in
            let cell = TrajectHistoryCell.initWithXIb() as! TrajectHistoryCell
            cell.setupData(locations: self?.locations ?? [RadarLocationInfo]())
            return cell
        }
        sectionModel.cellModelsArr.append(historyCellModel)
        return tableViewDataArr
    }
    private func getSectionModel() -> TableViewSectionModel {
        var sectionModel = tableViewDataArr.first
        if sectionModel == nil {
            sectionModel = TableViewSectionModel()
            tableViewDataArr.append(sectionModel!)
        }
        return sectionModel!
    }
}