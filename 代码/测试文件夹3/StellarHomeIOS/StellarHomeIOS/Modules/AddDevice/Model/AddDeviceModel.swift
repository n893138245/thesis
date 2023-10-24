import UIKit
class AddDeviceModel: Convertible {
    var mesh:[AddDeviceDetailModel]?
    var zigbee:[AddDeviceDetailModel]?
    var softAP:[AddDeviceDetailModel]?
    var smartConfig:[AddDeviceDetailModel]?
    var dui:[AddDeviceDetailModel]?
    var ble:[AddDeviceDetailModel]?
    required init() {
    }
}
class AddDeviceDetailModel: Convertible {
    var connection:ConnectionType = .unknown
    var fwType:Int?
    var type:DeviceType?
    var name:String?
    var remoteType:DeviceRemoteType = .unknown
    var onSale:Bool = false
    var appShownType:String?
    var model:String?
    required init() {
    }
}