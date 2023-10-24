extension UIColor: SSCompatible {}
extension SS where Base:UIColor {
    static func rgbColor(_ r:CGFloat, _ g:CGFloat, _ b:CGFloat, _ alpha:CGFloat = 1.0) -> UIColor{
        let color:UIColor = UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: alpha)
        return color
    }
    static func randomColor() -> UIColor {
        return UIColor(red: randomColorCount(0, 256)/255.0, green: randomColorCount(0, 256)/255.0, blue: randomColorCount(0, 256)/255.0, alpha: 1.0)
    }
    private static func randomColorCount(_ startIndex:Int, _ endIndex:Int) -> CGFloat{
        let range = Range<Int>(startIndex...endIndex)
        let count = UInt32(range.upperBound - range.lowerBound)
        let v = Int(arc4random_uniform(count))+range.lowerBound
        return CGFloat(v)
    }
    static func colorWithHexString(_ stringToConvert: String) -> UIColor {
        let scanner = Scanner(string: stringToConvert)
        var hexNum: UInt32 = 0
        guard scanner.scanHexInt32(&hexNum) else {
            return UIColor.red
        }
        return UIColor.ss.colorWithRGBHex(hexNum)
    }
    static func colorWithRGBHex(_ hex: UInt32) -> UIColor {
        let r = (hex >> 16) & 0xFF
        let g = (hex >> 8) & 0xFF
        let b = (hex) & 0xFF
        return UIColor(red: CGFloat(r) / CGFloat(255.0), green: CGFloat(g) / CGFloat(255.0), blue: CGFloat(b) / CGFloat(255.0), alpha: 1.0)
    }
    static func getRGBDictionaryByColor(_ color: UIColor) -> [CGFloat] {
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        let components = color.cgColor.components
        r = components![0]
        g = components![1]
        b = components![2]
        a = components![3]
        return [r, g, b, a]
    }
    static func drawWithColors(colors:[CGColor]) -> CAGradientLayer{
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors
        gradientLayer.startPoint = CGPoint.init(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint.init(x: 1, y: 1)
        return gradientLayer
    }
    static func getImageWithColor(color: UIColor) -> UIImage {
        let defaultImage = UIImage()
        let rect = CGRect(x: 0, y: 0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        guard let contex = UIGraphicsGetCurrentContext() else {
            return defaultImage
        }
        contex.setFillColor(color.cgColor)
        contex.fill(rect)
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else {
            return defaultImage
        }
        UIGraphicsEndImageContext()
        return image
    }
    static func rgbColor(r:CGFloat, g:CGFloat, b:CGFloat) ->UIColor{
        return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: 1.0)
    }
    static func rgbA(r:CGFloat, g:CGFloat, b:CGFloat, a:CGFloat) ->UIColor{
        return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)
    }
}