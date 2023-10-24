import struct Foundation.Date
public class HistoricalScheduler : VirtualTimeScheduler<HistoricalSchedulerTimeConverter> {
    public init(initialClock: RxTime = Date(timeIntervalSince1970: 0)) {
        super.init(initialClock: initialClock, converter: HistoricalSchedulerTimeConverter())
    }
}