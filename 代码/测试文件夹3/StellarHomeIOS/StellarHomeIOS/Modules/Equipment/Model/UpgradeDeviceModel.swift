import UIKit
class UpgradeDeviceModel: Convertible {
    var allow: String = ""
    var timeout: Int = -1
    var newVersion: Int = -1
    var slience: Bool = false
    var descriptionZhs: String = ""
    var old_max_version: Int = -1
    var old_min_version: Int = -1
    var descriptionEn: String = ""
    var isGlobal: Bool = false
    var profiles: [UpgradeDeviceProfiles] = []
    required init() {}
}
class UpgradeDeviceProfiles: Convertible {
    var profile: Int = -1
    var url: String = ""
    var size: Int = -1
    var md5: String = ""
    required init() {}
}