#if os(Linux)
    import class Foundation.Thread
    extension Thread {
        static func setThreadLocalStorageValue<T: AnyObject>(_ value: T?, forKey key: String) {
            if let newValue = value {
                Thread.current.threadDictionary[key] = newValue
            }
            else {
                Thread.current.threadDictionary[key] = nil
            }
        }
        static func getThreadLocalStorageValueForKey<T: AnyObject>(_ key: String) -> T? {
            let currentThread = Thread.current
            let threadDictionary = currentThread.threadDictionary
            return threadDictionary[key] as? T
        }
    }
#endif