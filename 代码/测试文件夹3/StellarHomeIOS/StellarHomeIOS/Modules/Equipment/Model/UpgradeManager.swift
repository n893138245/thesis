import UIKit
class UpgradeManager: NSObject {
    static let shared = UpgradeManager.init()
    override init() {
    }
    func dowloadData(url: String, responseBlock:((_ response: Data) ->Void)?,errorBlock: (() ->Void)?,progressBlock: ((_ progress: CGFloat)-> Void)?) {
        let destination: DownloadRequest.DownloadFileDestination = { _, response in
            return (self.getFileURL(), [.removePreviousFile, .createIntermediateDirectories])
        }
        Alamofire.download(URL(string: url)!, to: destination).downloadProgress { (progress) in
            progressBlock?(CGFloat(progress.fractionCompleted))
            print(progress.fractionCompleted)
        }.responseData { (responseData) in
            if responseData.error != nil {
                errorBlock?()
            }else {
                if let data = responseData.result.value {
                    responseBlock?(data)
                }
            }
        }
    }
    func getData() -> Data? {
        let fileManager = FileManager.default
        return fileManager.contents(atPath: getFileURL().absoluteString)
    }
    func removeData() {
        let fileManager = FileManager.default
        do {
            try fileManager.removeItem(atPath: getFileURL().absoluteString)
        } catch {
            print("没有文件")
        }
    }
    private func getFileURL() -> URL {
        let fileName = ".bin"
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentsURL.appendingPathComponent(fileName)
        return fileURL
    }
}