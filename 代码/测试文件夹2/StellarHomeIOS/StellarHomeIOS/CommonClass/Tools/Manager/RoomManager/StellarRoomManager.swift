import UIKit
class StellarRoomManager: NSObject {
    static let shared = StellarRoomManager.init()
    var myRooms = [StellarRoomModel]()
    override init() {
        super.init()
    }
    func getRoomList(success :(() ->Void)?,failure: ((_ message: String,_ code: Int) ->Void)?) {
        DevicesStore.sharedStore().queryAllRooms(success: { (arr) in
            self.myRooms = arr
            if let block = success {
                block()
            }
        }) { (err) in
            if let block = failure {
                block("",-1)
            }
        }
    }
    func getRoom(roomId: Int) -> StellarRoomModel {
        var model = StellarRoomModel.init()
        for pModel in myRooms {
            if pModel.id == roomId {
                model = pModel
            }
        }
        return model
    }
    func getRoom(roomName: String) -> StellarRoomModel {
        var model = StellarRoomModel.init()
        for pModel in myRooms {
            if pModel.name == roomName {
                model = pModel
            }
        }
        return model
    }
}