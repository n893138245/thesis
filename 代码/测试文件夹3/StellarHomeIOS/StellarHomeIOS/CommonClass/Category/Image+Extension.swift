extension UIImage: SSCompatible {}
extension SS where Base:UIImage {
    func toCircle() -> UIImage {
        let originalImage = base as UIImage
        let shotest = min(originalImage.size.width, originalImage.size.height)
        let outputRect = CGRect(x: 0, y: 0, width: shotest, height: shotest)
        UIGraphicsBeginImageContextWithOptions(outputRect.size, false, 0)
        let context = UIGraphicsGetCurrentContext()!
        context.addEllipse(in: outputRect)
        context.clip()
        originalImage.draw(in: CGRect(x: (shotest-originalImage.size.width)/2,
                             y: (shotest-originalImage.size.height)/2,
                             width: originalImage.size.width,
                             height: originalImage.size.height))
        let maskedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return maskedImage
    }
    func reSizeImage(reSize:CGSize)->UIImage {
        let originalImage = base as UIImage
        UIGraphicsBeginImageContextWithOptions(reSize,false,UIScreen.main.scale)
        originalImage.draw(in: CGRect.init(x: 0, y: 0, width: reSize.width, height: reSize.height))
        guard let reSizeImage = UIGraphicsGetImageFromCurrentImageContext() else {
            return originalImage
        }
        UIGraphicsEndImageContext()
        return reSizeImage
    }
    static func reSizeImage(reSize:CGSize,image:UIImage)->UIImage {
        UIGraphicsBeginImageContextWithOptions(reSize,false,UIScreen.main.scale)
        image.draw(in: CGRect.init(x: 0, y: 0, width: reSize.width, height: reSize.height))
        guard let reSizeImage = UIGraphicsGetImageFromCurrentImageContext() else {
            return image
        }
        UIGraphicsEndImageContext()
        return reSizeImage
    }
}