#if !os(watchOS)
#if canImport(UIKit)
import UIKit
import ImageIO
public protocol AnimatedImageViewDelegate: AnyObject {
    func animatedImageView(_ imageView: AnimatedImageView, didPlayAnimationLoops count: UInt)
    func animatedImageViewDidFinishAnimating(_ imageView: AnimatedImageView)
}
extension AnimatedImageViewDelegate {
    public func animatedImageView(_ imageView: AnimatedImageView, didPlayAnimationLoops count: UInt) {}
    public func animatedImageViewDidFinishAnimating(_ imageView: AnimatedImageView) {}
}
#if swift(>=4.2)
let KFRunLoopModeCommon = RunLoop.Mode.common
#else
let KFRunLoopModeCommon = RunLoopMode.commonModes
#endif
open class AnimatedImageView: UIImageView {
    class TargetProxy {
        private weak var target: AnimatedImageView?
        init(target: AnimatedImageView) {
            self.target = target
        }
        @objc func onScreenUpdate() {
            target?.updateFrameIfNeeded()
        }
    }
    public enum RepeatCount: Equatable {
        case once
        case finite(count: UInt)
        case infinite
        public static func ==(lhs: RepeatCount, rhs: RepeatCount) -> Bool {
            switch (lhs, rhs) {
            case let (.finite(l), .finite(r)):
                return l == r
            case (.once, .once),
                 (.infinite, .infinite):
                return true
            case (.once, .finite(let count)),
                 (.finite(let count), .once):
                return count == 1
            case (.once, _),
                 (.infinite, _),
                 (.finite, _):
                return false
            }
        }
    }
    public var autoPlayAnimatedImage = true
    public var framePreloadCount = 10
    public var needsPrescaling = true
    public var backgroundDecode = true
    public var runLoopMode = KFRunLoopModeCommon {
        willSet {
            guard runLoopMode != newValue else { return }
            stopAnimating()
            displayLink.remove(from: .main, forMode: runLoopMode)
            displayLink.add(to: .main, forMode: newValue)
            startAnimating()
        }
    }
    public var repeatCount = RepeatCount.infinite {
        didSet {
            if oldValue != repeatCount {
                reset()
                setNeedsDisplay()
                layer.setNeedsDisplay()
            }
        }
    }
    public weak var delegate: AnimatedImageViewDelegate?
    private var animator: Animator?
    private lazy var preloadQueue: DispatchQueue = {
        return DispatchQueue(label: "com.onevcat.Kingfisher.Animator.preloadQueue")
    }()
    private var isDisplayLinkInitialized: Bool = false
    private lazy var displayLink: CADisplayLink = {
        isDisplayLinkInitialized = true
        let displayLink = CADisplayLink(
            target: TargetProxy(target: self), selector: #selector(TargetProxy.onScreenUpdate))
        displayLink.add(to: .main, forMode: runLoopMode)
        displayLink.isPaused = true
        return displayLink
    }()
    override open var image: KFCrossPlatformImage? {
        didSet {
            if image != oldValue {
                reset()
            }
            setNeedsDisplay()
            layer.setNeedsDisplay()
        }
    }
    deinit {
        if isDisplayLinkInitialized {
            displayLink.invalidate()
        }
    }
    override open var isAnimating: Bool {
        if isDisplayLinkInitialized {
            return !displayLink.isPaused
        } else {
            return super.isAnimating
        }
    }
    override open func startAnimating() {
        guard !isAnimating else { return }
        guard let animator = animator else { return }
        guard !animator.isReachMaxRepeatCount else { return }
        displayLink.isPaused = false
    }
    override open func stopAnimating() {
        super.stopAnimating()
        if isDisplayLinkInitialized {
            displayLink.isPaused = true
        }
    }
    override open func display(_ layer: CALayer) {
        if let currentFrame = animator?.currentFrameImage {
            layer.contents = currentFrame.cgImage
        } else {
            layer.contents = image?.cgImage
        }
    }
    override open func didMoveToWindow() {
        super.didMoveToWindow()
        didMove()
    }
    override open func didMoveToSuperview() {
        super.didMoveToSuperview()
        didMove()
    }
    override func shouldPreloadAllAnimation() -> Bool {
        return false
    }
    private func reset() {
        animator = nil
        if let imageSource = image?.kf.imageSource {
            let targetSize = bounds.scaled(UIScreen.main.scale).size
            let animator = Animator(
                imageSource: imageSource,
                contentMode: contentMode,
                size: targetSize,
                framePreloadCount: framePreloadCount,
                repeatCount: repeatCount,
                preloadQueue: preloadQueue)
            animator.delegate = self
            animator.needsPrescaling = needsPrescaling
            animator.backgroundDecode = backgroundDecode
            animator.prepareFramesAsynchronously()
            self.animator = animator
        }
        didMove()
    }
    private func didMove() {
        if autoPlayAnimatedImage && animator != nil {
            if let _ = superview, let _ = window {
                startAnimating()
            } else {
                stopAnimating()
            }
        }
    }
    private func updateFrameIfNeeded() {
        guard let animator = animator else {
            return
        }
        guard !animator.isFinished else {
            stopAnimating()
            delegate?.animatedImageViewDidFinishAnimating(self)
            return
        }
        let duration: CFTimeInterval
        let preferredFramesPerSecond = displayLink.preferredFramesPerSecond
        if preferredFramesPerSecond == 0 {
            duration = displayLink.duration
        } else {
            duration = 1.0 / TimeInterval(preferredFramesPerSecond)
        }
        animator.shouldChangeFrame(with: duration) { [weak self] hasNewFrame in
            if hasNewFrame {
                self?.layer.setNeedsDisplay()
            }
        }
    }
}
protocol AnimatorDelegate: AnyObject {
    func animator(_ animator: AnimatedImageView.Animator, didPlayAnimationLoops count: UInt)
}
extension AnimatedImageView: AnimatorDelegate {
    func animator(_ animator: Animator, didPlayAnimationLoops count: UInt) {
        delegate?.animatedImageView(self, didPlayAnimationLoops: count)
    }
}
extension AnimatedImageView {
    struct AnimatedFrame {
        let image: UIImage?
        let duration: TimeInterval
        var placeholderFrame: AnimatedFrame {
            return AnimatedFrame(image: nil, duration: duration)
        }
        var isPlaceholder: Bool {
            return image == nil
        }
        func makeAnimatedFrame(image: UIImage?) -> AnimatedFrame {
            return AnimatedFrame(image: image, duration: duration)
        }
    }
}
extension AnimatedImageView {
    class Animator {
        private let size: CGSize
        private let maxFrameCount: Int
        private let imageSource: CGImageSource
        private let maxRepeatCount: RepeatCount
        private let maxTimeStep: TimeInterval = 1.0
        private let animatedFrames = SafeArray<AnimatedFrame>()
        private var frameCount = 0
        private var timeSinceLastFrameChange: TimeInterval = 0.0
        private var currentRepeatCount: UInt = 0
        var isFinished: Bool = false
        var needsPrescaling = true
        var backgroundDecode = true
        weak var delegate: AnimatorDelegate?
        var loopDuration: TimeInterval = 0
        var currentFrameImage: UIImage? {
            return frame(at: currentFrameIndex)
        }
        var currentFrameDuration: TimeInterval {
            return duration(at: currentFrameIndex)
        }
        var currentFrameIndex = 0 {
            didSet {
                previousFrameIndex = oldValue
            }
        }
        var previousFrameIndex = 0 {
            didSet {
                preloadQueue.async {
                    self.updatePreloadedFrames()
                }
            }
        }
        var isReachMaxRepeatCount: Bool {
            switch maxRepeatCount {
            case .once:
                return currentRepeatCount >= 1
            case .finite(let maxCount):
                return currentRepeatCount >= maxCount
            case .infinite:
                return false
            }
        }
        var isLastFrame: Bool {
            return currentFrameIndex == frameCount - 1
        }
        var preloadingIsNeeded: Bool {
            return maxFrameCount < frameCount - 1
        }
        var contentMode = UIView.ContentMode.scaleToFill
        private lazy var preloadQueue: DispatchQueue = {
            return DispatchQueue(label: "com.onevcat.Kingfisher.Animator.preloadQueue")
        }()
        init(imageSource source: CGImageSource,
             contentMode mode: UIView.ContentMode,
             size: CGSize,
             framePreloadCount count: Int,
             repeatCount: RepeatCount,
             preloadQueue: DispatchQueue) {
            self.imageSource = source
            self.contentMode = mode
            self.size = size
            self.maxFrameCount = count
            self.maxRepeatCount = repeatCount
            self.preloadQueue = preloadQueue
        }
        func frame(at index: Int) -> KFCrossPlatformImage? {
            return animatedFrames[index]?.image
        }
        func duration(at index: Int) -> TimeInterval {
            return animatedFrames[index]?.duration  ?? .infinity
        }
        func prepareFramesAsynchronously() {
            frameCount = Int(CGImageSourceGetCount(imageSource))
            animatedFrames.reserveCapacity(frameCount)
            preloadQueue.async { [weak self] in
                self?.setupAnimatedFrames()
            }
        }
        func shouldChangeFrame(with duration: CFTimeInterval, handler: (Bool) -> Void) {
            incrementTimeSinceLastFrameChange(with: duration)
            if currentFrameDuration > timeSinceLastFrameChange {
                handler(false)
            } else {
                resetTimeSinceLastFrameChange()
                incrementCurrentFrameIndex()
                handler(true)
            }
        }
        private func setupAnimatedFrames() {
            resetAnimatedFrames()
            var duration: TimeInterval = 0
            (0..<frameCount).forEach { index in
                let frameDuration = GIFAnimatedImage.getFrameDuration(from: imageSource, at: index)
                duration += min(frameDuration, maxTimeStep)
                animatedFrames.append(AnimatedFrame(image: nil, duration: frameDuration))
                if index > maxFrameCount { return }
                animatedFrames[index] = animatedFrames[index]?.makeAnimatedFrame(image: loadFrame(at: index))
            }
            self.loopDuration = duration
        }
        private func resetAnimatedFrames() {
            animatedFrames.removeAll()
        }
        private func loadFrame(at index: Int) -> UIImage? {
            let options: [CFString: Any] = [
                kCGImageSourceCreateThumbnailFromImageIfAbsent: true,
                kCGImageSourceCreateThumbnailWithTransform: true,
                kCGImageSourceShouldCacheImmediately: true,
                kCGImageSourceThumbnailMaxPixelSize: max(size.width, size.height)
            ]
            let resize = needsPrescaling && size != .zero
            guard let cgImage = CGImageSourceCreateImageAtIndex(imageSource,
                                                                index,
                                                                resize ? options as CFDictionary : nil) else {
                return nil
            }
            let image = KFCrossPlatformImage(cgImage: cgImage)
            return backgroundDecode ? image.kf.decoded : image
        }
        private func updatePreloadedFrames() {
            guard preloadingIsNeeded else {
                return
            }
            animatedFrames[previousFrameIndex] = animatedFrames[previousFrameIndex]?.placeholderFrame
            preloadIndexes(start: currentFrameIndex).forEach { index in
                guard let currentAnimatedFrame = animatedFrames[index] else { return }
                if !currentAnimatedFrame.isPlaceholder { return }
                animatedFrames[index] = currentAnimatedFrame.makeAnimatedFrame(image: loadFrame(at: index))
            }
        }
        private func incrementCurrentFrameIndex() {
            currentFrameIndex = increment(frameIndex: currentFrameIndex)
            if isLastFrame {
                currentRepeatCount += 1
                if isReachMaxRepeatCount {
                    isFinished = true
                }
                delegate?.animator(self, didPlayAnimationLoops: currentRepeatCount)
            }
        }
        private func incrementTimeSinceLastFrameChange(with duration: TimeInterval) {
            timeSinceLastFrameChange += min(maxTimeStep, duration)
        }
        private func resetTimeSinceLastFrameChange() {
            timeSinceLastFrameChange -= currentFrameDuration
        }
        private func increment(frameIndex: Int, by value: Int = 1) -> Int {
            return (frameIndex + value) % frameCount
        }
        private func preloadIndexes(start index: Int) -> [Int] {
            let nextIndex = increment(frameIndex: index)
            let lastIndex = increment(frameIndex: index, by: maxFrameCount)
            if lastIndex >= nextIndex {
                return [Int](nextIndex...lastIndex)
            } else {
                return [Int](nextIndex..<frameCount) + [Int](0...lastIndex)
            }
        }
    }
}
class SafeArray<Element> {
    private var array: Array<Element> = []
    private let lock = NSLock()
    subscript(index: Int) -> Element? {
        get {
            lock.lock()
            defer { lock.unlock() }
            return array.indices ~= index ? array[index] : nil
        }
        set {
            lock.lock()
            defer { lock.unlock() }
            if let newValue = newValue, array.indices ~= index {
                array[index] = newValue
            }
        }
    }
    var count : Int {
        lock.lock()
        defer { lock.unlock() }
        return array.count
    }
    func reserveCapacity(_ count: Int) {
        lock.lock()
        defer { lock.unlock() }
        array.reserveCapacity(count)
    }
    func append(_ element: Element) {
        lock.lock()
        defer { lock.unlock() }
        array += [element]
    }
    func removeAll() {
        lock.lock()
        defer { lock.unlock() }
        array = []
    }
}
#endif
#endif