import Foundation
import CoreGraphics
private let sharedProcessingQueue: CallbackQueue =
    .dispatch(DispatchQueue(label: "com.onevcat.Kingfisher.ImageDownloader.Process"))
public struct ImageProgressive {
    public static let `default` = ImageProgressive(
        isBlur: true,
        isFastestScan: true,
        scanInterval: 0
    )
    let isBlur: Bool
    let isFastestScan: Bool
    let scanInterval: TimeInterval
    public init(isBlur: Bool,
                isFastestScan: Bool,
                scanInterval: TimeInterval) {
        self.isBlur = isBlur
        self.isFastestScan = isFastestScan
        self.scanInterval = scanInterval
    }
}
protocol ImageSettable: AnyObject {
    var image: KFCrossPlatformImage? { get set }
}
final class ImageProgressiveProvider: DataReceivingSideEffect {
    var onShouldApply: () -> Bool = { return true }
    func onDataReceived(_ session: URLSession, task: SessionDataTask, data: Data) {
        DispatchQueue.main.async {
            guard self.onShouldApply() else { return }
            self.update(data: task.mutableData, with: task.callbacks)
        }
    }
    private let option: ImageProgressive
    private let refresh: (KFCrossPlatformImage) -> Void
    private let decoder: ImageProgressiveDecoder
    private let queue = ImageProgressiveSerialQueue()
    init?(_ options: KingfisherParsedOptionsInfo,
          refresh: @escaping (KFCrossPlatformImage) -> Void) {
        guard let option = options.progressiveJPEG else { return nil }
        self.option = option
        self.refresh = refresh
        self.decoder = ImageProgressiveDecoder(
            option,
            processingQueue: options.processingQueue ?? sharedProcessingQueue,
            creatingOptions: options.imageCreatingOptions
        )
    }
    func update(data: Data, with callbacks: [SessionDataTask.TaskCallback]) {
        guard !data.isEmpty else { return }
        queue.add(minimum: option.scanInterval) { completion in
            func decode(_ data: Data) {
                self.decoder.decode(data, with: callbacks) { image in
                    defer { completion() }
                    guard self.onShouldApply() else { return }
                    guard let image = image else { return }
                    self.refresh(image)
                }
            }
            let semaphore = DispatchSemaphore(value: 0)
            var onShouldApply: Bool = false
            CallbackQueue.mainAsync.execute {
                onShouldApply = self.onShouldApply()
                semaphore.signal()
            }
            semaphore.wait()
            guard onShouldApply else {
                self.queue.clean()
                completion()
                return
            }
            if self.option.isFastestScan {
                decode(self.decoder.scanning(data) ?? Data())
            } else {
                self.decoder.scanning(data).forEach { decode($0) }
            }
        }
    }
}
private final class ImageProgressiveDecoder {
    private let option: ImageProgressive
    private let processingQueue: CallbackQueue
    private let creatingOptions: ImageCreatingOptions
    private(set) var scannedCount = 0
    private(set) var scannedIndex = -1
    init(_ option: ImageProgressive,
         processingQueue: CallbackQueue,
         creatingOptions: ImageCreatingOptions) {
        self.option = option
        self.processingQueue = processingQueue
        self.creatingOptions = creatingOptions
    }
    func scanning(_ data: Data) -> [Data] {
        guard data.kf.contains(jpeg: .SOF2) else {
            return []
        }
        guard scannedIndex + 1 < data.count else {
            return []
        }
        var datas: [Data] = []
        var index = scannedIndex + 1
        var count = scannedCount
        while index < data.count - 1 {
            scannedIndex = index
            let SOS = ImageFormat.JPEGMarker.SOS.bytes
            if data[index] == SOS[0], data[index + 1] == SOS[1] {
                if count > 0 {
                    datas.append(data[0 ..< index])
                }
                count += 1
            }
            index += 1
        }
        guard count > scannedCount else { return [] }
        scannedCount = count
        guard count > 1 else { return [] }
        return datas
    }
    func scanning(_ data: Data) -> Data? {
        guard data.kf.contains(jpeg: .SOF2) else {
            return nil
        }
        guard scannedIndex + 1 < data.count else {
            return nil
        }
        var index = scannedIndex + 1
        var count = scannedCount
        var lastSOSIndex = 0
        while index < data.count - 1 {
            scannedIndex = index
            let SOS = ImageFormat.JPEGMarker.SOS.bytes
            if data[index] == SOS[0], data[index + 1] == SOS[1] {
                lastSOSIndex = index
                count += 1
            }
            index += 1
        }
        guard count > scannedCount else { return nil }
        scannedCount = count
        guard count > 1 && lastSOSIndex > 0 else { return nil }
        return data[0 ..< lastSOSIndex]
    }
    func decode(_ data: Data,
                with callbacks: [SessionDataTask.TaskCallback],
                completion: @escaping (KFCrossPlatformImage?) -> Void) {
        guard data.kf.contains(jpeg: .SOF2) else {
            CallbackQueue.mainCurrentOrAsync.execute { completion(nil) }
            return
        }
        func processing(_ data: Data) {
            let processor = ImageDataProcessor(
                data: data,
                callbacks: callbacks,
                processingQueue: processingQueue
            )
            processor.onImageProcessed.delegate(on: self) { (self, result) in
                guard let image = try? result.0.get() else {
                    CallbackQueue.mainCurrentOrAsync.execute { completion(nil) }
                    return
                }
                CallbackQueue.mainCurrentOrAsync.execute { completion(image) }
            }
            processor.process()
        }
        let count = scannedCount
        if option.isBlur, count < 6 {
            processingQueue.execute {
                let image = KingfisherWrapper<KFCrossPlatformImage>.image(
                    data: data,
                    options: self.creatingOptions
                )
                let radius = max(2, 14 - count * 4)
                let temp = image?.kf.blurred(withRadius: CGFloat(radius))
                processing(temp?.kf.data(format: .JPEG) ?? data)
            }
        } else {
            processing(data)
        }
    }
}
private final class ImageProgressiveSerialQueue {
    typealias ClosureCallback = ((@escaping () -> Void)) -> Void
    private let queue: DispatchQueue
    private var items: [DispatchWorkItem] = []
    private var notify: (() -> Void)?
    private var lastTime: TimeInterval?
    var count: Int { return items.count }
    init() {
        self.queue = DispatchQueue(label: "com.onevcat.Kingfisher.ImageProgressive.SerialQueue")
    }
    func add(minimum interval: TimeInterval, closure: @escaping ClosureCallback) {
        let completion = { [weak self] in
            guard let self = self else { return }
            self.queue.async { [weak self] in
                guard let self = self else { return }
                guard !self.items.isEmpty else { return }
                self.items.removeFirst()
                if let next = self.items.first {
                    self.queue.asyncAfter(
                        deadline: .now() + interval,
                        execute: next
                    )
                } else {
                    self.lastTime = Date().timeIntervalSince1970
                    self.notify?()
                    self.notify = nil
                }
            }
        }
        queue.async { [weak self] in
            guard let self = self else { return }
            let item = DispatchWorkItem {
                closure(completion)
            }
            if self.items.isEmpty {
                let difference = Date().timeIntervalSince1970 - (self.lastTime ?? 0)
                let delay = difference < interval ? interval - difference : 0
                self.queue.asyncAfter(deadline: .now() + delay, execute: item)
            }
            self.items.append(item)
        }
    }
    func notify(_ closure: @escaping () -> Void) {
        self.notify = closure
    }
    func clean() {
        queue.async { [weak self] in
            guard let self = self else { return }
            self.items.forEach { $0.cancel() }
            self.items.removeAll()
        }
    }
}