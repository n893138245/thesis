import UIKit
enum CreatSourceVc {
    case creatScense 
    case creatSmart 
    case panelSetting 
    case unkoning
}
enum ControlRoomType {
    case allRoom
    case otherRoom
    case none
}
enum DataType {
    case controlDeviceType 
    case executeScenesType 
    case controlRoomType 
    case emptyType
}
class CreatGroupDataModel: NSObject {
    var sourceVc: CreatSourceVc = .unkoning 
    var groupId = 0 
    var myDataType: DataType = .emptyType 
    var selectedScenseId: String? 
    var controlRoomType: ControlRoomType = .none
}