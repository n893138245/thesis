import UIKit
import AWSCore
import AWSS3
class AWSRequest: NSObject {
    public class func putHeaderImageToAWS(fileName: String, image: UIImage, success:(()->Void)?, failure:((Int)->Void)?) {
        let data: Data = image.pngData()! 
        let expression = AWSS3TransferUtilityUploadExpression()
        expression.progressBlock = {(task, progress) in
            DispatchQueue.main.async(execute: {
            })
        }
        var completionHandler: AWSS3TransferUtilityUploadCompletionHandlerBlock?
        completionHandler = { (task, error) -> Void in
            DispatchQueue.main.async(execute: {
                if error == nil{
                    print("AWS putHeaderImageToAWS success")
                    if let tempClosure = success{
                        tempClosure()
                    }
                }else{
                    print("AWS putHeaderImageToAWS failure")
                    if let tempClosure = failure{
                        tempClosure(404)
                    }
                }
            })
        }
        let transferUtility = AWSS3TransferUtility.default()
        transferUtility.uploadData(data,
                                   bucket: "stellar-home",
                                   key: "avatar/\(fileName).png",
            contentType: "image/png",
            expression: expression,
            completionHandler: completionHandler).continueWith {
                (task) -> AnyObject? in
                if let error = task.error {
                    print("Error: \(error.localizedDescription)")
                }
                if let _ = task.result {
                }
                return nil;
        }
    }
    public class func getHeaderImage(fileName: String, success:((Data?)->Void)?, failure:((Int)->Void)?) {
        let downloadedFilePath = NSTemporaryDirectory().appendingFormat("downloaded-\(fileName)")
        let downloadedFileURL = URL.init(fileURLWithPath: downloadedFilePath)
        let downloadReadRequest : AWSS3TransferManagerDownloadRequest = AWSS3TransferManagerDownloadRequest()
        downloadReadRequest.bucket = "stellar-home"
        downloadReadRequest.key = "avatar/\(fileName).png"
        downloadReadRequest.downloadingFileURL = downloadedFileURL
        let transferManager = AWSS3TransferManager.default()
        let task = transferManager.download(downloadReadRequest)
        task.continueWith { (task) -> AnyObject? in
            if task.error == nil
            {
                let tempnam = NSData.init(contentsOf: downloadedFileURL)
                if let tempClosure = success{
                    DispatchQueue.main.async {
                        tempClosure(tempnam as Data?)
                    }
                }
            }
            else
            {
                if let tempClosure = failure{
                    DispatchQueue.main.async {
                        tempClosure(404)
                    }
                }
            }
            return nil
        }
    }
    public class func deleteHeaderImageFromAWS(fileName: String, success:(()->Void)?, failure:((Int)->Void)?) {
        let manager = AWSS3.default();
        let deletReq =  AWSS3DeleteObjectRequest.init();
        deletReq?.bucket = "stellar-home"
        deletReq?.key = "avatar/\(fileName).png"
        manager.deleteObject(deletReq!).continueWith { (task) -> Any? in
            if task.error == nil
            {
                if let tempClosure = success{
                    DispatchQueue.main.async {
                        tempClosure();
                    }
                }
            }
            else
            {
                if let tempClosure = failure{
                    DispatchQueue.main.async {
                        tempClosure(404)
                    }
                }
            }
            return nil
        }.waitUntilFinished()
    }
}