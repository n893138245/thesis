import UIKit
class HBottomFullColorFactory: HBottomSelectionBaseFactory {
    private var tableViewDataArr = [TableViewSectionModel]()
    var cctRange :(max: Int, min: Int) = (0,0)
    var devices: [LightModel]?
    var roomId: Int?
    private var cctDataList: [(cct: Int, bgColor: String)] = []
    override func getSectionModelData() -> [TableViewSectionModel] {
        let sectionModel = getSectionModel()
        let textCellModel = CellModel()
        textCellModel.cellHeight = { table, index in
            return 342 + getAllVersionSafeAreaBottomHeight()
        }
        textCellModel.cell = { table, index in
            let cell = FullColorTableViewCell.initWithXIb() as! FullColorTableViewCell
            cell.roomId = self.roomId
            cell.devices = self.devices
            cell.cctDataList = self.getCCTData()
            return cell
        }
        sectionModel.cellModelsArr.append(textCellModel)
        return tableViewDataArr
    }
    private func getCCTData() ->[FullColorModel] {
        var dataList = [FullColorModel]()
        cctDataList = TemperatureResource.allCCTValuesList.filter({$0.cct >= self.cctRange.min && $0.cct <= self.cctRange.max})
        for value in cctDataList {
            let model = FullColorModel()
            model.cct = value.cct
            model.bgColor = value.bgColor
            dataList.append(model)
        }
        return dataList
    }
    private func getSectionModel() -> TableViewSectionModel{
        var sectionModel = tableViewDataArr.first
        if sectionModel == nil {
            sectionModel = TableViewSectionModel()
            tableViewDataArr.append(sectionModel!)
        }
        return sectionModel!
    }
}