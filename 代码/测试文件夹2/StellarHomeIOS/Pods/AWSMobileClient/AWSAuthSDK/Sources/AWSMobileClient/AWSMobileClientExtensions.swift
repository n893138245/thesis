import Foundation
import AWSCognitoIdentityProvider
public struct SessionToken {
    public let tokenString: String?
    public var claims: [String: AnyObject]? {
        if tokenString == nil {
            return nil
        } else {
            let tokenSplit = tokenString!.split(separator: ".")
            guard tokenSplit.count > 2 else {
                print("Token is not valid base64 encoded string.")
                return nil
            }
            let claims = tokenSplit[1]
                .replacingOccurrences(of: "-", with: "+")
                .replacingOccurrences(of: "_", with: "/")
            let paddedLength = claims.count + (4 - (claims.count % 4)) % 4
            let updatedClaims = claims.padding(toLength: paddedLength, withPad: "=", startingAt: 0)
            let encodedData = Data(base64Encoded: updatedClaims, options: .ignoreUnknownCharacters)
            guard let claimsData = encodedData else {
                print("Cannot get claims in `Data` form. Token is not valid base64 encoded string.")
                return nil
            }
            let jsonObject = try? JSONSerialization.jsonObject(with: claimsData, options: [])
            guard let convertedDictionary = jsonObject as? [String: AnyObject] else {
                print("Cannot get claims in `Data` form. Token is not valid JSON string.")
                return nil
            }
            return convertedDictionary
        }
    }
    init(tokenString: String?) {
        self.tokenString = tokenString
    }
}
public struct Tokens {
    public let idToken: SessionToken?
    public let accessToken: SessionToken?
    public let refreshToken: SessionToken?
    public let expiration: Date?
}
extension AWSMobileClient: AWSIdentityProviderManager {
    public func logins() -> AWSTask<NSDictionary> {
        let dict = NSMutableDictionary.init()
        if federationProvider == .none {
        } else if federationProvider == .userPools {
            let userPoolsTokenTask: AWSTaskCompletionSource<NSDictionary> = AWSTaskCompletionSource.init()
            self.getTokens { [weak self] (tokens, error) in
                self?.setLoginMap(using: tokens, and: error, to: userPoolsTokenTask)
            }
            return userPoolsTokenTask.task
        } else if federationProvider == .oidcFederation {
            dict.addEntries(from: self.cachedLoginsMap)
        } else if federationProvider == .hostedUI {
            if !federationDisabled {
                let hostedUITokenTask: AWSTaskCompletionSource<NSDictionary> = AWSTaskCompletionSource.init()
                self.getTokens { [weak self] (tokens, error) in
                    self?.setLoginMap(using: tokens, and: error, to: hostedUITokenTask)
                }
                return hostedUITokenTask.task
            }
        }
        let task = AWSTask.init(result: dict as NSDictionary)
        return task
    }
    func setLoginMap(using tokens: Tokens?, and error: Error?, to task: AWSTaskCompletionSource<NSDictionary>) {
        guard let tokens = tokens else {
            let idTokenError = error != nil ? error! :
                AWSMobileClientError.unknown(message: "Could not read the id token or error from the token response")
            task.set(error: idTokenError)
            return
        }
        guard let idToken = tokens.idToken, let tokenString = idToken.tokenString else {
            let errorString = "Could not read the id token from the token response"
            let error = AWSMobileClientError.idTokenNotIssued(message: errorString)
            task.set(error: error)
            return
        }
        let providerName = self.userPoolClient!.identityProviderName as NSString
        let dict = NSDictionary(object: tokenString, forKey: providerName)
        task.set(result: dict)
    }
}
extension AWSMobileClient {
    internal convenience init(setDelegate: Bool) {
        self.init()
        if (setDelegate) {
            UserPoolOperationsHandler.sharedInstance.authHelperDelegate = self
        }
    }
    internal var userpoolOpsHelper: UserPoolOperationsHandler {
        return UserPoolOperationsHandler.sharedInstance
    }
    internal var userPoolClient: AWSCognitoIdentityUserPool? {
        return self.userpoolOpsHelper.userpoolClient
    }
    internal var currentUser: AWSCognitoIdentityUser? {
        return self.userPoolClient?.currentUser()
    }
    internal func invokeSignInCallback(signResult: SignInResult?, error: Error?) {
        if let signCallback = userpoolOpsHelper.currentSignInHandlerCallback {
            invalidateSignInCallbacks()
            signCallback(signResult, error)
        } else if let confirmSignCallback = userpoolOpsHelper.currentConfirmSignInHandlerCallback {
            invalidateSignInCallbacks()
            confirmSignCallback(signResult, error)
        }
    }
    internal func invalidateSignInCallbacks() {
        userpoolOpsHelper.currentSignInHandlerCallback = nil
        userpoolOpsHelper.currentConfirmSignInHandlerCallback = nil
    }
    public func signIn(username: String,
                       password: String,
                       validationData: [String: String]? = nil,
                       clientMetaData: [String: String] = [:],
                       completionHandler: @escaping ((SignInResult?, Error?) -> Void)) {
        switch self.currentUserState {
        case .signedIn:
            completionHandler(nil, AWSMobileClientError.invalidState(message: "There is already a user which is signed in. Please log out the user before calling showSignIn."))
            return
        default:
            break
        }
        self.userpoolOpsHelper.userpoolClient?.delegate = self.userpoolOpsHelper
        self.userpoolOpsHelper.authHelperDelegate = self
        let user = self.userPoolClient?.getUser(username)
        self.userpoolOpsHelper.currentSignInHandlerCallback = completionHandler
        var validationAttributes: [AWSCognitoIdentityUserAttributeType]? = nil
        if (validationData != nil) {
            validationAttributes = validationData!.map {AWSCognitoIdentityUserAttributeType.init(name: $0, value: $1) }
        }
        if (self.userpoolOpsHelper.passwordAuthTaskCompletionSource != nil) {
            let authDetails = AWSCognitoIdentityPasswordAuthenticationDetails(username: username, password: password)
            authDetails?.validationData = validationAttributes
            self.userpoolOpsHelper.passwordAuthTaskCompletionSource!.set(result: authDetails)
            self.userpoolOpsHelper.passwordAuthTaskCompletionSource = nil
        } else if (self.userpoolOpsHelper.customAuthChallengeTaskCompletionSource != nil) {
            let details = AWSCognitoIdentityCustomChallengeDetails(challengeResponses: ["USERNAME": username])
            details.initialChallengeName = "SRP_A"
            self.userpoolOpsHelper.customAuthChallengeTaskCompletionSource?.set(result: details)
            self.userpoolOpsHelper.customAuthChallengeTaskCompletionSource = nil
        } else {
            let isCustomAuth = self.userPoolClient?.isCustomAuth ?? false
            if (isCustomAuth) {
                userPassword = password
            }
            user!.getSession(username,
                             password: password,
                             validationData: validationAttributes,
                             clientMetaData: clientMetaData,
                             isInitialCustomChallenge: isCustomAuth).continueWith { (task) -> Any? in
                if let error = task.error {
                    self.invokeSignInCallback(signResult: nil, error: AWSMobileClientError.makeMobileClientError(from: error))
                } else if let result = task.result {
                    self.internalCredentialsProvider?.clearCredentials()
                    self.federationProvider = .userPools
                    self.performUserPoolSuccessfulSignInTasks(session: result)
                    let tokenString = result.idToken!.tokenString
                    self.mobileClientStatusChanged(userState: .signedIn,
                                                   additionalInfo: [self.ProviderKey:self.userPoolClient!.identityProviderName,
                                                                    self.TokenKey:tokenString])
                    self.invokeSignInCallback(signResult: SignInResult(signInState: .signedIn), error: nil)
                }
                return nil
            }
        }
    }
    public func federatedSignIn(providerName: String, token: String,
                                federatedSignInOptions: FederatedSignInOptions = FederatedSignInOptions(),
                                completionHandler: @escaping ((UserState?, Error?) -> Void)) {
        self.tokenFetchOperationQueue.addOperation {
            var error: Error?
            defer {
                if error == nil {
                    self.mobileClientStatusChanged(userState: .signedIn,
                                                   additionalInfo: [self.ProviderKey:providerName, self.TokenKey: token])
                    completionHandler(UserState.signedIn, nil)
                } else {
                    completionHandler(nil, error)
                }
            }
            guard self.federationProvider != .userPools else {
                error = AWSMobileClientError.federationProviderExists(message: "User is already signed in. Please sign out before calling this method.")
                return
            }
            if self.federationProvider == .oidcFederation { 
                if let devAuthenticatedIdentityId = federatedSignInOptions.cognitoIdentityId {
                    self.internalCredentialsProvider?.identityProvider.identityId = devAuthenticatedIdentityId
                }
                if let customRoleArn = federatedSignInOptions.customRoleARN {
                    self.customRoleArnInternal = customRoleArn
                    self.setCustomRoleArnInternal(customRoleArn, for: self)
                }
                self.performFederatedSignInTasks(provider: providerName, token: token)
                if (self.pendingAWSCredentialsCompletion != nil) {
                    self.internalCredentialsProvider?.credentials().continueWith(block: { (task) -> Any? in
                        if let credentials = task.result {
                            self.pendingAWSCredentialsCompletion?(credentials, nil)
                        } else if let error = task.error {
                            self.pendingAWSCredentialsCompletion?(nil, error)
                        }
                        self.credentialsFetchLock.leave()
                        self.pendingAWSCredentialsCompletion = nil
                        return nil
                    })
                }
            } else { 
                if providerName == IdentityProvider.developer.rawValue {
                    if let devAuthenticatedIdentityId = federatedSignInOptions.cognitoIdentityId {
                        self.internalCredentialsProvider?.identityProvider.identityId = devAuthenticatedIdentityId
                    } else {
                        error = AWSMobileClientError.invalidParameter(message: "For using developer authenticated identities, you need to specify the `CognitoIdentityId` in `FederatedSignInOptions`.")
                        return
                    }
                }
                if let customRoleArn = federatedSignInOptions.customRoleARN {
                    self.customRoleArnInternal = customRoleArn
                    self.setCustomRoleArnInternal(customRoleArn, for: self)
                }
                self.performFederatedSignInTasks(provider: providerName, token: token)
            }
        }
    }
    public func signUp(username: String,
                       password: String,
                       userAttributes: [String: String] = [:],
                       validationData: [String: String] = [:],
                       clientMetaData: [String:String] = [:],
                       completionHandler: @escaping ((SignUpResult?, Error?) -> Void)) {
        if (self.userPoolClient == nil) { completionHandler(nil, AWSMobileClientError.userPoolNotConfigured(message: "Cognito User Pools is not configured in `awsconfiguration.json`. Please add Cognito User Pools before using this API."))}
        let userAttributesTransformed = userAttributes.map {AWSCognitoIdentityUserAttributeType.init(name: $0, value: $1) }
        let validationDataTransformed = validationData.map {AWSCognitoIdentityUserAttributeType.init(name: $0, value: $1) }
        self.userPoolClient?.signUp(username, password: password,
                                   userAttributes: userAttributesTransformed.count == 0 ? nil : userAttributesTransformed,
                                   validationData: validationDataTransformed.count == 0 ? nil : validationDataTransformed,
                                   clientMetaData: clientMetaData).continueWith { (task) -> Any? in
            if let error = task.error {
                completionHandler(nil, AWSMobileClientError.makeMobileClientError(from: error))
            } else if let result = task.result {
                self.userpoolOpsHelper.signUpUser = task.result?.user
                var confirmedStatus: SignUpConfirmationState?
                if(result.userConfirmed!.intValue == 1) {
                    confirmedStatus = .confirmed
                } else {
                    confirmedStatus = .unconfirmed
                }
                var codeDeliveryDetails: UserCodeDeliveryDetails? = nil
                if let deliveryDetails = result.codeDeliveryDetails {
                    switch(deliveryDetails.deliveryMedium) {
                    case .email:
                        codeDeliveryDetails = UserCodeDeliveryDetails(deliveryMedium: .email, destination: deliveryDetails.destination, attributeName: deliveryDetails.attributeName)
                    case .sms:
                        codeDeliveryDetails = UserCodeDeliveryDetails(deliveryMedium: .sms, destination: deliveryDetails.destination, attributeName: deliveryDetails.attributeName)
                    case .unknown:
                        codeDeliveryDetails = UserCodeDeliveryDetails(deliveryMedium: .unknown, destination: deliveryDetails.destination, attributeName: deliveryDetails.attributeName)
                    @unknown default:
                        codeDeliveryDetails = UserCodeDeliveryDetails(deliveryMedium: .unknown, destination: deliveryDetails.destination, attributeName: deliveryDetails.attributeName)
                    }
                }
                completionHandler(SignUpResult(signUpState: confirmedStatus!, codeDeliveryDetails: codeDeliveryDetails), nil)
            }
            return nil
        }
    }
    public func confirmSignUp(username: String,
                              confirmationCode: String,
                              clientMetaData: [String:String] = [:],
                              completionHandler: @escaping ((SignUpResult?, Error?) -> Void)) {
        if let uname = self.userpoolOpsHelper.signUpUser?.username, uname == username {
            confirmSignUp(user: self.userpoolOpsHelper.signUpUser!,
                          confirmationCode: confirmationCode,
                          clientMetaData: clientMetaData,
                          completionHandler: completionHandler)
        } else {
            let user = self.userPoolClient?.getUser(username)
            confirmSignUp(user: user!,
                          confirmationCode: confirmationCode,
                          clientMetaData: clientMetaData,
                          completionHandler: completionHandler)
        }
    }
    internal func confirmSignUp(user: AWSCognitoIdentityUser,
                                confirmationCode: String,
                                clientMetaData: [String:String] = [:],
                                completionHandler: @escaping ((SignUpResult?, Error?) -> Void)) {
        user.confirmSignUp(confirmationCode, clientMetaData: clientMetaData).continueWith { (task) -> Any? in
            if let error = task.error {
                completionHandler(nil, AWSMobileClientError.makeMobileClientError(from: error))
            } else if let _ = task.result {
                let signUpResult = SignUpResult(signUpState: .confirmed, codeDeliveryDetails: nil)
                completionHandler(signUpResult, nil)
            }
            return nil
        }
    }
    public func resendSignUpCode(username: String,
                                 clientMetaData: [String:String] = [:],
                                 completionHandler: @escaping ((SignUpResult?, Error?) -> Void)) {
        if let uname = self.userpoolOpsHelper.signUpUser?.username, uname == username {
            resendSignUpCode(user: self.userpoolOpsHelper.signUpUser!, clientMetaData: clientMetaData, completionHandler: completionHandler)
        } else {
            let user = self.userPoolClient?.getUser(username)
            resendSignUpCode(user: user!, clientMetaData: clientMetaData, completionHandler: completionHandler)
        }
    }
    internal func resendSignUpCode(user: AWSCognitoIdentityUser,
                                   clientMetaData: [String:String] = [:],
                                   completionHandler: @escaping ((SignUpResult?, Error?) -> Void)) {
        user.resendConfirmationCode(clientMetaData).continueWith(block: { (task) -> Any? in
            if let error = task.error {
                completionHandler(nil, AWSMobileClientError.makeMobileClientError(from: error))
            } else if let result = task.result {
                let confirmedStatus: SignUpConfirmationState = .unconfirmed
                var codeDeliveryDetails: UserCodeDeliveryDetails? = nil
                if let deliveryDetails = result.codeDeliveryDetails {
                    codeDeliveryDetails = UserCodeDeliveryDetails.getUserCodeDeliveryDetails(deliveryDetails)
                }
                completionHandler(SignUpResult(signUpState: confirmedStatus, codeDeliveryDetails: codeDeliveryDetails), nil)
            }
            return nil
        })
    }
    public func forgotPassword(username: String,
                               clientMetaData: [String:String] = [:],
                               completionHandler: @escaping ((ForgotPasswordResult?, Error?) -> Void)) {
        let user = self.userPoolClient?.getUser(username)
        user!.forgotPassword(clientMetaData).continueWith { (task) -> Any? in
            if let error = task.error {
                completionHandler(nil, AWSMobileClientError.makeMobileClientError(from: error))
            } else if let result = task.result {
                var codeDeliveryDetails: UserCodeDeliveryDetails? = nil
                if let deliveryDetails = result.codeDeliveryDetails {
                    codeDeliveryDetails = UserCodeDeliveryDetails.getUserCodeDeliveryDetails(deliveryDetails)
                }
                completionHandler(ForgotPasswordResult(forgotPasswordState: .confirmationCodeSent, codeDeliveryDetails: codeDeliveryDetails), nil)
            }
            return nil
        }
    }
    public func confirmForgotPassword(username: String,
                                      newPassword: String,
                                      confirmationCode: String,
                                      clientMetaData: [String:String] = [:],
                                      completionHandler: @escaping ((ForgotPasswordResult?, Error?) -> Void)) {
        let user = self.userPoolClient?.getUser(username)
        user!.confirmForgotPassword(confirmationCode, password: newPassword, clientMetaData: clientMetaData).continueWith { (task) -> Any? in
            if let error = task.error {
                completionHandler(nil, AWSMobileClientError.makeMobileClientError(from: error))
            } else if let _ = task.result {
                completionHandler(ForgotPasswordResult(forgotPasswordState: .done, codeDeliveryDetails: nil), nil)
            }
            return nil
        }
    }
    public func signOut(options: SignOutOptions = SignOutOptions(), completionHandler: @escaping ((Error?) -> Void)) {
        if federationProvider == .hostedUI {
            if options.invalidateTokens {
                AWSCognitoAuth.init(forKey: CognitoAuthRegistrationKey).signOut { (error) in
                    if (error != nil) {
                        completionHandler(AWSMobileClientError.makeMobileClientError(from: error!))
                    } else {
                        self.signOut()
                        completionHandler(nil)
                    }
                }
            }
            return
        }
        if federationProvider == .userPools && options.signOutGlobally == true {
            let _ = self.userpoolOpsHelper.currentActiveUser!.globalSignOut().continueWith { (task) -> Any? in
                if task.result != nil {
                    self.signOut()
                    completionHandler(nil)
                } else if let error = task.error {
                    completionHandler(AWSMobileClientError.makeMobileClientError(from: error))
                }
                return nil
            }
            return
        }
        signOut()
        completionHandler(nil)
    }
    public func signOut() {
        self.credentialsFetchCancellationSource.cancel()
        if federationProvider == .hostedUI {
            AWSCognitoAuth.init(forKey: CognitoAuthRegistrationKey).signOutLocallyAndClearLastKnownUser()
        }
        self.cachedLoginsMap = [:]
        self.customRoleArnInternal = nil
        self.setCustomRoleArnInternal(nil, for: self)
        self.saveLoginsMapInKeychain()
        self.setLoginProviderMetadataAndSaveInKeychain(provider: .none)
        self.performUserPoolSignOut()
        self.internalCredentialsProvider?.identityProvider.identityId = nil
        self.internalCredentialsProvider?.clearKeychain()
        self.mobileClientStatusChanged(userState: .signedOut, additionalInfo: [:])
        self.federationProvider = .none
        self.credentialsFetchCancellationSource = AWSCancellationTokenSource()
        self.clearHostedUIOptionsScopesFromKeychain()
    }
    internal func performUserPoolSignOut() {
        if let task = self.userpoolOpsHelper.passwordAuthTaskCompletionSource?.task, !task.isCompleted {
            let error = AWSMobileClientError.unableToSignIn(message: "Could not get end user to sign in.")
            self.userpoolOpsHelper.passwordAuthTaskCompletionSource?.set(error: error)
        }
        self.userpoolOpsHelper.passwordAuthTaskCompletionSource = nil
        if let task = self.userpoolOpsHelper.customAuthChallengeTaskCompletionSource?.task, !task.isCompleted {
            let error = AWSMobileClientError.unableToSignIn(message: "Could not get end user to sign in.")
            self.userpoolOpsHelper.customAuthChallengeTaskCompletionSource?.set(error: error)
        }
        self.userpoolOpsHelper.customAuthChallengeTaskCompletionSource = nil
        invokeSignInCallback(signResult: nil, error: AWSMobileClientError.unableToSignIn(message: "Could not get end user to sign in."))
        self.userPoolClient?.clearAll()
    }
    internal func performUserPoolSuccessfulSignInTasks(session: AWSCognitoIdentityUserSession) {
        let tokenString = session.idToken!.tokenString
        self.developerNavigationController = nil
        self.cachedLoginsMap = [self.userPoolClient!.identityProviderName: tokenString]
        postSignInKeychainAndCredentialsUpdate(provider: .userPools,
                                               additionalInfo: [ProviderKey:self.userPoolClient!.identityProviderName, TokenKey:tokenString])
    }
    internal func performHostedUISuccessfulSignInTasks(disableFederation: Bool = false,
                                                       session: AWSCognitoAuthUserSession,
                                                       federationToken: String,
                                                       federationProviderIdentifier: String? = nil,
                                                       signInInfo: inout [String: String]) {
        federationDisabled = disableFederation
        if federationProviderIdentifier == nil {
            self.cachedLoginsMap = [self.userPoolClient!.identityProviderName: federationToken]
        } else {
            self.cachedLoginsMap = [federationProviderIdentifier!: federationToken]
        }
        postSignInKeychainAndCredentialsUpdate(provider: .hostedUI,
                                               additionalInfo: signInInfo)
    }
    internal func performFederatedSignInTasks(provider: String, token: String) {
        self.cachedLoginsMap = [provider:token]
        self.federationProvider = .oidcFederation
        postSignInKeychainAndCredentialsUpdate(provider: .oidcFederation,
                                               additionalInfo: [ProviderKey:provider, TokenKey: token])
    }
    internal func postSignInKeychainAndCredentialsUpdate(provider: FederationProvider, additionalInfo: [String: String]) {
        self.saveLoginsMapInKeychain()
        self.setLoginProviderMetadataAndSaveInKeychain(provider: provider)
        self.internalCredentialsProvider?.clearCredentials()
        self.internalCredentialsProvider?.credentials(withCancellationToken:self.credentialsFetchCancellationSource)
    }
    public func confirmSignIn(challengeResponse: String,
                              userAttributes: [String:String] = [:],
                              clientMetaData: [String:String] = [:],
                              completionHandler: @escaping ((SignInResult?, Error?) -> Void)) {
        if (self.userpoolOpsHelper.mfaCodeCompletionSource != nil) {
            self.userpoolOpsHelper.currentConfirmSignInHandlerCallback = completionHandler
            let mfaDetails = AWSCognitoIdentityMfaCodeDetails.init(mfaCode: challengeResponse);
            mfaDetails.clientMetaData = clientMetaData;
            self.userpoolOpsHelper.mfaCodeCompletionSource?.set(result: mfaDetails)
        } else if (self.userpoolOpsHelper.newPasswordRequiredTaskCompletionSource != nil) {
            self.userpoolOpsHelper.currentConfirmSignInHandlerCallback = completionHandler
            let passwordDetails = AWSCognitoIdentityNewPasswordRequiredDetails.init(proposedPassword: challengeResponse,
                                                                                    userAttributes: userAttributes)
            passwordDetails.clientMetaData = clientMetaData
            self.userpoolOpsHelper.newPasswordRequiredTaskCompletionSource?.set(result: passwordDetails)
        } else if (self.userpoolOpsHelper.customAuthChallengeTaskCompletionSource != nil) {
            self.userpoolOpsHelper.currentConfirmSignInHandlerCallback = completionHandler
            let customAuthDetails = AWSCognitoIdentityCustomChallengeDetails.init(challengeResponses: ["ANSWER": challengeResponse])
            customAuthDetails.clientMetaData = clientMetaData
            self.userpoolOpsHelper.customAuthChallengeTaskCompletionSource?.set(result: customAuthDetails)
            self.userpoolOpsHelper.customAuthChallengeTaskCompletionSource = nil
        }
        else {
            completionHandler(nil, AWSMobileClientError.invalidState(message: "Please call `signIn` before calling this method."))
        }
    }
    public func changePassword(currentPassword: String, proposedPassword: String, completionHandler: @escaping ((Error?) -> Void)) {
        self.userpoolOpsHelper.currentActiveUser!.changePassword(currentPassword, proposedPassword: proposedPassword).continueWith { (task) -> Any? in
            if let error = task.error {
                completionHandler(AWSMobileClientError.makeMobileClientError(from: error))
            } else if let _ = task.result {
                completionHandler(nil)
            }
            return nil
        }
    }
    public func getAWSCredentials(_ completionHandler: @escaping(AWSCredentials?, Error?) -> Void) {
        if self.internalCredentialsProvider == nil {
            completionHandler(nil, AWSMobileClientError.cognitoIdentityPoolNotConfigured(message: "There is no valid cognito identity pool configured in `awsconfiguration.json`."))
        }
        let cancellationToken = self.credentialsFetchCancellationSource
        credentialsFetchOperationQueue.addOperation {
            self.credentialsFetchLock.enter()
            self.internalCredentialsProvider?.credentials(withCancellationToken: cancellationToken).continueWith(block: { (task) -> Any? in
                if (task.isCancelled || cancellationToken.isCancellationRequested) {
                    self.credentialsFetchLock.leave()
                    completionHandler(task.result, task.error)
                    return nil
                }
                if let error = task.error {
                    if error._domain == AWSCognitoIdentityErrorDomain
                        && error._code == AWSCognitoIdentityErrorType.notAuthorized.rawValue
                        && self.federationProvider == .none {
                        self.credentialsFetchLock.leave()
                        completionHandler(nil, AWSMobileClientError.guestAccessNotAllowed(message: "Your backend is not configured with cognito identity pool to allow guest acess. Please allow un-authenticated access to identity pool to use this feature."))
                    } else if error._domain == AWSCognitoIdentityErrorDomain
                        && error._code == AWSCognitoIdentityErrorType.notAuthorized.rawValue
                        && self.federationProvider == .oidcFederation {
                        self.pendingAWSCredentialsCompletion = completionHandler
                        self.mobileClientStatusChanged(userState: .signedOutFederatedTokensInvalid, additionalInfo: [self.ProviderKey:self.cachedLoginsMap.first!.key])
                    } else {
                        self.credentialsFetchLock.leave()
                        completionHandler(nil, error)
                    }
                } else if let result = task.result {
                    if(self.federationProvider == .none && self.currentUserState != .guest) {
                        self.mobileClientStatusChanged(userState: .guest, additionalInfo: [:])
                    }
                    self.credentialsFetchLock.leave()
                    completionHandler(result, nil)
                }
                return nil
            })
            self.credentialsFetchLock.wait()
        }
    }
    public func releaseSignInWait() {
        if self.federationProvider == .userPools {
            self.userpoolOpsHelper.passwordAuthTaskCompletionSource?.set(error: AWSMobileClientError.unableToSignIn(message: "Unable to get valid sign in session from the end user."))
            self.userpoolOpsHelper.passwordAuthTaskCompletionSource = nil
            self.userpoolOpsHelper.customAuthChallengeTaskCompletionSource?.set(error: AWSMobileClientError.unableToSignIn(message: "Unable to get valid sign in session from the end user."))
            self.userpoolOpsHelper.customAuthChallengeTaskCompletionSource = nil
        } else if self.federationProvider == .hostedUI {
            self.pendingGetTokensCompletion?(nil, AWSMobileClientError.unableToSignIn(message: "Could not get valid token from the user."))
            self.pendingGetTokensCompletion = nil
            self.tokenFetchLock.leave()
        } else if self.federationProvider == .oidcFederation {
            self.pendingAWSCredentialsCompletion?(nil, AWSMobileClientError.unableToSignIn(message: "Could not get valid federation token from the user."))
            self.pendingAWSCredentialsCompletion = nil
            self.credentialsFetchLock.leave()
        }
    }
    public func getTokens(_ completionHandler: @escaping (Tokens?, Error?) -> Void) {
        switch self.federationProvider {
        case .userPools, .hostedUI:
            break
        default:
            completionHandler(nil, AWSMobileClientError.notSignedIn(message: notSignedInErrorMessage))
            return
        }
        if self.federationProvider == .hostedUI {
            self.tokenFetchOperationQueue.addOperation {
                self.tokenFetchLock.enter()
                AWSCognitoAuth.init(forKey: self.CognitoAuthRegistrationKey).getSession({ (session, error) in
                    if let sessionError = error,
                        (sessionError as NSError).domain == AWSCognitoAuthErrorDomain,
                        let errorType = AWSCognitoAuthClientErrorType(rawValue: (sessionError as NSError).code),
                        (errorType == .errorExpiredRefreshToken) {
                        self.pendingGetTokensCompletion = completionHandler
                        self.mobileClientStatusChanged(userState: .signedOutUserPoolsTokenInvalid,
                                                       additionalInfo: [self.ProviderKey:"OAuth"])
                        return
                    } else if let session = session {
                        completionHandler(self.getTokensForCognitoAuthSession(session: session), nil)
                    } else {
                        completionHandler(nil, error)
                    }
                    self.tokenFetchLock.leave()
                })
                self.tokenFetchLock.wait()
            }
            return
        }
        if self.federationProvider == .userPools {
            self.userpoolOpsHelper.userpoolClient?.delegate = self.userpoolOpsHelper
            self.userpoolOpsHelper.authHelperDelegate = self
            self.tokenFetchOperationQueue.addOperation {
                self.tokenFetchLock.enter()
                self.currentUser?.getSession().continueWith(block: { (task) -> Any? in
                    if let error = task.error {
                        completionHandler(nil, error)
                        self.invokeSignInCallback(signResult: nil, error: error)
                    } else if let session = task.result {
                        completionHandler(self.userSessionToTokens(userSession: session), nil)
                        self.federationProvider = .userPools
                        if (self.currentUserState != .signedIn) {
                            self.mobileClientStatusChanged(userState: .signedIn, additionalInfo: [:])
                        }
                        self.invokeSignInCallback(signResult: SignInResult(signInState: .signedIn), error: nil)
                    }
                    self.tokenFetchLock.leave()
                    return nil
                })
                self.tokenFetchLock.wait()
            }
            return
        }
    }
    internal func userSessionToTokens(userSession: AWSCognitoIdentityUserSession) -> Tokens {
        var idToken: SessionToken?
        var accessToken: SessionToken?
        var refreshToken: SessionToken?
        if userSession.idToken != nil {
            idToken = SessionToken(tokenString: userSession.idToken?.tokenString)
        }
        if userSession.accessToken != nil {
            accessToken = SessionToken(tokenString: userSession.accessToken?.tokenString)
        }
        if userSession.refreshToken != nil {
            refreshToken = SessionToken(tokenString: userSession.refreshToken?.tokenString)
        }
        return Tokens(idToken: idToken, accessToken: accessToken, refreshToken: refreshToken, expiration: userSession.expirationTime)
    }
}
extension AWSMobileClient {
    var notSignedInErrorMessage: String {
        return "User is not signed in to Cognito User Pool, please sign in to use this API."
    }
    public func verifyUserAttribute(attributeName: String,
                                    clientMetaData: [String:String] = [:],
                                    completionHandler: @escaping ((UserCodeDeliveryDetails?, Error?) -> Void)) {
        guard self.federationProvider == .userPools || self.federationProvider == .hostedUI else {
            completionHandler(nil, AWSMobileClientError.notSignedIn(message: notSignedInErrorMessage))
            return
        }
        let userDetails = AWSMobileClientUserDetails(with: self.userpoolOpsHelper.currentActiveUser!)
        userDetails.verifyUserAttribute(attributeName: attributeName, clientMetaData: clientMetaData, completionHandler: completionHandler)
    }
    public func updateUserAttributes(attributeMap: [String: String],
                                     clientMetaData: [String:String] = [:],
                                     completionHandler: @escaping (([UserCodeDeliveryDetails]?, Error?) -> Void)) {
        guard self.federationProvider == .userPools || self.federationProvider == .hostedUI else {
            completionHandler(nil, AWSMobileClientError.notSignedIn(message: notSignedInErrorMessage))
            return
        }
        let userDetails = AWSMobileClientUserDetails(with: self.userpoolOpsHelper.currentActiveUser!)
        userDetails.updateUserAttributes(attributeMap: attributeMap, clientMetaData: clientMetaData, completionHandler: completionHandler)
    }
    public func getUserAttributes(completionHandler: @escaping (([String: String]?, Error?) -> Void)) {
        guard self.federationProvider == .userPools || self.federationProvider == .hostedUI else {
            completionHandler(nil, AWSMobileClientError.notSignedIn(message: notSignedInErrorMessage))
            return
        }
        let userDetails = AWSMobileClientUserDetails(with: self.userpoolOpsHelper.currentActiveUser!)
        userDetails.getUserAttributes(completionHandler: completionHandler)
    }
    public func confirmUpdateUserAttributes(attributeName: String, code: String, completionHandler: @escaping ((Error?) -> Void)) {
        guard self.federationProvider == .userPools || self.federationProvider == .hostedUI else {
            completionHandler(AWSMobileClientError.notSignedIn(message: notSignedInErrorMessage))
            return
        }
        self.confirmVerifyUserAttribute(attributeName: attributeName, code: code, completionHandler: completionHandler)
    }
    public func confirmVerifyUserAttribute(attributeName: String, code: String, completionHandler: @escaping ((Error?) -> Void)) {
        guard self.federationProvider == .userPools || self.federationProvider == .hostedUI else {
            completionHandler(AWSMobileClientError.notSignedIn(message: notSignedInErrorMessage))
            return
        }
        let userDetails = AWSMobileClientUserDetails(with: self.userpoolOpsHelper.currentActiveUser!)
        userDetails.confirmVerifyUserAttribute(attributeName: attributeName,
                                               code: code,
                                               completionHandler: completionHandler)
    }
}
extension AWSMobileClient: UserPoolAuthHelperlCallbacks {
    func getPasswordDetails(_ authenticationInput: AWSCognitoIdentityPasswordAuthenticationInput,
                            passwordAuthenticationCompletionSource: AWSTaskCompletionSource<AWSCognitoIdentityPasswordAuthenticationDetails>) {
        if(self.userPoolClient?.isCustomAuth ?? false) {
            let authDetails = AWSCognitoIdentityPasswordAuthenticationDetails(username: self.currentUser?.username ?? "",
                                                                              password: userPassword ?? "dummyPassword")
            passwordAuthenticationCompletionSource.set(result: authDetails)
            userPassword = nil
            return
        }
        if (self.federationProvider != .userPools) {
            passwordAuthenticationCompletionSource.set(error: AWSMobileClientError.notSignedIn(message: notSignedInErrorMessage))
        }
        switch self.currentUserState {
        case .signedIn, .signedOutUserPoolsTokenInvalid:
            self.userpoolOpsHelper.passwordAuthTaskCompletionSource = passwordAuthenticationCompletionSource
            self.mobileClientStatusChanged(userState: .signedOutUserPoolsTokenInvalid, additionalInfo: ["username":self.userPoolClient?.currentUser()?.username ?? ""])
        default:
            break
        }
    }
    func didCompletePasswordStepWithError(_ error: Error?) {
        if let error = error {
            invokeSignInCallback(signResult: nil, error: AWSMobileClientError.makeMobileClientError(from: error))
        }
    }
    func getNewPasswordDetails(_ newPasswordRequiredInput: AWSCognitoIdentityNewPasswordRequiredInput,
                               newPasswordRequiredCompletionSource: AWSTaskCompletionSource<AWSCognitoIdentityNewPasswordRequiredDetails>) {
        self.userpoolOpsHelper.newPasswordRequiredTaskCompletionSource = newPasswordRequiredCompletionSource
        let result = SignInResult(signInState: .newPasswordRequired, codeDetails: nil)
        invokeSignInCallback(signResult: result, error: nil)
    }
    func didCompleteNewPasswordStepWithError(_ error: Error?) {
        if let error = error {
            invokeSignInCallback(signResult: nil, error: AWSMobileClientError.makeMobileClientError(from: error))
        }
    }
    func getCustomAuthenticationDetails(_ customAuthenticationInput: AWSCognitoIdentityCustomAuthenticationInput,
                                        customAuthCompletionSource: AWSTaskCompletionSource<AWSCognitoIdentityCustomChallengeDetails>) {
        self.userpoolOpsHelper.customAuthChallengeTaskCompletionSource = customAuthCompletionSource
        if ((self.currentUserState == .signedIn || self.currentUserState == .signedOutUserPoolsTokenInvalid) &&
            customAuthenticationInput.challengeParameters.isEmpty) {
            let username = self.userPoolClient?.currentUser()?.username ?? ""
            self.mobileClientStatusChanged(userState: .signedOutUserPoolsTokenInvalid,
                                           additionalInfo: ["username": username])
        } else {
            let result = SignInResult(signInState: .customChallenge,
                                      parameters: customAuthenticationInput.challengeParameters,
                                      codeDetails: nil)
            invokeSignInCallback(signResult: result, error: nil)
        }
    }
    func didCompleteCustomAuthenticationStepWithError(_ error: Error?) {
        if let error = error {
            invokeSignInCallback(signResult: nil, error: AWSMobileClientError.makeMobileClientError(from: error))
        }
    }
    func getCode(_ authenticationInput: AWSCognitoIdentityMultifactorAuthenticationInput,
                 mfaCodeCompletionSource: AWSTaskCompletionSource<AWSCognitoIdentityMfaCodeDetails>) {
        self.userpoolOpsHelper.mfaCodeCompletionSource = mfaCodeCompletionSource
        var codeDeliveryDetails: UserCodeDeliveryDetails? = nil
            switch(authenticationInput.deliveryMedium) {
            case .email:
                codeDeliveryDetails = UserCodeDeliveryDetails(deliveryMedium: .email, destination: authenticationInput.destination, attributeName: "email")
            case .sms:
                codeDeliveryDetails = UserCodeDeliveryDetails(deliveryMedium: .sms, destination: authenticationInput.destination, attributeName: "phone")
            case .unknown:
                codeDeliveryDetails = UserCodeDeliveryDetails(deliveryMedium: .unknown, destination: authenticationInput.destination, attributeName: "unknown")
            @unknown default:
                codeDeliveryDetails = UserCodeDeliveryDetails(deliveryMedium: .unknown, destination: authenticationInput.destination, attributeName: "unknown")
        }
        let result = SignInResult(signInState: .smsMFA, codeDetails: codeDeliveryDetails)
        invokeSignInCallback(signResult: result, error: nil)
    }
    func didCompleteMultifactorAuthenticationStepWithError(_ error: Error?) {
        if let error = error {
            invokeSignInCallback(signResult: nil, error: AWSMobileClientError.makeMobileClientError(from: error))
        }
    }
}
extension AWSMobileClient {
    internal func setLoginProviderMetadataAndSaveInKeychain(provider: FederationProvider) {
        self.federationProvider = provider
        self.keychain.setString(provider.rawValue, forKey: FederationProviderKey)
        if let customRoleArn = self.customRoleArnInternal {
            self.keychain.setString(customRoleArn, forKey: CustomRoleArnKey)
        } else {
            self.keychain.removeItem(forKey: CustomRoleArnKey)
        }
        if federationDisabled {
            self.keychain.setString("true", forKey: FederationDisabledKey)
        }
    }
    internal func saveOAuthURIQueryParametersInKeychain() {
        self.keychain.setData(JSONHelper.dataFromDictionary(self.signInURIQueryParameters), forKey: SignInURIQueryParametersKey)
        self.keychain.setData(JSONHelper.dataFromDictionary(self.tokenURIQueryParameters), forKey: TokenURIQueryParametersKey)
        self.keychain.setData(JSONHelper.dataFromDictionary(self.signOutURIQueryParameters), forKey: SignOutURIQueryParametersKey)
    }
    internal func loadOAuthURIQueryParametersFromKeychain() {
        self.signInURIQueryParameters = JSONHelper.dictionaryFromData(self.keychain.data(forKey: SignInURIQueryParametersKey))
        self.tokenURIQueryParameters = JSONHelper.dictionaryFromData(self.keychain.data(forKey: TokenURIQueryParametersKey))
        self.signOutURIQueryParameters = JSONHelper.dictionaryFromData(self.keychain.data(forKey: SignOutURIQueryParametersKey))
    }
    internal func loadHostedUIScopesFromKeychain() {
        self.scopes = JSONHelper.arrayFromData(self.keychain.data(forKey: HostedUIOptionsScopesKey))
    }
    internal func saveHostedUIOptionsScopesInKeychain() {
        self.keychain.setData(JSONHelper.dataFromArray(self.scopes), forKey: HostedUIOptionsScopesKey)
    }
    internal func clearHostedUIOptionsScopesFromKeychain() {
        self.keychain.removeItem(forKey: HostedUIOptionsScopesKey)
    }
    internal func saveLoginsMapInKeychain() {
        if self.cachedLoginsMap.count == 0 {
            self.keychain.removeItem(forKey: LoginsMapKey)
            self.keychain.removeItem(forKey: FederationDisabledKey)
        } else {
            do {
                let data = try Data.init(base64Encoded: JSONEncoder().encode(self.cachedLoginsMap).base64EncodedData())
                self.keychain.setData(data, forKey: LoginsMapKey)
            } catch {
                print("could not save login map in cache")
            }
        }
    }
    internal func loadLoginsMapFromKeychain() {
        let data = self.keychain.data(forKey: LoginsMapKey)
        if data != nil {
            do {
                let dict = try JSONDecoder().decode([String: String].self, from: data!)
                self.cachedLoginsMap = dict
            } catch {
                print("Could not load login map from cache")
            }
        } else {
            self.cachedLoginsMap = [:]
        }
    }
    internal func loadFederationProviderMetadataFromKeychain() {
        if let federationProviderString = self.keychain.string(forKey: FederationProviderKey),
            let federationProvider = FederationProvider(rawValue: federationProviderString) {
            self.federationProvider = federationProvider
        }
        if let customRoleArnString = self.keychain.string(forKey: CustomRoleArnKey) {
            self.customRoleArnInternal = customRoleArnString
        }
        if let _ = self.keychain.string(forKey: FederationDisabledKey) {
            self.federationDisabled = true
        }
    }
}
extension AWSMobileClient: AWSCognitoAuthDelegate {
    public func getViewController() -> UIViewController {
        if (developerNavigationController?.visibleViewController != nil) {
            return developerNavigationController!.visibleViewController!
        }
        return UIApplication.shared.keyWindow!.rootViewController!
    }
    public func shouldLaunchSignInVCIfRefreshTokenIsExpired() -> Bool {
        return false
    }
}