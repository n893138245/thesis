import Foundation
@objc public class SignInUIOptions: NSObject {
    @objc public let canCancel: Bool
    @objc public let logoImage: UIImage?
    @objc public let backgroundColor: UIColor?
    @objc public let secondaryBackgroundColor: UIColor?
    @objc public let primaryColor: UIColor?
    @objc public let disableSignUpButton: Bool
    @objc public init(canCancel: Bool = false,
                      logoImage: UIImage? = nil,
                      backgroundColor: UIColor? = nil,
                      secondaryBackgroundColor: UIColor? = nil,
                      primaryColor: UIColor? = .systemBlue,
                      disableSignUpButton: Bool = false) {
        self.canCancel = canCancel
        self.logoImage = logoImage
        self.backgroundColor = backgroundColor
        self.secondaryBackgroundColor = secondaryBackgroundColor
        self.primaryColor = primaryColor
        self.disableSignUpButton = disableSignUpButton
    }
}
public struct SignOutOptions {
    let invalidateTokens: Bool
    let signOutGlobally: Bool
    public init(signOutGlobally: Bool = false, invalidateTokens: Bool = true) {
        self.signOutGlobally = signOutGlobally
        self.invalidateTokens = invalidateTokens
    }
}
public struct FederatedSignInOptions {
    let cognitoIdentityId: String?
    let customRoleARN: String?
    public init(cognitoIdentityId: String? = nil, customRoleARN: String? = nil) {
        self.cognitoIdentityId = cognitoIdentityId
        self.customRoleARN = customRoleARN
    }
}
public struct HostedUIOptions {
    let scopes: [String]?
    let identityProvider: String?
    let idpIdentifier: String?
    let disableFederation: Bool
    let federationProviderName: String?
    let signInURIQueryParameters: [String: String]?
    let tokenURIQueryParameters: [String: String]?
    let signOutURIQueryParameters: [String: String]?
    public init(disableFederation: Bool = false,
                scopes: [String]? = nil,
                identityProvider: String? = nil,
                idpIdentifier: String? = nil,
                federationProviderName: String? = nil,
                signInURIQueryParameters: [String: String]? = nil,
                tokenURIQueryParameters: [String: String]? = nil,
                signOutURIQueryParameters: [String: String]? = nil) {
        self.disableFederation = disableFederation
        self.scopes = scopes
        if let identityProvider = identityProvider {
            if let hostedUIMappedIdentityProvider = IdentityProvider.init(rawValue: identityProvider)?.getHostedUIIdentityProvider() {
                self.identityProvider = hostedUIMappedIdentityProvider
            } else {
                self.identityProvider = identityProvider
            }
        } else {
            self.identityProvider = nil
        }
        self.idpIdentifier = idpIdentifier
        self.federationProviderName = federationProviderName
        self.signInURIQueryParameters = signInURIQueryParameters
        self.tokenURIQueryParameters = tokenURIQueryParameters
        self.signOutURIQueryParameters = signOutURIQueryParameters
    }
}
public enum IdentityProvider: String {
    case facebook = "graph.facebook.com"
    case google = "accounts.google.com"
    case twitter = "api.twitter.com"
    case amazon = "www.amazon.com"
    case developer = "cognito-identity.amazonaws.com"
    case apple = "appleid.apple.com"
    func getHostedUIIdentityProvider() -> String? {
        switch self {
        case .facebook:
            return "Facebook"
        case .google:
            return "Google"
        case .amazon:
            return "LoginWithAmazon"
        case .apple:
            return "SignInWithApple"
        default:
            return nil
        }
    }
}