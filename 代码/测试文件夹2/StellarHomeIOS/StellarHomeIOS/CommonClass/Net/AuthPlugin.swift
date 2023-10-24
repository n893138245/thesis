import UIKit
final class AuthPlugin: PluginType {
    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        var request = request
        guard let myTarget = target as? NetRequestAPI  else {
            return request
        }
        switch myTarget {
        case .queryAllRooms:
            break
        case .queryDevicesVersionDescription(_,_,_):
            break
        case .devicesUpgradeInfo(_,_):
            break
        case .refreshToken(_):
            break
        case .queryDevicesAddList:
            break
        case .queryAllScenesBGImageList:
            break
        default:
            if !StellarAppManager.sharedManager.user.token.accessToken.isEmpty {
                request.addValue("Bearer \(StellarAppManager.sharedManager.user.token.accessToken)", forHTTPHeaderField: "Authorization")
            }
            break
        }
        return request
    }
}