import Foundation
#if os(OSX)
import AppKit
#else
import UIKit
#endif
public extension AttributedString {
    #if os(iOS)
    convenience init?(imageURL: String?, bounds: String? = nil) {
        guard let imageURL = imageURL, let url = URL(string: imageURL) else {
            return nil
        }
        let attachment = AsyncTextAttachment()
        attachment.imageURL = url
        if let bounds = CGRect(string: bounds) {
            attachment.bounds = bounds
        }
        self.init(attachment: attachment)
    }
    #endif
    #if os(iOS) || os(OSX)
    convenience init?(imageNamed: String?, bounds: String? = nil) {
        guard let imageNamed = imageNamed else {
            return nil
        }
        let image = Image(named: imageNamed)
        let boundsRect = CGRect(string: bounds)
        self.init(image: image, bounds: boundsRect)
    }
    convenience init?(image: Image?, bounds: CGRect? = nil) {
        guard let image = image else {
            return nil
        }
        #if os(OSX)
        let attachment = NSTextAttachment(data: image.pngData()!, ofType: "png")
        #else
        var attachment: NSTextAttachment!
        if #available(iOS 13.0, *) {
            attachment = NSTextAttachment(image: image)
        } else {
            attachment = NSTextAttachment(data: image.pngData()!, ofType: "png")
        }
        #endif
        if let bounds = bounds {
            attachment.bounds = bounds
        }
        self.init(attachment: attachment)
    }
    #endif
}