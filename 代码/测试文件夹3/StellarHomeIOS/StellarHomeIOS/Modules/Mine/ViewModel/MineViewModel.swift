import UIKit
class MineViewModel {
    private lazy var bag = DisposeBag()
    lazy var mineVariable : BehaviorRelay<[MineModel]> = {
        return BehaviorRelay(value: self.getMineModels())
    }()
}
extension MineViewModel {
    func getMineModels() -> [MineModel] {
        var models = [MineModel]()
        let model1 = MineModel(leftImageName: "my_icon_1", leftTitle: StellarLocalizedString("MINE_HELP_CENTER"), isShowArrow: true)
        models.append(model1)
        let model2 = MineModel(leftImageName: "my_icon_2", leftTitle: StellarLocalizedString("MINE_FEEDBACK_FEEDBACK"), isShowArrow: true)
        models.append(model2)
        let model3 = MineModel(leftImageName: "my_icon_3", leftTitle: StellarLocalizedString("MINE_INFO_USERINFO"), isShowArrow: true)
        models.append(model3)
        let model4 = MineModel(leftImageName: "my_icon_4", leftTitle: StellarLocalizedString("MINE_ABOUT_US"), isShowArrow: true)
        models.append(model4)
        let model5 = MineModel(leftImageName: "my_icon_5", leftTitle: StellarLocalizedString("MINE_THIRD_PARTY"), isShowArrow: true)
        models.append(model5)
        return models
    }
}
