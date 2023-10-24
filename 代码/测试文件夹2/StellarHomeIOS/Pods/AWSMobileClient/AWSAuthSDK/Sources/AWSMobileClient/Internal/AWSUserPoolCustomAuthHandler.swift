import AWSCognitoIdentityProvider
class AWSUserPoolCustomAuthHandler: NSObject, AWSCognitoIdentityCustomAuthentication {
    var authHelperDelegate: UserPoolAuthHelperlCallbacks?
    public func getCustomChallengeDetails(_ authenticationInput: AWSCognitoIdentityCustomAuthenticationInput,
                                          customAuthCompletionSource: AWSTaskCompletionSource<AWSCognitoIdentityCustomChallengeDetails>) {
        self.authHelperDelegate?.getCustomAuthenticationDetails(authenticationInput,
                                                                customAuthCompletionSource: customAuthCompletionSource)
    }
    public func didCompleteStepWithError(_ error: Error?) {
        self.authHelperDelegate?.didCompleteCustomAuthenticationStepWithError(error)
    }
}