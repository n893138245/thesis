import UIKit
import Alamofire
class GitLabAPIManager: NSObject {
    static let sharedManager = GitLabAPIManager.init()
    let sessionManager: SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 6
        return SessionManager(configuration: configuration)
    }()
    public func sendFeedback(feedback: String, success:(()->Void)?, failure:((Int)->Void)?) {
        let url = "http://git.sansi.io:6100/api/v4/projects/784/issues"
        var header: HTTPHeaders = SessionManager.defaultHTTPHeaders
        header["PRIVATE-TOKEN"] = "cevbpgWy7ePLT8ugpXGz"
        let infoDictionary = Bundle.main.infoDictionary
        let softVersion = infoDictionary!["CFBundleShortVersionString"] ?? ""
        let description = "User: \(StellarAppManager.sharedManager.user.userInfo.cellphone)</br>Device: iOS \(UIDevice.current.systemVersion)</br>SoftVersion: \(softVersion)</br>\(feedback)"
        let params = ["title": "User feedback",
                      "description": description,
                      "labels": "User feedback"]
        sessionManager.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
            response.result.ifSuccess {
                if let tempClosure = success{
                    tempClosure()
                }
            }
            response.result.ifFailure {
                if let tempClosure = failure{
                    tempClosure(response.response?.statusCode ?? 500)
                }
            }
        }
    }
}
