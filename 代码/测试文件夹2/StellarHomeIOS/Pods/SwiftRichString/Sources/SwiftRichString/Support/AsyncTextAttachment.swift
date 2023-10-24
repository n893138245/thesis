#if os(OSX)
import AppKit
#else
import UIKit
import MobileCoreServices
#endif
#if os(iOS)
@objc public protocol AsyncTextAttachmentDelegate
{
    func textAttachmentDidLoadImage(textAttachment: AsyncTextAttachment, displaySizeChanged: Bool)
}
public class AsyncTextAttachment: NSTextAttachment {
    public var imageURL: URL?
    public var displaySize: CGSize?
    public var maximumDisplayWidth: CGFloat?
    public weak var delegate: AsyncTextAttachmentDelegate?
    weak var textContainer: NSTextContainer?
    private var downloadTask: URLSessionDataTask!
    private var originalImageSize: CGSize?
    public init(imageURL: URL? = nil, delegate: AsyncTextAttachmentDelegate? = nil) {
        self.imageURL = imageURL
        self.delegate = delegate
        super.init(data: nil, ofType: nil)
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override public var image: UIImage? {
        didSet {
            originalImageSize = image?.size
        }
    }
    private func startAsyncImageDownload() {
        guard let imageURL = imageURL, contents == nil, downloadTask == nil else {
            return
        }
        downloadTask = URLSession.shared.dataTask(with: imageURL) { (data, response, error) in
            defer {
                self.downloadTask = nil
            }
            guard let data = data, error == nil else {
                print(error?.localizedDescription as Any)
                return
            }
            var displaySizeChanged = false
            self.contents = data
            let ext = imageURL.pathExtension as CFString
            if let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, ext, nil) {
                self.fileType = uti.takeRetainedValue() as String
            }
            if let image = UIImage(data: data) {
                let imageSize = image.size
                if self.displaySize == nil
                {
                    displaySizeChanged = true
                }
                self.originalImageSize = imageSize
            }
            DispatchQueue.main.async {
                if displaySizeChanged {
                    self.textContainer?.layoutManager?.setNeedsLayout(forAttachment: self)
                } else {
                    self.textContainer?.layoutManager?.setNeedsDisplay(forAttachment: self)
                }
                self.delegate?.textAttachmentDidLoadImage(textAttachment: self, displaySizeChanged: displaySizeChanged)
            }
        }
        downloadTask.resume()
    }
    public override func image(forBounds imageBounds: CGRect, textContainer: NSTextContainer?, characterIndex charIndex: Int) -> UIImage? {
        if let image = image { return image }
        guard let contents = contents, let image = UIImage(data: contents) else {
            self.textContainer = textContainer
            startAsyncImageDownload()
            return nil
        }
        return image
    }
    public override func attachmentBounds(for textContainer: NSTextContainer?, proposedLineFragment lineFrag: CGRect, glyphPosition position: CGPoint, characterIndex charIndex: Int) -> CGRect {
        if let displaySize = displaySize {
            return CGRect(origin: CGPoint.zero, size: displaySize)
        }
        if let imageSize = originalImageSize {
            let maxWidth = maximumDisplayWidth ?? lineFrag.size.width
            let factor = maxWidth / imageSize.width
            return CGRect(origin: CGPoint.zero, size:CGSize(width: Int(imageSize.width * factor), height: Int(imageSize.height * factor)))
        }
        return CGRect.zero
    }
}
extension NSLayoutManager
{
    private func rangesForAttachment(attachment: NSTextAttachment) -> [NSRange]?
    {
        guard let attributedString = self.textStorage else
        {
            return nil
        }
        let range = NSRange(location: 0, length: attributedString.length)
        var refreshRanges = [NSRange]()
        attributedString.enumerateAttribute(NSAttributedString.Key.attachment, in: range, options: []) { (value, effectiveRange, nil) in
            guard let foundAttachment = value as? NSTextAttachment, foundAttachment == attachment else
            {
                return
            }
            refreshRanges.append(effectiveRange)
        }
        if refreshRanges.count == 0
        {
            return nil
        }
        return refreshRanges
    }
    public func setNeedsLayout(forAttachment attachment: NSTextAttachment)
    {
        guard let ranges = rangesForAttachment(attachment: attachment) else
        {
            return
        }
        for range in ranges.reversed() {
            self.invalidateLayout(forCharacterRange: range, actualCharacterRange: nil)
            self.invalidateDisplay(forCharacterRange: range)
        }
    }
    public func setNeedsDisplay(forAttachment attachment: NSTextAttachment)
    {
        guard let ranges = rangesForAttachment(attachment: attachment) else
        {
            return
        }
        for range in ranges.reversed() {
            self.invalidateDisplay(forCharacterRange: range)
        }
    }
}
#endif