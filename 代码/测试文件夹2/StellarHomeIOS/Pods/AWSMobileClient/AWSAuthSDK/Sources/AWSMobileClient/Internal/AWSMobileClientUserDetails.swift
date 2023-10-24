import Foundation
import AWSCognitoIdentityProvider
internal class AWSMobileClientUserDetails {
    let cognitoIdentityUser: AWSCognitoIdentityUser
    init(with user: AWSCognitoIdentityUser) {
            cognitoIdentityUser = user
    }
    public func verifyUserAttribute(attributeName: String,
                                    clientMetaData: [String:String] = [:],
                                    completionHandler: @escaping ((UserCodeDeliveryDetails?, Error?) -> Void)) {
        self.cognitoIdentityUser.getAttributeVerificationCode(attributeName,
                                                              clientMetaData: clientMetaData).continueWith { (task) -> Any? in
            if let error = task.error {
                completionHandler(nil, AWSMobileClientError.makeMobileClientError(from: error))
            } else if let result = task.result {
                var codeDeliveryDetails: UserCodeDeliveryDetails? = nil
                if let deliveryDetails = result.codeDeliveryDetails {
                    codeDeliveryDetails = UserCodeDeliveryDetails.getUserCodeDeliveryDetails(deliveryDetails)
                }
                completionHandler(codeDeliveryDetails, nil)
            }
            return nil
        }
    }
    public func updateUserAttributes(attributeMap: [String: String], clientMetaData: [String:String] = [:], completionHandler: @escaping (([UserCodeDeliveryDetails]?, Error?) -> Void)) {
        let attributes = attributeMap.map {AWSCognitoIdentityUserAttributeType.init(name: $0, value: $1) }
        self.cognitoIdentityUser.update(attributes, clientMetaData: clientMetaData).continueWith { (task) -> Any? in
            if let error = task.error {
                completionHandler(nil, AWSMobileClientError.makeMobileClientError(from: error))
            } else if let result = task.result {
                var codeDeliveryDetailsList: [UserCodeDeliveryDetails] = []
                if result.codeDeliveryDetailsList != nil {
                    for codeDeliveryDetail in result.codeDeliveryDetailsList! {
                        codeDeliveryDetailsList.append(UserCodeDeliveryDetails.getUserCodeDeliveryDetails(codeDeliveryDetail))
                    }
                }
                completionHandler(codeDeliveryDetailsList, nil)
            }
            return nil
        }
    }
    public func getUserAttributes(completionHandler: @escaping (([String: String]?, Error?) -> Void)) {
        self.cognitoIdentityUser.getDetails().continueWith { (task) -> Any? in
            if let error = task.error {
                completionHandler(nil, AWSMobileClientError.makeMobileClientError(from: error))
            } else if let result = task.result {
                let userAttributes = result.userAttributes
                var attributesMap = [String: String]()
                if let userAttributes = userAttributes {
                    for attribute in userAttributes {
                        guard attribute.name != nil, attribute.value != nil else {continue}
                        attributesMap[attribute.name!] = attribute.value!
                    }
                }
                completionHandler(attributesMap, nil)
            }
            return nil
        }
    }
    public func confirmVerifyUserAttribute(attributeName: String, code: String, completionHandler: @escaping ((Error?) -> Void)) {
        self.cognitoIdentityUser.verifyAttribute(attributeName, code: code).continueWith { (task) -> Any? in
            if let error = task.error {
                completionHandler(AWSMobileClientError.makeMobileClientError(from: error))
            } else if let _ = task.result {
                completionHandler(nil)
            }
            return nil
        }
    }
}