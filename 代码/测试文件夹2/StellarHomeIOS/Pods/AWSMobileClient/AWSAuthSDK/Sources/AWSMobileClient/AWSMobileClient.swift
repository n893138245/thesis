import Foundation
public enum UserState: String {
    case signedIn, signedOut, signedOutFederatedTokensInvalid, signedOutUserPoolsTokenInvalid, guest, unknown
}
public typealias UserStateChangeCallback = (UserState, [String: String]) -> Void
enum FederationProvider: String {
    case none, userPools, hostedUI, oidcFederation
}
final public class AWSMobileClient: _AWSMobileClient {
    static var _sharedInstance: AWSMobileClient = AWSMobileClient(setDelegate: true)
    static var serviceConfiguration: CognitoServiceConfiguration? = nil
    internal var isAuthorizationAvailable: Bool = false
    internal var operateInLegacyMode: Bool = false
    var federationProvider: FederationProvider = .none
    var cachedLoginsMap: [String: String] = [:]
    internal var isInitialized: Bool = false
    internal var hostedUIConfigInternal: HostedUIOptions?
    internal var federationDisabled: Bool = false
    internal var customRoleArnInternal: String? = nil
    internal var signInURIQueryParameters: [String: String]? = nil
    internal var tokenURIQueryParameters: [String: String]? = nil
    internal var signOutURIQueryParameters: [String: String]? = nil
    internal var scopes: [String]? = nil
    internal let initializationQueue = DispatchQueue(label: "awsmobileclient.credentials.fetch")
    lazy var tokenFetchOperationQueue: OperationQueue = {
        var queue = OperationQueue()
        queue.name = "AWSMobileClient.tokenFetchOperationQueue"
        queue.maxConcurrentOperationCount = 1
        return queue
    }()
    internal let tokenFetchLock = DispatchGroup()
    internal let credentialsFetchOperationQueue: OperationQueue = {
        var queue = OperationQueue()
        queue.name = "AWSMobileClient.credentialsFetchOperationQueue"
        queue.maxConcurrentOperationCount = 1
        return queue
    }()
    internal let credentialsFetchLock = DispatchGroup()
    var credentialsFetchCancellationSource: AWSCancellationTokenSource = AWSCancellationTokenSource()
    let ProviderKey: String = "provider"
    let TokenKey: String = "token"
    let LoginsMapKey: String = "loginsMap"
    let FederationProviderKey: String = "federationProvider"
    let SignInURIQueryParametersKey: String = "signInURIQueryParameters"
    let TokenURIQueryParametersKey: String = "tokenURIQueryParameters"
    let SignOutURIQueryParametersKey: String = "signOutURIQueryParameters"
    let CustomRoleArnKey: String = "customRoleArn"
    let FederationDisabledKey: String = "federationDisabled"
    let HostedUIOptionsScopesKey: String = "hostedUIOptionsScopes"
    var internalCredentialsProvider: AWSCognitoCredentialsProvider?
    internal var pendingAWSCredentialsCompletion: ((AWSCredentials?, Error?) -> Void)? = nil
    internal var pendingGetTokensCompletion: ((Tokens?, Error?) -> Void)? = nil
    internal weak var developerNavigationController: UINavigationController? = nil
    var keychain: AWSUICKeyChainStore = AWSUICKeyChainStore.init(service: "\(String(describing: Bundle.main.bundleIdentifier)).AWSMobileClient")
    internal var isCognitoAuthRegistered = false
    internal let CognitoAuthRegistrationKey = "AWSMobileClient"
    var listeners: [(AnyObject, UserStateChangeCallback)] = []
    internal lazy var awsInfo: AWSInfo = {
        return AWSInfo.default()
    }()
    var userPassword: String? = nil
    public var currentUserState: UserState = .unknown
    public var deviceOperations: DeviceOperations = DeviceOperations.sharedInstance
    public var username: String? {
        return self.userpoolOpsHelper.currentActiveUser?.username
    }
    public var userSub: String? {
        guard  (isSignedIn && (federationProvider == .hostedUI || federationProvider == .userPools)) else {
            return nil
        }
        guard let idToken = self.cachedLoginsMap.first?.value else {
            return nil
        }
        let sessionToken = SessionToken(tokenString: idToken)
        guard let sub = sessionToken.claims?["sub"] as? String else {
            return nil
        }
        return sub
    }
    override public var identityId: String? {
        return self.internalCredentialsProvider?.identityId
    }
    @objc public var isSignedIn: Bool {
        get {
            if (operateInLegacyMode) {
                return self.isLoggedIn
            } else {
                return self.cachedLoginsMap.count > 0
            }
        }
    }
    @available(*, deprecated, renamed: "default")
    @objc override public class func sharedInstance() -> AWSMobileClient {
        return self.default()
    }
    @objc public class func `default`() -> AWSMobileClient {
        return _sharedInstance
    }
    public func handleAuthResponse(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) {
        if (isCognitoAuthRegistered) {
            AWSCognitoAuth.init(forKey: CognitoAuthRegistrationKey).application(application, open: url, options: [:])
        }
    }
    public func initialize(_ completionHandler: @escaping (UserState?, Error?) -> Void) {
        initializationQueue.sync {
            if (operateInLegacyMode) {
                completionHandler(nil, AWSMobileClientError.invalidState(message: "The AWSMobileClient is being used in the legacy mode. To use this initialize method please refer to the documentation."))
                return
            }
            if (isInitialized) {
                completionHandler(self.currentUserState, nil)
                return
            }
            self.loadLoginsMapFromKeychain()
            self.loadFederationProviderMetadataFromKeychain()
            DeviceOperations.sharedInstance.mobileClient = self
            if self.federationProvider == .none && self.cachedLoginsMap.count > 0 {
                if self.userPoolClient?.currentUser()?.isSignedIn == true {
                    self.federationProvider = .userPools
                } else {
                    self.federationProvider = .oidcFederation
                }
            }
            if self.federationProvider == .hostedUI {
                loadHostedUIScopesFromKeychain()
                loadOAuthURIQueryParametersFromKeychain()
                let infoDictionaryMobileClient = self.awsInfo.rootInfoDictionary["Auth"] as? [String: [String: Any]]
                let infoDictionary: [String: Any]? = infoDictionaryMobileClient?["Default"]?["OAuth"] as? [String: Any]
                let clientId = infoDictionary?["AppClientId"] as? String
                let secret = infoDictionary?["AppClientSecret"] as? String
                let webDomain = infoDictionary?["WebDomain"] as? String
                let hostURL = "https:
                if self.scopes == nil {
                    self.scopes = infoDictionary?["Scopes"] as? [String]
                }
                let signInRedirectURI = infoDictionary?["SignInRedirectURI"] as? String
                let signInURI = infoDictionary?["SignInURI"] as? String
                if self.signInURIQueryParameters == nil {
                    self.signInURIQueryParameters = infoDictionary?["SignInURIQueryParameters"] as? [String: String]
                }
                let signOutRedirectURI = infoDictionary?["SignOutRedirectURI"] as? String
                let signOutURI = infoDictionary?["SignOutURI"] as? String
                if self.signOutURIQueryParameters == nil {
                    self.signOutURIQueryParameters = infoDictionary?["SignOutURIQueryParameters"] as? [String: String]
                }
                let tokensURI = infoDictionary?["TokenURI"] as? String
                if self.tokenURIQueryParameters == nil {
                    self.tokenURIQueryParameters = infoDictionary?["TokenURIQueryParameters"] as? [String: String]
                }
                if (clientId == nil || scopes == nil || signInRedirectURI == nil || signOutRedirectURI == nil) {
                    completionHandler(nil, AWSMobileClientError.invalidConfiguration(message: "Please provide all configuration parameters to use the hosted UI feature."))
                }
                let cognitoAuthConfig: AWSCognitoAuthConfiguration = AWSCognitoAuthConfiguration.init(appClientId: clientId!,
                                                                                                      appClientSecret: secret,
                                                                                                      scopes: Set<String>(self.scopes!.map { $0 }),
                                                                                                      signInRedirectUri: signInRedirectURI!,
                                                                                                      signOutRedirectUri: signOutRedirectURI!,
                                                                                                      webDomain: hostURL,
                                                                                                      identityProvider: nil,
                                                                                                      idpIdentifier: nil,
                                                                                                      signInUri: signInURI,
                                                                                                      signOutUri: signOutURI,
                                                                                                      tokensUri: tokensURI,
                                                                                                      signInUriQueryParameters: self.signInURIQueryParameters,
                                                                                                      signOutUriQueryParameters: self.signOutURIQueryParameters,
                                                                                                      tokenUriQueryParameters: self.tokenURIQueryParameters,
                                                                                                      userPoolServiceConfiguration: AWSMobileClient.serviceConfiguration?.userPoolServiceConfiguration)
                if (isCognitoAuthRegistered) {
                    AWSCognitoAuth.remove(forKey: CognitoAuthRegistrationKey)
                }
                AWSCognitoAuth.registerCognitoAuth(with: cognitoAuthConfig, forKey: CognitoAuthRegistrationKey)
                isCognitoAuthRegistered = true
                let cognitoAuth = AWSCognitoAuth.init(forKey: CognitoAuthRegistrationKey)
                cognitoAuth.delegate = self
            }
            let infoDictionaryMobileClient = self.awsInfo.rootInfoDictionary["Auth"] as? [String: [String: Any]]
            if let authFlowType = infoDictionaryMobileClient?["Default"]?["authenticationFlowType"] as? String,
                authFlowType == "CUSTOM_AUTH" {
                self.userPoolClient?.isCustomAuth = true
            }
            let infoObject = AWSInfo.default().defaultServiceInfo("IdentityManager")
            if let credentialsProvider = infoObject?.cognitoCredentialsProvider {
                self.isAuthorizationAvailable = true
                self.internalCredentialsProvider = credentialsProvider
                self.update(self)
                self.internalCredentialsProvider?.setIdentityProviderManagerOnce(self)
                self.registerConfigSignInProviders()
               if (self.internalCredentialsProvider?.identityId != nil) {
                    if (federationProvider == .none) {
                        currentUserState = .guest
                        completionHandler(.guest, nil)
                    } else {
                        currentUserState = .signedIn
                        completionHandler(.signedIn, nil)
                    }
               } else  if (self.cachedLoginsMap.count > 0) {
                currentUserState = .signedIn
                completionHandler(.signedIn, nil)
               } else {
                    currentUserState = .signedOut
                    completionHandler(.signedOut, nil)
                }
            } else if self.cachedLoginsMap.count > 0 {
                currentUserState = .signedIn
                completionHandler(.signedIn, nil)
            } else {
                currentUserState = .signedOut
                completionHandler(.signedOut, nil)
            }
            isInitialized = true
        }
    }
    public func addUserStateListener(_ object: AnyObject, _ callback: @escaping UserStateChangeCallback)  {
        listeners.append((object, callback))
    }
    public func removeUserStateListener(_ object: AnyObject) {
         listeners = listeners.filter { return !($0.0 === object)}
    }
    internal func mobileClientStatusChanged(userState: UserState, additionalInfo: [String: String]) {
        self.currentUserState = userState
        for listener in listeners {
            listener.1(userState, additionalInfo)
        }
    }
    internal func getTokensForCognitoAuthSession(session: AWSCognitoAuthUserSession) -> Tokens {
        return Tokens(idToken: SessionToken(tokenString: session.idToken?.tokenString),
                      accessToken: SessionToken(tokenString: session.accessToken?.tokenString),
                      refreshToken: SessionToken(tokenString: session.refreshToken?.tokenString),
                      expiration: session.expirationTime)
    }
    public func showSignIn(navigationController: UINavigationController,
                           signInUIOptions: SignInUIOptions = SignInUIOptions(),
                           hostedUIOptions: HostedUIOptions? = nil,
                           _ completionHandler: @escaping(UserState?, Error?) -> Void) {
        switch self.currentUserState {
        case .signedIn:
            completionHandler(nil, AWSMobileClientError.invalidState(message: "There is already a user which is signed in. Please log out the user before calling showSignIn."))
            return
        default:
            break
        }
        if let hostedUIOptions = hostedUIOptions {
            developerNavigationController = navigationController
            loadOAuthURIQueryParametersFromKeychain()
            let infoDictionaryMobileClient = AWSInfo.default().rootInfoDictionary["Auth"] as? [String: [String: Any]]
            let infoDictionary: [String: Any]? = infoDictionaryMobileClient?["Default"]?["OAuth"] as? [String: Any]
            let clientId = infoDictionary?["AppClientId"] as? String
            let secret = infoDictionary?["AppClientSecret"] as? String
            let webDomain = infoDictionary?["WebDomain"] as? String
            let hostURL = "https:
            let signInRedirectURI = infoDictionary?["SignInRedirectURI"] as? String
            let signInURI = infoDictionary?["SignInURI"] as? String
            if self.signInURIQueryParameters == nil {
                self.signInURIQueryParameters = infoDictionary?["SignInURIQueryParameters"] as? [String: String]
            }
            let signOutRedirectURI = infoDictionary?["SignOutRedirectURI"] as? String
            let signOutURI = infoDictionary?["SignOutURI"] as? String
            if self.signOutURIQueryParameters == nil {
                self.signOutURIQueryParameters = infoDictionary?["SignOutURIQueryParameters"] as? [String: String]
            }
            let tokensURI = infoDictionary?["TokenURI"] as? String
            if self.tokenURIQueryParameters == nil {
                self.tokenURIQueryParameters = infoDictionary?["TokenURIQueryParameters"] as? [String: String]
            }
            let identityProvider = hostedUIOptions.identityProvider
            let idpIdentifier = hostedUIOptions.idpIdentifier
            let federationProviderIdentifier = hostedUIOptions.federationProviderName
            if hostedUIOptions.scopes != nil {
                self.scopes = hostedUIOptions.scopes
            }
            else {
                self.scopes = infoDictionary?["Scopes"] as? [String]
                self.clearHostedUIOptionsScopesFromKeychain()
            }
            if hostedUIOptions.signInURIQueryParameters != nil {
                self.signInURIQueryParameters = hostedUIOptions.signInURIQueryParameters
            }
            if hostedUIOptions.tokenURIQueryParameters != nil {
                self.tokenURIQueryParameters = hostedUIOptions.tokenURIQueryParameters
            }
            if hostedUIOptions.signOutURIQueryParameters != nil {
                self.signOutURIQueryParameters = hostedUIOptions.signOutURIQueryParameters
            }
            saveOAuthURIQueryParametersInKeychain()
            if (clientId == nil || scopes == nil || signInRedirectURI == nil || signOutRedirectURI == nil) {
                completionHandler(nil, AWSMobileClientError.invalidConfiguration(message: "Please provide all configuration parameters to use the hosted UI feature."))
            }
            let cognitoAuthConfig: AWSCognitoAuthConfiguration = AWSCognitoAuthConfiguration.init(appClientId: clientId!,
                                             appClientSecret: secret,
                                             scopes: Set<String>(self.scopes!.map { $0 }),
                                             signInRedirectUri: signInRedirectURI!,
                                             signOutRedirectUri: signOutRedirectURI!,
                                             webDomain: hostURL,
                                             identityProvider: identityProvider,
                                             idpIdentifier: idpIdentifier,
                                             signInUri: signInURI,
                                             signOutUri: signOutURI,
                                             tokensUri: tokensURI,
                                             signInUriQueryParameters: self.signInURIQueryParameters,
                                             signOutUriQueryParameters: self.signOutURIQueryParameters,
                                             tokenUriQueryParameters: self.tokenURIQueryParameters,
                                             userPoolServiceConfiguration: AWSMobileClient.serviceConfiguration?.userPoolServiceConfiguration)
            if (isCognitoAuthRegistered) {
                AWSCognitoAuth.remove(forKey: CognitoAuthRegistrationKey)
            }
            AWSCognitoAuth.registerCognitoAuth(with: cognitoAuthConfig, forKey: CognitoAuthRegistrationKey)
            isCognitoAuthRegistered = true
            let cognitoAuth = AWSCognitoAuth.init(forKey: CognitoAuthRegistrationKey)
            cognitoAuth.delegate = self
            cognitoAuth.getSession(navigationController.viewControllers.first!) { (session, error) in
                guard error == nil else {
                    completionHandler(nil, error)
                    return
                }
                if let session = session {
                    var signInInfo = [String: String]()
                    var federationToken: String? = nil
                    if let idToken = session.idToken?.tokenString {
                        federationToken = idToken
                    } else if let accessToken = session.accessToken?.tokenString {
                        federationToken = accessToken
                    }
                    guard federationToken != nil else {
                        completionHandler(nil, AWSMobileClientError.idTokenAndAcceessTokenNotIssued(message: "No ID token or access token was issued."))
                        return
                    }
                    if let identityProvider = hostedUIOptions.identityProvider {
                        signInInfo["identityProvider"] = identityProvider
                    }
                    if let idpIdentifier = hostedUIOptions.idpIdentifier {
                        signInInfo["idpIdentifier"] = idpIdentifier
                    }
                    signInInfo[self.TokenKey] = session.accessToken!.tokenString
                    signInInfo[self.ProviderKey] = "OAuth"
                    if hostedUIOptions.scopes != nil {
                        self.saveHostedUIOptionsScopesInKeychain()
                    }
                    self.performHostedUISuccessfulSignInTasks(disableFederation: hostedUIOptions.disableFederation, session: session, federationToken: federationToken!, federationProviderIdentifier: federationProviderIdentifier, signInInfo: &signInInfo)
                    self.mobileClientStatusChanged(userState: .signedIn, additionalInfo: signInInfo)
                    completionHandler(.signedIn, nil)
                    if self.pendingGetTokensCompletion != nil {
                        self.tokenFetchLock.leave()
                    }
                    self.pendingGetTokensCompletion?(self.getTokensForCognitoAuthSession(session: session), nil)
                    self.pendingGetTokensCompletion = nil
                }
            }
        } else {
            self.showSign(inScreen: navigationController, signInUIConfiguration: signInUIOptions, completionHandler: { providerName, token, error in
                if error == nil {
                    if (providerName == IdentityProvider.facebook.rawValue) || (providerName == IdentityProvider.google.rawValue || providerName == IdentityProvider.apple.rawValue) {
                        self.federatedSignIn(providerName: providerName!, token: token!, completionHandler: completionHandler)
                    } else {
                        self.currentUser?.getSession().continueWith(block: { (task) -> Any? in
                            if let session = task.result {
                                self.performUserPoolSuccessfulSignInTasks(session: session)
                                let tokenString = session.idToken!.tokenString
                                self.mobileClientStatusChanged(userState: .signedIn,
                                                               additionalInfo: [self.ProviderKey:self.userPoolClient!.identityProviderName,
                                                                                self.TokenKey:tokenString])
                                completionHandler(.signedIn, nil)
                            } else {
                                completionHandler(nil, task.error)
                            }
                            return nil
                        })
                    }
                } else {
                    if ((error! as NSError).domain == "AWSMobileClientError") {
                        if error!._code == -1 {
                            completionHandler(nil, AWSMobileClientError.invalidState(message: "AWSAuthUI dependency is required to show the signIn screen. Please import the dependency before using this API."))
                            return
                        } else if error!._code == -2 {
                            completionHandler(nil, AWSMobileClientError.userCancelledSignIn(message: "The user cancelled the sign in operation."))
                            return
                        }
                    }
                    completionHandler(nil, error)
                }
            })
        }
    }
}
extension AWSMobileClient {
    override public func credentials() -> AWSTask<AWSCredentials> {
        let credentialsTaskCompletionSource: AWSTaskCompletionSource<AWSCredentials> = AWSTaskCompletionSource()
        self.getAWSCredentials { (credentials, error) in
            if let credentials = credentials {
                credentialsTaskCompletionSource.set(result: credentials)
            } else if let error = error {
                credentialsTaskCompletionSource.set(error: error)
            }
        }
        return credentialsTaskCompletionSource.task
    }
    override public func invalidateCachedTemporaryCredentials() {
        self.internalCredentialsProvider?.invalidateCachedTemporaryCredentials()
    }
    override public func getIdentityId() -> AWSTask<NSString> {
        guard self.internalCredentialsProvider != nil else {
            return AWSTask(error: AWSMobileClientError.cognitoIdentityPoolNotConfigured(message: "Cannot get identityId since cognito credentials configuration is not available."))
        }
        let identityFetchTaskCompletionSource: AWSTaskCompletionSource<NSString> = AWSTaskCompletionSource()
        self.internalCredentialsProvider?.getIdentityId().continueWith(block: { (task) -> Any? in
            if let error = task.error {
                if error._domain == AWSCognitoCredentialsProviderHelperErrorDomain
                    && error._code == AWSCognitoCredentialsProviderHelperErrorType.identityIsNil.rawValue {
                    identityFetchTaskCompletionSource.set(error: AWSMobileClientError.identityIdUnavailable(message: "Fetching identity id on another thread failed. Please retry by calling `getIdentityId()` method."))
                } else {
                    identityFetchTaskCompletionSource.set(error: error)
                }
            } else if let result = task.result {
                identityFetchTaskCompletionSource.set(result: result)
            }
            return nil
        })
        return identityFetchTaskCompletionSource.task
    }
    override public func clearCredentials() {
        self.internalCredentialsProvider?.clearCredentials()
    }
    override public func clearKeychain() {
        self.internalCredentialsProvider?.clearKeychain()
    }
}
public extension AWSMobileClient {
    static func updateCognitoService(userPoolConfiguration: AWSServiceConfiguration?,
                                     identityPoolConfiguration: AWSServiceConfiguration?) {
        let configuration = CognitoServiceConfiguration(userPoolServiceConfiguration: userPoolConfiguration,
                                                        identityPoolServiceConfiguration: identityPoolConfiguration)
        self.serviceConfiguration = configuration
        UserPoolOperationsHandler.serviceConfiguration = configuration
        AWSInfo.configureIdentityPoolService(configuration.identityPoolServiceConfiguration)
    }
}
struct CognitoServiceConfiguration {
    let userPoolServiceConfiguration: AWSServiceConfiguration?
    let identityPoolServiceConfiguration: AWSServiceConfiguration?
}