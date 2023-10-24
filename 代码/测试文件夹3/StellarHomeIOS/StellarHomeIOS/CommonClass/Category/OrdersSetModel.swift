import UIKit
class OrdersSetModel: NSObject {
    var title: String = ""
    var name: String = ""
    var type: DeviceType = .light
    var fwType: Int = 0
    var orderArray: [(header: String, orders: [String])] = []
    init(device: BasicDeviceModel) {
        super.init()
        fwType = device.fwType
        title = "\(device.name) 语音指令"
        name = device.isSetRoom ? ((StellarRoomManager.shared.getRoom(roomId: device.room ?? -1).name ?? "") + " " + device.name) : device.name
        if device.type == .light {
            orderArray = self.makeSmartHomeOrders(device: device as? LightModel ?? LightModel())
        }else {
            name = "网关快捷唤醒词"
            title = "网关快捷唤醒词"
            makeGatewayOrders(gateWay: device as? GatewayModel ?? GatewayModel())
            type = .hub
        }
    }
    init(skillModel: DUIInternalSkillModel) {
        super.init()
        title = "“\(skillModel.detail?.ordersArr.first ?? "")”"
        name = skillModel.skillName
        orderArray = [("你可以这样说", skillModel.detail?.ordersArr ?? [])]
    }
    func makeGatewayOrders(gateWay: GatewayModel) {
        orderArray.removeAll()
        orderArray.append((header: "使用快捷唤醒词可以直接唤醒网关进行相应操作\n无需要使用“智能家居”唤醒网关", orders: ["增大音量","减小音量","暂停播放","继续播放"]))
    }
    func makeSmartHomeOrders(device: LightModel) -> [(header: String, orders: [String])] {
        var result: [(header: String, orders: [String])] = []
        var onOffOrders: [String] = []
        var brightnessOrders: [String] = []
        var colorOrders: [String] = []
        var cctOrders: [String] = []
        device.traits?.forEach { (trait) in
            let ordersArr = makeOrderStrings(trait: trait, deviceName: device.name, roomId: nil);
            switch trait {
            case .onOff:
                onOffOrders.append(contentsOf: ordersArr)
            case .brightness, .increaseBrightness, .decreaseBrightness:
                brightnessOrders.append(contentsOf: ordersArr)
            case .color:
                colorOrders.append(contentsOf: ordersArr)
            case .colorTemperature, .increaseColorTemperature, .decreaseColorTemperature:
                cctOrders.append(contentsOf: ordersArr)
            default:
                break
            }
        }
        if device.isSetRoom == true{
            device.traits?.forEach { (trait) in
                let ordersArr = makeOrderStrings(trait: trait, deviceName: device.name, roomId: device.room);
                switch trait {
                case .onOff:
                    onOffOrders.append(contentsOf: ordersArr)
                case .brightness, .increaseBrightness, .decreaseBrightness:
                    brightnessOrders.append(contentsOf: ordersArr)
                case .color:
                    colorOrders.append(contentsOf: ordersArr)
                case .colorTemperature, .increaseColorTemperature, .decreaseColorTemperature:
                    cctOrders.append(contentsOf: ordersArr)
                default:
                    break
                }
            }
        }
        if onOffOrders.isEmpty == false {
            result.append(("控制开关", onOffOrders))
        }
        if brightnessOrders.isEmpty == false {
            result.append(("控制亮度", brightnessOrders))
        }
        if colorOrders.isEmpty == false {
            result.append(("控制颜色", colorOrders))
        }
        if cctOrders.isEmpty == false {
            result.append(("控制色温", cctOrders))
        }
        return result
    }
    func makeOrderStrings(trait:Traits, deviceName: String, roomId: Int?) -> [String]{
        let target: String = makeTarget(deviceName: deviceName, roomId: roomId)
        var orderStrings: [String] = []
        switch trait {
        case .onOff:
            let openStr = "打开\(target)"
            let closeStr = "关闭\(target)"
            orderStrings.append(openStr)
            orderStrings.append(closeStr)
        case .brightness:
            let setBrightnessStr = "把\(target)的亮度调到五十"
            orderStrings.append(setBrightnessStr)
        case .increaseBrightness:
            let addBrightnessStr = "把\(target)调亮一点"
            orderStrings.append(addBrightnessStr)
        case .decreaseBrightness:
            let dimBrightnessStr = "把\(target)调暗一点"
            orderStrings.append(dimBrightnessStr)
        case .color:
            let colorStr = "把\(target)调成红色"
            orderStrings.append(colorStr)
        case .colorTemperature:
            let coolCCTStr = "把\(target)调成冷白"
            orderStrings.append(coolCCTStr)
            let warmCCTStr = "把\(target)调成暖白"
            orderStrings.append(warmCCTStr)
        case .increaseColorTemperature:
            let addCCTStr = "把\(target)调暖一点"
            orderStrings.append(addCCTStr)
        case .decreaseColorTemperature:
            let dimCCTStr = "把\(target)调冷一点"
            orderStrings.append(dimCCTStr)
        default:
            break
        }
        return orderStrings
    }
    func makeTarget(deviceName: String, roomId: Int?) -> String {
        if let tempRoomId = roomId{
            let roomName = StellarRoomManager.shared.getRoom(roomId: tempRoomId).name ?? ""
            return "\(roomName)的\(deviceName)"
        }else{
            return "\(deviceName)"
        }
    }
    func randomOrders(count: Int) -> [String] {
        var result: [String] = []
        var ordersPool: [String] = []
        orderArray.forEach { (item) in
            ordersPool.append(contentsOf: item.orders)
        }
        guard ordersPool.isEmpty == false else{return result}
        for _ in 0..<count{
            let idx = Int.ss.randomInRange(range: 0..<ordersPool.count)
            let str = ordersPool[idx]
            result.append(str)
            ordersPool = ordersPool.filter{$0 != str}
            if ordersPool.count == 0{
                break
            }
        }
        return result
    }
}
