import Foundation
class CocoaMQTTTimer {
    let timeInterval: TimeInterval
    let startDelay: TimeInterval
    init(delay:TimeInterval?=nil, timeInterval: TimeInterval) {
        self.timeInterval = timeInterval
        if let delay = delay {
            self.startDelay = delay
        } else {
            self.startDelay = timeInterval
        }
    }
    class func every(_ interval: TimeInterval, _ block: @escaping () -> Void) -> CocoaMQTTTimer {
        let timer = CocoaMQTTTimer(timeInterval: interval)
        timer.eventHandler = block
        timer.resume()
        return timer
    }
    @discardableResult
    class func after(_ interval: TimeInterval, _ block: @escaping () -> Void) -> CocoaMQTTTimer {
        var timer : CocoaMQTTTimer? = CocoaMQTTTimer(delay: interval, timeInterval:0)
        timer?.eventHandler = {
            block()
            timer?.suspend()
            timer = nil
        }
        timer?.resume()
        return timer!
    }
    private lazy var timer: DispatchSourceTimer = {
        let t = DispatchSource.makeTimerSource()
        t.schedule(deadline: .now() + self.startDelay, repeating: self.timeInterval > 0 ? Double(self.timeInterval) : Double.infinity)
        t.setEventHandler(handler: { [weak self] in
            self?.eventHandler?()
        })
        return t
    }()
    var eventHandler: (() -> Void)?
    private enum State {
        case suspended
        case resumed
        case canceled
    }
    private var state: State = .suspended
    deinit {
        timer.setEventHandler {}
        timer.cancel()
        resume()
        eventHandler = nil
    }
    func resume() {
        if state == .resumed {
            return
        }
        state = .resumed
        timer.resume()
    }
    func suspend() {
        if state == .suspended {
            return
        }
        state = .suspended
        timer.suspend()
    }
    func cancel() {
        if state == .canceled {
            return
        }
        state = .canceled
        timer.cancel()
    }
}