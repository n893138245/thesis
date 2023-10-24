import UIKit
extension UIImageView: SSCompatible{}
extension SS where Base:UIImageView {
    func startGifWithImageName(name:String) {
        guard let path = Bundle.main.path(forResource: name, ofType: "gif") else {
            print("SwiftGif: Source for the image does not exist")
            return
        }
        startGifWithFilePath(filePath: path)
    }
    func startGifWithFilePath(filePath:String) {
        guard let data = NSData(contentsOfFile: filePath) else {return}
        guard let imageSource = CGImageSourceCreateWithData(data, nil) else {return}
        let imageCount = CGImageSourceGetCount(imageSource)
        var images = [UIImage]()
        var totalDuration : TimeInterval = 0
        for i in 0..<imageCount {
            guard let cgImage = CGImageSourceCreateImageAtIndex(imageSource, i, nil) else {continue}
            let image = UIImage(cgImage: cgImage)
            images.append(image)
            guard let properties = CGImageSourceCopyPropertiesAtIndex(imageSource, i, nil) as? Dictionary<CFString, Any>  else {continue}
            guard let gifDict = properties[kCGImagePropertyGIFDictionary]  as? NSDictionary else  {continue}
            guard let frameDuration = gifDict[kCGImagePropertyGIFDelayTime] as? NSNumber else {continue}
            totalDuration += frameDuration.doubleValue
        }
        base.animationImages = images
        base.animationDuration = totalDuration
        base.animationRepeatCount = 1
        base.startAnimating()
    }
    func imageStopAnimating() {
        base.stopAnimating()
    }
}