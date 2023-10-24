#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif
extension KingfisherWrapper where Base: KFCrossPlatformImage {
    @available(*, deprecated, message:
    "Will be removed soon. Pass parameters with `ImageCreatingOptions`, use `image(with:options:)` instead.")
    public static func image(
        data: Data,
        scale: CGFloat,
        preloadAllAnimationData: Bool,
        onlyFirstFrame: Bool) -> KFCrossPlatformImage?
    {
        let options = ImageCreatingOptions(
            scale: scale,
            duration: 0.0,
            preloadAll: preloadAllAnimationData,
            onlyFirstFrame: onlyFirstFrame)
        return KingfisherWrapper.image(data: data, options: options)
    }
    @available(*, deprecated, message:
    "Will be removed soon. Pass parameters with `ImageCreatingOptions`, use `animatedImage(with:options:)` instead.")
    public static func animated(
        with data: Data,
        scale: CGFloat = 1.0,
        duration: TimeInterval = 0.0,
        preloadAll: Bool,
        onlyFirstFrame: Bool = false) -> KFCrossPlatformImage?
    {
        let options = ImageCreatingOptions(
            scale: scale, duration: duration, preloadAll: preloadAll, onlyFirstFrame: onlyFirstFrame)
        return animatedImage(data: data, options: options)
    }
}
@available(*, deprecated, message: "Will be removed soon. Use `Result<RetrieveImageResult>` based callback instead")
public typealias CompletionHandler =
    ((_ image: KFCrossPlatformImage?, _ error: NSError?, _ cacheType: CacheType, _ imageURL: URL?) -> Void)
@available(*, deprecated, message: "Will be removed soon. Use `Result<ImageLoadingResult>` based callback instead")
public typealias ImageDownloaderCompletionHandler =
    ((_ image: KFCrossPlatformImage?, _ error: NSError?, _ url: URL?, _ originalData: Data?) -> Void)
@available(*, deprecated, message: "Will be removed soon. Use `DownloadTask` to cancel a task.")
extension RetrieveImageTask {
    @available(*, deprecated, message: "RetrieveImageTask.empty will be removed soon. Use `nil` to represent a no task.")
    public static let empty = RetrieveImageTask()
}
extension KingfisherManager {
    @available(*, deprecated, message: "Use `Result` based callback instead.")
    @discardableResult
    public func retrieveImage(with resource: Resource,
                              options: KingfisherOptionsInfo?,
                              progressBlock: DownloadProgressBlock?,
                              completionHandler: CompletionHandler?) -> DownloadTask?
    {
        return retrieveImage(with: resource, options: options, progressBlock: progressBlock) {
            result in
            switch result {
            case .success(let value): completionHandler?(value.image, nil, value.cacheType, value.source.url)
            case .failure(let error): completionHandler?(nil, error as NSError, .none, resource.downloadURL)
            }
        }
    }
}
extension ImageDownloader {
    @available(*, deprecated, message: "Use `Result` based callback instead.")
    @discardableResult
    open func downloadImage(with url: URL,
                            retrieveImageTask: RetrieveImageTask? = nil,
                            options: KingfisherOptionsInfo? = nil,
                            progressBlock: ImageDownloaderProgressBlock? = nil,
                            completionHandler: ImageDownloaderCompletionHandler?) -> DownloadTask?
    {
        return downloadImage(with: url, options: options, progressBlock: progressBlock) {
            result in
            switch result {
            case .success(let value): completionHandler?(value.image, nil, value.url, value.originalData)
            case .failure(let error): completionHandler?(nil, error as NSError, nil, nil)
            }
        }
    }
}
@available(*, deprecated, message: "RetrieveImageDownloadTask is removed. Use `DownloadTask` to cancel a task.")
public struct RetrieveImageDownloadTask {
}
@available(*, deprecated, message: "RetrieveImageTask is removed. Use `DownloadTask` to cancel a task.")
public final class RetrieveImageTask {
}
@available(*, deprecated, message: "Use `DownloadProgressBlock` instead.", renamed: "DownloadProgressBlock")
public typealias ImageDownloaderProgressBlock = DownloadProgressBlock
#if !os(watchOS)
extension KingfisherWrapper where Base: KFCrossPlatformImageView {
    @available(*, deprecated, message: "Use `Result` based callback instead.")
    @discardableResult
    public func setImage(with resource: Resource?,
                         placeholder: Placeholder? = nil,
                         options: KingfisherOptionsInfo? = nil,
                         progressBlock: DownloadProgressBlock? = nil,
                         completionHandler: CompletionHandler?) -> DownloadTask?
    {
        return setImage(with: resource, placeholder: placeholder, options: options, progressBlock: progressBlock) {
            result in
            switch result {
            case .success(let value):
                completionHandler?(value.image, nil, value.cacheType, value.source.url)
            case .failure(let error):
                completionHandler?(nil, error as NSError, .none, nil)
            }
        }
    }
}
#endif
#if canImport(UIKit) && !os(watchOS)
extension KingfisherWrapper where Base: UIButton {
    @available(*, deprecated, message: "Use `Result` based callback instead.")
    @discardableResult
    public func setImage(
        with resource: Resource?,
        for state: UIControl.State,
        placeholder: UIImage? = nil,
        options: KingfisherOptionsInfo? = nil,
        progressBlock: DownloadProgressBlock? = nil,
        completionHandler: CompletionHandler?) -> DownloadTask?
    {
        return setImage(
            with: resource,
            for: state,
            placeholder: placeholder,
            options: options,
            progressBlock: progressBlock)
        {
            result in
            switch result {
            case .success(let value):
                completionHandler?(value.image, nil, value.cacheType, value.source.url)
            case .failure(let error):
                completionHandler?(nil, error as NSError, .none, nil)
            }
        }
    }
    @available(*, deprecated, message: "Use `Result` based callback instead.")
    @discardableResult
    public func setBackgroundImage(
        with resource: Resource?,
        for state: UIControl.State,
        placeholder: UIImage? = nil,
        options: KingfisherOptionsInfo? = nil,
        progressBlock: DownloadProgressBlock? = nil,
        completionHandler: CompletionHandler?) -> DownloadTask?
    {
        return setBackgroundImage(
            with: resource,
            for: state,
            placeholder: placeholder,
            options: options,
            progressBlock: progressBlock)
        {
            result in
            switch result {
            case .success(let value):
                completionHandler?(value.image, nil, value.cacheType, value.source.url)
            case .failure(let error):
                completionHandler?(nil, error as NSError, .none, nil)
            }
        }
    }
}
#endif
#if os(watchOS)
import WatchKit
extension KingfisherWrapper where Base: WKInterfaceImage {
    @available(*, deprecated, message: "Use `Result` based callback instead.")
    @discardableResult
    public func setImage(_ resource: Resource?,
                         placeholder: KFCrossPlatformImage? = nil,
                         options: KingfisherOptionsInfo? = nil,
                         progressBlock: DownloadProgressBlock? = nil,
                         completionHandler: CompletionHandler?) -> DownloadTask?
    {
        return setImage(
            with: resource,
            placeholder: placeholder,
            options: options,
            progressBlock: progressBlock)
        {
            result in
            switch result {
            case .success(let value):
                completionHandler?(value.image, nil, value.cacheType, value.source.url)
            case .failure(let error):
                completionHandler?(nil, error as NSError, .none, nil)
            }
        }
    }
}
#endif
#if os(macOS)
extension KingfisherWrapper where Base: NSButton {
    @discardableResult
    @available(*, deprecated, message: "Use `Result` based callback instead.")
    public func setImage(with resource: Resource?,
                         placeholder: KFCrossPlatformImage? = nil,
                         options: KingfisherOptionsInfo? = nil,
                         progressBlock: DownloadProgressBlock? = nil,
                         completionHandler: CompletionHandler?) -> DownloadTask?
    {
        return setImage(
            with: resource,
            placeholder: placeholder,
            options: options,
            progressBlock: progressBlock)
        {
            result in
            switch result {
            case .success(let value):
                completionHandler?(value.image, nil, value.cacheType, value.source.url)
            case .failure(let error):
                completionHandler?(nil, error as NSError, .none, nil)
            }
        }
    }
    @discardableResult
    @available(*, deprecated, message: "Use `Result` based callback instead.")
    public func setAlternateImage(with resource: Resource?,
                                  placeholder: KFCrossPlatformImage? = nil,
                                  options: KingfisherOptionsInfo? = nil,
                                  progressBlock: DownloadProgressBlock? = nil,
                                  completionHandler: CompletionHandler?) -> DownloadTask?
    {
        return setAlternateImage(
            with: resource,
            placeholder: placeholder,
            options: options,
            progressBlock: progressBlock)
        {
            result in
            switch result {
            case .success(let value):
                completionHandler?(value.image, nil, value.cacheType, value.source.url)
            case .failure(let error):
                completionHandler?(nil, error as NSError, .none, nil)
            }
        }
    }
}
#endif
extension ImageCache {
    @available(*, deprecated, message: "Use `memoryStorage.config.totalCostLimit` instead.",
    renamed: "memoryStorage.config.totalCostLimit")
    open var maxMemoryCost: Int {
        get { return memoryStorage.config.totalCostLimit }
        set { memoryStorage.config.totalCostLimit = newValue }
    }
    @available(*, deprecated, message: "Not needed anymore.")
    public final class func defaultDiskCachePathClosure(path: String?, cacheName: String) -> String {
        let dstPath = path ?? NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first!
        return (dstPath as NSString).appendingPathComponent(cacheName)
    }
    @available(*, deprecated, message: "Use `diskStorage.config.pathExtension` instead.",
    renamed: "diskStorage.config.pathExtension")
    open var pathExtension: String? {
        get { return diskStorage.config.pathExtension }
        set { diskStorage.config.pathExtension = newValue }
    }
    @available(*, deprecated, message: "Use `diskStorage.directoryURL.absoluteString` instead.",
    renamed: "diskStorage.directoryURL.absoluteString")
    public var diskCachePath: String {
        return diskStorage.directoryURL.absoluteString
    }
    @available(*, deprecated, message: "Use `diskStorage.config.sizeLimit` instead.",
    renamed: "diskStorage.config.sizeLimit")
    open var maxDiskCacheSize: UInt {
        get { return UInt(diskStorage.config.sizeLimit) }
        set { diskStorage.config.sizeLimit = newValue }
    }
    @available(*, deprecated, message: "Use `diskStorage.cacheFileURL(forKey:).path` instead.",
    renamed: "diskStorage.cacheFileURL(forKey:)")
    open func cachePath(forComputedKey key: String) -> String {
        return diskStorage.cacheFileURL(forKey: key).path
    }
    @available(*, deprecated,
    message: "Use `Result` based `retrieveImageInDiskCache(forKey:options:callbackQueue:completionHandler:)` instead.",
    renamed: "retrieveImageInDiskCache(forKey:options:callbackQueue:completionHandler:)")
    open func retrieveImageInDiskCache(forKey key: String, options: KingfisherOptionsInfo? = nil) -> KFCrossPlatformImage? {
        let options = KingfisherParsedOptionsInfo(options ?? .empty)
        let computedKey = key.computedKey(with: options.processor.identifier)
        do {
            if let data = try diskStorage.value(forKey: computedKey, extendingExpiration: options.diskCacheAccessExtendingExpiration) {
                return options.cacheSerializer.image(with: data, options: options)
            }
        } catch {}
        return nil
    }
    @available(*, deprecated,
    message: "Use `Result` based `retrieveImage(forKey:options:callbackQueue:completionHandler:)` instead.",
    renamed: "retrieveImage(forKey:options:callbackQueue:completionHandler:)")
    open func retrieveImage(forKey key: String,
                            options: KingfisherOptionsInfo?,
                            completionHandler: ((KFCrossPlatformImage?, CacheType) -> Void)?)
    {
        retrieveImage(
            forKey: key,
            options: options,
            callbackQueue: .dispatch((options ?? .empty).callbackDispatchQueue))
        {
            result in
            do {
                let value = try result.get()
                completionHandler?(value.image, value.cacheType)
            } catch {
                completionHandler?(nil, .none)
            }
        }
    }
    @available(*, deprecated, message: "Deprecated. Use `diskStorage.config.expiration` instead")
    open var maxCachePeriodInSecond: TimeInterval {
        get { return diskStorage.config.expiration.timeInterval }
        set { diskStorage.config.expiration = newValue < 0 ? .never : .seconds(newValue) }
    }
    @available(*, deprecated, message: "Use `Result` based callback instead.")
    open func store(_ image: KFCrossPlatformImage,
                    original: Data? = nil,
                    forKey key: String,
                    processorIdentifier identifier: String = "",
                    cacheSerializer serializer: CacheSerializer = DefaultCacheSerializer.default,
                    toDisk: Bool = true,
                    completionHandler: (() -> Void)?)
    {
        store(
            image,
            original: original,
            forKey: key,
            processorIdentifier: identifier,
            cacheSerializer: serializer,
            toDisk: toDisk)
        {
            _ in
            completionHandler?()
        }
    }
    @available(*, deprecated, message: "Use the `Result`-based `calculateDiskStorageSize` instead.")
    open func calculateDiskCacheSize(completion handler: @escaping ((_ size: UInt) -> Void)) {
        calculateDiskStorageSize { result in
            let size: UInt? = try? result.get()
            handler(size ?? 0)
        }
    }
}
extension Collection where Iterator.Element == KingfisherOptionsInfoItem {
    @available(*, deprecated, message: "Use `callbackQueue` instead.", renamed: "callbackQueue")
    public var callbackDispatchQueue: DispatchQueue {
        return KingfisherParsedOptionsInfo(Array(self)).callbackQueue.queue
    }
}
@available(*, deprecated, message: "Use `KingfisherError.domain` instead.", renamed: "KingfisherError.domain")
public let KingfisherErrorDomain = "com.onevcat.Kingfisher.Error"
@available(*, unavailable,
message: "Use `.invalidHTTPStatusCode` or `isInvalidResponseStatusCode` of `KingfisherError` instead for the status code.")
public let KingfisherErrorStatusCodeKey = "statusCode"
extension Collection where Iterator.Element == KingfisherOptionsInfoItem {
    @available(*, deprecated,
    message: "Create a `KingfisherParsedOptionsInfo` from `KingfisherOptionsInfo` and use `targetCache` instead.")
    public var targetCache: ImageCache? {
        return KingfisherParsedOptionsInfo(Array(self)).targetCache
    }
    @available(*, deprecated,
    message: "Create a `KingfisherParsedOptionsInfo` from `KingfisherOptionsInfo` and use `originalCache` instead.")
    public var originalCache: ImageCache? {
        return KingfisherParsedOptionsInfo(Array(self)).originalCache
    }
    @available(*, deprecated,
    message: "Create a `KingfisherParsedOptionsInfo` from `KingfisherOptionsInfo` and use `downloader` instead.")
    public var downloader: ImageDownloader? {
        return KingfisherParsedOptionsInfo(Array(self)).downloader
    }
    @available(*, deprecated,
    message: "Create a `KingfisherParsedOptionsInfo` from `KingfisherOptionsInfo` and use `transition` instead.")
    public var transition: ImageTransition {
        return KingfisherParsedOptionsInfo(Array(self)).transition
    }
    @available(*, deprecated,
    message: "Create a `KingfisherParsedOptionsInfo` from `KingfisherOptionsInfo` and use `downloadPriority` instead.")
    public var downloadPriority: Float {
        return KingfisherParsedOptionsInfo(Array(self)).downloadPriority
    }
    @available(*, deprecated,
    message: "Create a `KingfisherParsedOptionsInfo` from `KingfisherOptionsInfo` and use `forceRefresh` instead.")
    public var forceRefresh: Bool {
        return KingfisherParsedOptionsInfo(Array(self)).forceRefresh
    }
    @available(*, deprecated,
    message: "Create a `KingfisherParsedOptionsInfo` from `KingfisherOptionsInfo` and use `fromMemoryCacheOrRefresh` instead.")
    public var fromMemoryCacheOrRefresh: Bool {
        return KingfisherParsedOptionsInfo(Array(self)).fromMemoryCacheOrRefresh
    }
    @available(*, deprecated,
    message: "Create a `KingfisherParsedOptionsInfo` from `KingfisherOptionsInfo` and use `forceTransition` instead.")
    public var forceTransition: Bool {
        return KingfisherParsedOptionsInfo(Array(self)).forceTransition
    }
    @available(*, deprecated,
    message: "Create a `KingfisherParsedOptionsInfo` from `KingfisherOptionsInfo` and use `cacheMemoryOnly` instead.")
    public var cacheMemoryOnly: Bool {
        return KingfisherParsedOptionsInfo(Array(self)).cacheMemoryOnly
    }
    @available(*, deprecated,
    message: "Create a `KingfisherParsedOptionsInfo` from `KingfisherOptionsInfo` and use `waitForCache` instead.")
    public var waitForCache: Bool {
        return KingfisherParsedOptionsInfo(Array(self)).waitForCache
    }
    @available(*, deprecated,
    message: "Create a `KingfisherParsedOptionsInfo` from `KingfisherOptionsInfo` and use `onlyFromCache` instead.")
    public var onlyFromCache: Bool {
        return KingfisherParsedOptionsInfo(Array(self)).onlyFromCache
    }
    @available(*, deprecated,
    message: "Create a `KingfisherParsedOptionsInfo` from `KingfisherOptionsInfo` and use `backgroundDecode` instead.")
    public var backgroundDecode: Bool {
        return KingfisherParsedOptionsInfo(Array(self)).backgroundDecode
    }
    @available(*, deprecated,
    message: "Create a `KingfisherParsedOptionsInfo` from `KingfisherOptionsInfo` and use `preloadAllAnimationData` instead.")
    public var preloadAllAnimationData: Bool {
        return KingfisherParsedOptionsInfo(Array(self)).preloadAllAnimationData
    }
    @available(*, deprecated,
    message: "Create a `KingfisherParsedOptionsInfo` from `KingfisherOptionsInfo` and use `callbackQueue` instead.")
    public var callbackQueue: CallbackQueue {
        return KingfisherParsedOptionsInfo(Array(self)).callbackQueue
    }
    @available(*, deprecated,
    message: "Create a `KingfisherParsedOptionsInfo` from `KingfisherOptionsInfo` and use `scaleFactor` instead.")
    public var scaleFactor: CGFloat {
        return KingfisherParsedOptionsInfo(Array(self)).scaleFactor
    }
    @available(*, deprecated,
    message: "Create a `KingfisherParsedOptionsInfo` from `KingfisherOptionsInfo` and use `requestModifier` instead.")
    public var modifier: ImageDownloadRequestModifier? {
        return KingfisherParsedOptionsInfo(Array(self)).requestModifier
    }
    @available(*, deprecated,
    message: "Create a `KingfisherParsedOptionsInfo` from `KingfisherOptionsInfo` and use `processor` instead.")
    public var processor: ImageProcessor {
        return KingfisherParsedOptionsInfo(Array(self)).processor
    }
    @available(*, deprecated,
    message: "Create a `KingfisherParsedOptionsInfo` from `KingfisherOptionsInfo` and use `imageModifier` instead.")
    public var imageModifier: ImageModifier? {
        return KingfisherParsedOptionsInfo(Array(self)).imageModifier
    }
    @available(*, deprecated,
    message: "Create a `KingfisherParsedOptionsInfo` from `KingfisherOptionsInfo` and use `cacheSerializer` instead.")
    public var cacheSerializer: CacheSerializer {
        return KingfisherParsedOptionsInfo(Array(self)).cacheSerializer
    }
    @available(*, deprecated,
    message: "Create a `KingfisherParsedOptionsInfo` from `KingfisherOptionsInfo` and use `keepCurrentImageWhileLoading` instead.")
    public var keepCurrentImageWhileLoading: Bool {
        return KingfisherParsedOptionsInfo(Array(self)).keepCurrentImageWhileLoading
    }
    @available(*, deprecated,
    message: "Create a `KingfisherParsedOptionsInfo` from `KingfisherOptionsInfo` and use `onlyLoadFirstFrame` instead.")
    public var onlyLoadFirstFrame: Bool {
        return KingfisherParsedOptionsInfo(Array(self)).onlyLoadFirstFrame
    }
    @available(*, deprecated,
    message: "Create a `KingfisherParsedOptionsInfo` from `KingfisherOptionsInfo` and use `cacheOriginalImage` instead.")
    public var cacheOriginalImage: Bool {
        return KingfisherParsedOptionsInfo(Array(self)).cacheOriginalImage
    }
    @available(*, deprecated,
    message: "Create a `KingfisherParsedOptionsInfo` from `KingfisherOptionsInfo` and use `onFailureImage` instead.")
    public var onFailureImage: Optional<KFCrossPlatformImage?> {
        return KingfisherParsedOptionsInfo(Array(self)).onFailureImage
    }
    @available(*, deprecated,
    message: "Create a `KingfisherParsedOptionsInfo` from `KingfisherOptionsInfo` and use `alsoPrefetchToMemory` instead.")
    public var alsoPrefetchToMemory: Bool {
        return KingfisherParsedOptionsInfo(Array(self)).alsoPrefetchToMemory
    }
    @available(*, deprecated,
    message: "Create a `KingfisherParsedOptionsInfo` from `KingfisherOptionsInfo` and use `loadDiskFileSynchronously` instead.")
    public var loadDiskFileSynchronously: Bool {
        return KingfisherParsedOptionsInfo(Array(self)).loadDiskFileSynchronously
    }
}
@available(*, deprecated, message: "Use `nil` in KingfisherOptionsInfo to indicate no modifier.")
public struct DefaultImageModifier: ImageModifier {
    public static let `default` = DefaultImageModifier()
    private init() {}
    public func modify(_ image: KFCrossPlatformImage) -> KFCrossPlatformImage { return image }
}
#if os(macOS)
@available(*, deprecated, message: "Use `KFCrossPlatformImage` instead.")
public typealias Image = KFCrossPlatformImage
@available(*, deprecated, message: "Use `KFCrossPlatformView` instead.")
public typealias View = KFCrossPlatformView
@available(*, deprecated, message: "Use `KFCrossPlatformColor` instead.")
public typealias Color = KFCrossPlatformColor
@available(*, deprecated, message: "Use `KFCrossPlatformImageView` instead.")
public typealias ImageView = KFCrossPlatformImageView
@available(*, deprecated, message: "Use `KFCrossPlatformButton` instead.")
public typealias Button = KFCrossPlatformButton
#else
@available(*, deprecated, message: "Use `KFCrossPlatformImage` instead.")
public typealias Image = KFCrossPlatformImage
@available(*, deprecated, message: "Use `KFCrossPlatformColor` instead.")
public typealias Color = KFCrossPlatformColor
    #if !os(watchOS)
    @available(*, deprecated, message: "Use `KFCrossPlatformImageView` instead.")
    public typealias ImageView = KFCrossPlatformImageView
    @available(*, deprecated, message: "Use `KFCrossPlatformView` instead.")
    public typealias View = KFCrossPlatformView
    @available(*, deprecated, message: "Use `KFCrossPlatformButton` instead.")
    public typealias Button = KFCrossPlatformButton
    #endif
#endif