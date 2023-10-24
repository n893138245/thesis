import UIKit
typealias JSONDictionary = [String: Any]
class Network: NSObject{
    static let sharedManager = Network.init()
    typealias Success = ((JSON) -> Void)
    typealias Failure = ((MoyaError, String) -> Void)
    typealias Progress = ((Double, Bool) -> Void)
    var isRefreshingToken = false
    var targets = [(NetRequestAPI,Success,Failure)]()
    var plugins:[PluginType] = [
        NetworkLoggerPlugin(verbose: true),
        NetworkActivityPlugin(networkActivityClosure: { (changeType, targetType) in
            switch changeType{
            case .began:
                break
            case.ended:
                break
            }
        }),
        AuthPlugin(),
        CachePolicyPlugin()
    ]
    let stubClosure: (_ type: NetRequestAPI) -> Moya.StubBehavior  = { type1 in
        return StubBehavior.never
    }
    static func request(_ target: NetRequestAPI,
                        viewController: UIViewController? = nil,
                        success: @escaping Success,
                        failure: @escaping Failure){
        var plugins = Network.sharedManager.plugins
        if let vc = viewController {
            plugins.append(RequestLoadingPlugin(viewController: vc))
        }
        let requestClosure = { (endpoint: Endpoint, done: MoyaProvider.RequestResultClosure) in
            do {
                var request = try endpoint.urlRequest()
                request.timeoutInterval = 5
                done(.success(request))
            } catch {
                done(.failure(MoyaError.underlying(error, nil)))
            }
        }
        let provider = MoyaProvider<NetRequestAPI>(requestClosure: requestClosure,stubClosure: Network.sharedManager.stubClosure, plugins:plugins)
        switch target {
        case .queryAllRooms:
            break
        case .queryDevicesVersionDescription(_,_,_):
            break
        case .devicesUpgradeInfo(_,_):
            break
        case .queryDevicesAddList:
            break
        case .queryAllScenesBGImageList:
            break
        default:
            provider.manager.delegate.sessionDidReceiveChallenge = { session, challenge in
                return Self.formateHTTPSAuthentication(challenge: challenge)
            }
            break
        }
        sharedManager.request(provider: provider, target: target, success: { json in
            success(json)
        }, failure: { (error,message) in
                failure(error, "")
        })
    }
    private func request(provider:MoyaProvider<NetRequestAPI>,target:NetRequestAPI,success: @escaping Success,failure: @escaping Failure){
        provider.request(target) {
            switch $0{
            case .success(let response):
                let json: JSON = JSON(response.data)
                let statusCode = response.statusCode
                if statusCode == 401{
                    switch target {
                    case .refreshToken(refreshToken: _):
                        failure(MoyaError.statusCode(Response.init(statusCode: 401, data: Data())), "请求失败")
                    default:
                        BackNetManager.sharedManager.refreshToken {
                            Network.sharedManager.request(provider: provider, target: target, success: success, failure: failure)
                        }
                    }
                }else{
                    success(json)
                }
            case .failure(let error):
                failure(error, "请求失败")
            }
        }
    }
    static func formateHTTPSAuthentication(challenge: URLAuthenticationChallenge) -> (URLSession.AuthChallengeDisposition, URLCredential?) {
        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust{
            let serverTrust:SecTrust = challenge.protectionSpace.serverTrust!
            let index: CFIndex = SecTrustGetCertificateCount(serverTrust)
            let cerPath = StellarHomeResourceUrl.caPath
            let cerUrl = URL(fileURLWithPath:cerPath)
            guard let localCertificateData = try? Data(contentsOf: cerUrl) else{
                return (.cancelAuthenticationChallenge, nil)
            }
            var result: Bool = false
            for i in 0..<Int(index){
                let certificate = SecTrustGetCertificateAtIndex(serverTrust, i)!
                let remoteCertificateData
                    = SecCertificateCopyData(certificate) as Data
                if remoteCertificateData == localCertificateData{
                    result = true
                    break
                }
            }
            if result == true {
                let credential = URLCredential(trust: serverTrust)
                challenge.sender?.use(credential, for: challenge)
                return (URLSession.AuthChallengeDisposition.useCredential , URLCredential(trust: challenge.protectionSpace.serverTrust!))
            }else{
                return (.cancelAuthenticationChallenge, nil)
            }
        }else if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodClientCertificate {
            let identityAndTrust:IdentityAndTrust = Self.extractIdentity();
            let urlCredential:URLCredential = URLCredential(
                identity: identityAndTrust.identityRef,
                certificates: identityAndTrust.certArray as? [AnyObject],
                persistence: URLCredential.Persistence.forSession);
            return (.useCredential, urlCredential);
        }else {
            return (.cancelAuthenticationChallenge, nil)
        }
    }
    static func extractIdentity() -> IdentityAndTrust {
        var identityAndTrust:IdentityAndTrust!
        var securityError:OSStatus = errSecSuccess
        let path: String = StellarHomeResourceUrl.clientPath
        let PKCS12Data = NSData(contentsOfFile:path)!
        let key : NSString = kSecImportExportPassphrase as NSString
        let options : NSDictionary = [key : "123456"] 
        var items : CFArray?
        securityError = SecPKCS12Import(PKCS12Data, options, &items)
        if securityError == errSecSuccess {
            let certItems:CFArray = (items as CFArray?)!;
            let certItemsArray:Array = certItems as Array
            let dict:AnyObject? = certItemsArray.first;
            if let certEntry:Dictionary = dict as? Dictionary<String, AnyObject> {
                let identityPointer:AnyObject? = certEntry["identity"];
                let secIdentityRef:SecIdentity = (identityPointer as! SecIdentity?)!
                let trustPointer:AnyObject? = certEntry["trust"]
                let trustRef:SecTrust = trustPointer as! SecTrust
                let chainPointer:AnyObject? = certEntry["chain"]
                identityAndTrust = IdentityAndTrust(identityRef: secIdentityRef, trust: trustRef, certArray:  chainPointer!)
            }
        }
        return identityAndTrust;
    }
}
struct IdentityAndTrust {
    var identityRef:SecIdentity
    var trust:SecTrust
    var certArray:AnyObject
}