#if os(macOS)
import AppKit
#else
import UIKit
#endif
public typealias PrefetcherProgressBlock =
    ((_ skippedResources: [Resource], _ failedResources: [Resource], _ completedResources: [Resource]) -> Void)
public typealias PrefetcherSourceProgressBlock =
    ((_ skippedSources: [Source], _ failedSources: [Source], _ completedSources: [Source]) -> Void)
public typealias PrefetcherCompletionHandler =
    ((_ skippedResources: [Resource], _ failedResources: [Resource], _ completedResources: [Resource]) -> Void)
public typealias PrefetcherSourceCompletionHandler =
    ((_ skippedSources: [Source], _ failedSources: [Source], _ completedSources: [Source]) -> Void)
public class ImagePrefetcher: CustomStringConvertible {
    public var description: String {
        return "\(Unmanaged.passUnretained(self).toOpaque())"
    }
    public var maxConcurrentDownloads = 5
    private let prefetchSources: [Source]
    private let optionsInfo: KingfisherParsedOptionsInfo
    private var progressBlock: PrefetcherProgressBlock?
    private var completionHandler: PrefetcherCompletionHandler?
    private var progressSourceBlock: PrefetcherSourceProgressBlock?
    private var completionSourceHandler: PrefetcherSourceCompletionHandler?
    private var tasks = [String: DownloadTask.WrappedTask]()
    private var pendingSources: ArraySlice<Source>
    private var skippedSources = [Source]()
    private var completedSources = [Source]()
    private var failedSources = [Source]()
    private var stopped = false
    private let manager: KingfisherManager
    private let pretchQueue = DispatchQueue(label: "com.onevcat.Kingfisher.ImagePrefetcher.pretchQueue")
    private static let requestingQueue = DispatchQueue(label: "com.onevcat.Kingfisher.ImagePrefetcher.requestingQueue")
    private var finished: Bool {
        let totalFinished: Int = failedSources.count + skippedSources.count + completedSources.count
        return totalFinished == prefetchSources.count && tasks.isEmpty
    }
    public convenience init(
        urls: [URL],
        options: KingfisherOptionsInfo? = nil,
        progressBlock: PrefetcherProgressBlock? = nil,
        completionHandler: PrefetcherCompletionHandler? = nil)
    {
        let resources: [Resource] = urls.map { $0 }
        self.init(
            resources: resources,
            options: options,
            progressBlock: progressBlock,
            completionHandler: completionHandler)
    }
    public convenience init(
        resources: [Resource],
        options: KingfisherOptionsInfo? = nil,
        progressBlock: PrefetcherProgressBlock? = nil,
        completionHandler: PrefetcherCompletionHandler? = nil)
    {
        self.init(sources: resources.map { $0.convertToSource() }, options: options)
        self.progressBlock = progressBlock
        self.completionHandler = completionHandler
    }
    public convenience init(sources: [Source],
        options: KingfisherOptionsInfo? = nil,
        progressBlock: PrefetcherSourceProgressBlock? = nil,
        completionHandler: PrefetcherSourceCompletionHandler? = nil)
    {
        self.init(sources: sources, options: options)
        self.progressSourceBlock = progressBlock
        self.completionSourceHandler = completionHandler
    }
    init(sources: [Source], options: KingfisherOptionsInfo?) {
        var options = KingfisherParsedOptionsInfo(options)
        prefetchSources = sources
        pendingSources = ArraySlice(sources)
        options.callbackQueue = .dispatch(pretchQueue)
        optionsInfo = options
        let cache = optionsInfo.targetCache ?? .default
        let downloader = optionsInfo.downloader ?? .default
        manager = KingfisherManager(downloader: downloader, cache: cache)
    }
    public func start() {
        pretchQueue.async {
            guard !self.stopped else {
                assertionFailure("You can not restart the same prefetcher. Try to create a new prefetcher.")
                self.handleComplete()
                return
            }
            guard self.maxConcurrentDownloads > 0 else {
                assertionFailure("There should be concurrent downloads value should be at least 1.")
                self.handleComplete()
                return
            }
            guard self.prefetchSources.count > 0 else {
                self.handleComplete()
                return
            }
            let initialConcurrentDownloads = min(self.prefetchSources.count, self.maxConcurrentDownloads)
            for _ in 0 ..< initialConcurrentDownloads {
                if let resource = self.pendingSources.popFirst() {
                    self.startPrefetching(resource)
                }
            }
        }
    }
    public func stop() {
        pretchQueue.async {
            if self.finished { return }
            self.stopped = true
            self.tasks.values.forEach { $0.cancel() }
        }
    }
    private func downloadAndCache(_ source: Source) {
        let downloadTaskCompletionHandler: ((Result<RetrieveImageResult, KingfisherError>) -> Void) = { result in
            self.tasks.removeValue(forKey: source.cacheKey)
            do {
                let _ = try result.get()
                self.completedSources.append(source)
            } catch {
                self.failedSources.append(source)
            }
            self.reportProgress()
            if self.stopped {
                if self.tasks.isEmpty {
                    self.failedSources.append(contentsOf: self.pendingSources)
                    self.handleComplete()
                }
            } else {
                self.reportCompletionOrStartNext()
            }
        }
        var downloadTask: DownloadTask.WrappedTask?
        ImagePrefetcher.requestingQueue.sync {
            let context = RetrievingContext(
                options: optionsInfo, originalSource: source
            )
            downloadTask = manager.loadAndCacheImage(
                source: source,
                context: context,
                completionHandler: downloadTaskCompletionHandler)
        }
        if let downloadTask = downloadTask {
            tasks[source.cacheKey] = downloadTask
        }
    }
    private func append(cached source: Source) {
        skippedSources.append(source)
        reportProgress()
        reportCompletionOrStartNext()
    }
    private func startPrefetching(_ source: Source)
    {
        if optionsInfo.forceRefresh {
            downloadAndCache(source)
            return
        }
        let cacheType = manager.cache.imageCachedType(
            forKey: source.cacheKey,
            processorIdentifier: optionsInfo.processor.identifier)
        switch cacheType {
        case .memory:
            append(cached: source)
        case .disk:
            if optionsInfo.alsoPrefetchToMemory {
                let context = RetrievingContext(options: optionsInfo, originalSource: source)
                _ = manager.retrieveImageFromCache(
                    source: source,
                    context: context)
                {
                    _ in
                    self.append(cached: source)
                }
            } else {
                append(cached: source)
            }
        case .none:
            downloadAndCache(source)
        }
    }
    private func reportProgress() {
        if progressBlock == nil && progressSourceBlock == nil {
            return
        }
        let skipped = self.skippedSources
        let failed = self.failedSources
        let completed = self.completedSources
        CallbackQueue.mainCurrentOrAsync.execute {
            self.progressSourceBlock?(skipped, failed, completed)
            self.progressBlock?(
                skipped.compactMap { $0.asResource },
                failed.compactMap { $0.asResource },
                completed.compactMap { $0.asResource }
            )
        }
    }
    private func reportCompletionOrStartNext() {
        if let resource = self.pendingSources.popFirst() {
            pretchQueue.async { self.startPrefetching(resource) }
        } else {
            guard allFinished else { return }
            self.handleComplete()
        }
    }
    var allFinished: Bool {
        return skippedSources.count + failedSources.count + completedSources.count == prefetchSources.count
    }
    private func handleComplete() {
        if completionHandler == nil && completionSourceHandler == nil {
            return
        }
        CallbackQueue.mainCurrentOrAsync.execute {
            self.completionSourceHandler?(self.skippedSources, self.failedSources, self.completedSources)
            self.completionHandler?(
                self.skippedSources.compactMap { $0.asResource },
                self.failedSources.compactMap { $0.asResource },
                self.completedSources.compactMap { $0.asResource }
            )
            self.completionHandler = nil
            self.progressBlock = nil
        }
    }
}