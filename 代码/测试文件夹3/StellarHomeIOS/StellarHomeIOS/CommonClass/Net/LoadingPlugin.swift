import UIKit
import enum Result.Result
final class RequestLoadingPlugin: PluginType {
    private let viewController: UIViewController
    init(viewController: UIViewController) {
        self.viewController = viewController
        viewController.view.addSubview(hintView)
    }
    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        print("[Network Request] : \(request.url?.absoluteString ?? "")")
        return request
    }
    func willSend(_ request: RequestType, target: TargetType) {
    }
    func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        if let net = target as? NetRequestAPI {
            switch net {
            case .login:
                guard case let Result.failure(error) = result else { return }
                print(error.errorDescription ?? "未知错误")
                hintView.showAnimationWithTitle("登录失败", duration: 3)
                break
            default:
                break
            }
        }
    }
    func process(_ result: Result<Response, MoyaError>, target: TargetType) -> Result<Response, MoyaError> {
        return result
    }
    private lazy var hintView:HintTextView = {
        let hView =  HintTextView.HintTextView()
        hView.frame = CGRect.init(x: 0, y: 0, width: kScreenWidth, height: 100)
        return hView
    }()
}