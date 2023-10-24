import UIKit
class MineModel:Convertible{
    var leftImageName:String = ""
    var leftTitle:String = ""
    var isShowArrow:Bool = false
    required init() {
    }
    init(leftImageName:String,leftTitle:String,isShowArrow:Bool) {
        self.leftImageName = leftImageName
        self.leftTitle = leftTitle
        self.isShowArrow = isShowArrow
    }
}