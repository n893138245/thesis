import Foundation
import AWSCognitoIdentityProvider
public struct Device {
    public let attributes: [String: String]?
    public let createDate: Date?
    public let deviceKey: String?
    public let lastAuthenticatedDate: Date?
    public let lastModifiedDate: Date?
    internal init(attributes: [String: String]? = nil,
                  createDate: Date? = nil,
                  deviceKey: String? = nil,
                  lastAuthenticatedDate: Date? = nil,
                  lastModifiedDate: Date? = nil) {
        self.attributes = attributes
        self.createDate = createDate
        self.deviceKey = deviceKey
        self.lastAuthenticatedDate = lastAuthenticatedDate
        self.lastModifiedDate = lastModifiedDate
    }
}
public struct ListDevicesResult {
    public let devices: [Device]?
    public let paginationToken: String?
    internal init(devices: [Device]? = [], paginationToken: String?) {
        self.devices = devices
        self.paginationToken = paginationToken
    }
}
public struct UpdateDeviceStatusResult {
}
public class DeviceOperations {
    weak var mobileClient: AWSMobileClient?
    internal static let sharedInstance: DeviceOperations = DeviceOperations()
    public func list(limit: Int = 60, paginationToken: String? = nil, completionHandler: @escaping ((ListDevicesResult?, Error?) -> Void)) {
        mobileClient?.userpoolOpsHelper.currentActiveUser!.listDevices(Int32(limit), paginationToken: paginationToken).continueWith { (task) -> Any? in
            if let error = task.error {
                completionHandler(nil, AWSMobileClientError.makeMobileClientError(from: error))
            } else if let result = task.result {
                var devices: [Device] = []
                if result.devices != nil {
                    for device in result.devices! {
                        devices.append(self.getMCDeviceForCognitoDevice(device: device))
                    }
                }
                let listResult = ListDevicesResult(devices: devices, paginationToken: result.paginationToken)
                completionHandler(listResult, nil)
            }
            return nil
        }
    }
    public func updateStatus(deviceId: String, remembered: Bool, completionHandler: @escaping ((UpdateDeviceStatusResult?, Error?) -> Void)) {
        mobileClient!.userpoolOpsHelper.currentActiveUser!.updateDeviceStatus(deviceId, remembered: remembered).continueWith { (task) -> Any? in
            if let error = task.error {
                completionHandler(nil, AWSMobileClientError.makeMobileClientError(from: error))
            } else if let _ = task.result {
                completionHandler(UpdateDeviceStatusResult(), nil)
            }
            return nil
        }
    }
    public func updateStatus(remembered: Bool, completionHandler: @escaping ((UpdateDeviceStatusResult?, Error?) -> Void)) {
        mobileClient!.userpoolOpsHelper.currentActiveUser!.updateDeviceStatus(remembered).continueWith { (task) -> Any? in
            if let error = task.error {
                completionHandler(nil, AWSMobileClientError.makeMobileClientError(from: error))
            } else if let _ = task.result {
                completionHandler(UpdateDeviceStatusResult(), nil)
            }
            return nil
        }
    }
    public func get(deviceId: String, completionHandler: @escaping ((Device?, Error?) -> Void)) {
        mobileClient!.userpoolOpsHelper.currentActiveUser!.getDevice(deviceId).continueWith { (task) -> Any? in
            if let error = task.error {
                completionHandler(nil, AWSMobileClientError.makeMobileClientError(from: error))
            } else if let result = task.result {
                completionHandler(self.getMCDeviceForCognitoDevice(device: result.device), nil)
            }
            return nil
        }
    }
    public func get(_ completionHandler: @escaping ((Device?, Error?) -> Void)) {
        mobileClient!.userpoolOpsHelper.currentActiveUser!.getDevice().continueWith { (task) -> Any? in
            if let error = task.error {
                completionHandler(nil, AWSMobileClientError.makeMobileClientError(from: error))
            } else if let result = task.result {
                completionHandler(self.getMCDeviceForCognitoDevice(device: result.device), nil)
            }
            return nil
        }
    }
    public func forget(deviceId: String, completionHandler: @escaping ((Error?) -> Void)) {
        mobileClient!.userpoolOpsHelper.currentActiveUser!.forgetDevice(deviceId).continueWith { (task) -> Any? in
            if let error = task.error {
                completionHandler(AWSMobileClientError.makeMobileClientError(from: error))
            } else if let _ = task.result {
                completionHandler(nil)
            }
            return nil
        }
    }
    public func forget(_ completionHandler: @escaping ((Error?) -> Void)) {
        mobileClient!.userpoolOpsHelper.currentActiveUser!.forgetDevice().continueWith { (task) -> Any? in
            if let error = task.error {
                completionHandler(AWSMobileClientError.makeMobileClientError(from: error))
            } else if let _ = task.result {
                completionHandler(nil)
            }
            return nil
        }
    }
    internal func getMCDeviceForCognitoDevice(device: AWSCognitoIdentityProviderDeviceType?) -> Device {
        let createDate = device?.deviceCreateDate
        let lastAuthDate = device?.deviceLastAuthenticatedDate
        let lastModifiedDate = device?.deviceLastModifiedDate
        let deviceKey = device?.deviceKey
        var attributes: [String: String] = [:]
        if device?.deviceAttributes != nil {
            for attr in device!.deviceAttributes! {
                if attr.name != nil && attr.value != nil {
                    attributes[attr.name!] = attr.value!
                }
            }
        }
        return Device(attributes: attributes, createDate: createDate, deviceKey: deviceKey, lastAuthenticatedDate: lastAuthDate, lastModifiedDate: lastModifiedDate)
    }
}