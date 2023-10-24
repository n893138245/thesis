extension String: SSCompatible {}
extension SS where Base == String {
    static let detailFormat = "yyyy-MM-dd'T'HH:mm:ss"
    static func getTextRectSize(text:String,font:UIFont,size:CGSize) -> CGRect {
        let attributes = [NSAttributedString.Key.font: font]
        let option = NSStringDrawingOptions.usesLineFragmentOrigin
        let rect:CGRect = text.boundingRect(with: size, options: option, attributes: attributes, context: nil)
        return rect;
    }
    static func dateConvertString(date:Date, dateFormat:String="HH:mm") -> String {
        let formatter = DateFormatter()
        formatter.timeZone = NSTimeZone.local
        formatter.locale = Locale.init(identifier: "zh_CN")
        formatter.dateFormat = dateFormat
        let date = formatter.string(from: date)
        return date.components(separatedBy: " ").first!
    }
    static func UTCStringFromDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        dateFormatter.dateFormat = detailFormat
        return dateFormatter.string(from: date).appending("Z")
    }
    static func localTimeWithUTCString(UTCtimeString: String, dateFormat: String = "HH:mm") -> String {
        if UTCtimeString.isEmpty {
            return UTCtimeString
        }
        var timeString = UTCtimeString
        timeString.removeLast() 
        let utcFormatter = DateFormatter()
        utcFormatter.locale = Locale(identifier: "en_US_POSIX")
        utcFormatter.timeZone = TimeZone(abbreviation: "GMT")
        utcFormatter.dateFormat = detailFormat
        let date = utcFormatter.date(from: timeString)
        let localFormatter = DateFormatter()
        localFormatter.dateFormat = dateFormat
        let localTimeString = localFormatter.string(from: date!)
        return localTimeString
    }
    static func getTimeralWithUTCString(UTCtimeString: String) -> Int {
        let arr = UTCtimeString.components(separatedBy: ".")
        let utcFormatter = DateFormatter()
        utcFormatter.locale = Locale(identifier: "en_US_POSIX")
        utcFormatter.timeZone = TimeZone(abbreviation: "GMT")
        utcFormatter.dateFormat = detailFormat
        let date = utcFormatter.date(from: arr[0])
        let timeral = date?.timeIntervalSinceNow
        return Int(-timeral!)
    }
    static func getUTCEnableTimeWithNow() -> String {
        let date = Date()
        let utcFormatter = DateFormatter()
        utcFormatter.locale = Locale(identifier: "en_US_POSIX")
        utcFormatter.timeZone = TimeZone(abbreviation: "GMT")
        utcFormatter.dateFormat = detailFormat
        return utcFormatter.string(from: date).appending(".000Z")
    }
    static func getUtcString(with dateString: String) -> String {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        guard let date = dateformatter.date(from: dateString)
        else { return "" }
        let utcFormatter = DateFormatter()
        utcFormatter.locale = Locale(identifier: "en_US_POSIX")
        utcFormatter.timeZone = TimeZone(abbreviation: "GMT")
        utcFormatter.dateFormat = detailFormat
        return utcFormatter.string(from: date).appending(".000Z")
    }
    static func getTodayTimeralWithString(timeString: String) ->Int {
        let dateNow = Date()
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy-MM-dd"
        dateformatter.timeZone = NSTimeZone.local
        dateformatter.locale = Locale(identifier: "zh_CN")
        let timeNow = dateformatter.string(from: dateNow)
        let restTime = timeNow+" \(timeString):00"
        dateformatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let restDate = dateformatter.date(from: restTime) ?? Date()
        let timeral = restDate.timeIntervalSinceNow
        return Int(timeral)
    }
    private static func regexGetSub(pattern:String, str:String) -> [String] {
        var subStr = [String]()
        let regex = try? NSRegularExpression(pattern: pattern, options:[])
        guard let matches = regex?.matches(in: str, options: [], range: NSRange(str.startIndex...,in: str)) else { return subStr }
        for match in matches{
            if let matchRange = Range.init(match.range(at: 1), in: str){
                let matchStr: String = String.init(str[matchRange])
                subStr.append(matchStr)
            }
        }
        return subStr
    }
    static func getQuotationMarksString(str: String) -> [String]{
        var finalString = str.replacingOccurrences(of: "“", with: "\"")
        finalString = finalString.replacingOccurrences(of: "”", with: "\"")
        let pattern = "\"(.*?)\""
        return String.ss.regexGetSub(pattern: pattern, str: finalString)
    }
    private static func validationExpression(pattern:String,checkString:String) -> Bool{
        let regex = try? NSRegularExpression(pattern: pattern, options: [])
        let results = regex?.matches(in: checkString, options: [], range: NSRange(location: 0, length: checkString.count))
        if (results?.count ?? 0) > 0{
            return true
        }else{
            return false
        }
    }
    func hexTodec() -> String {
        let str = base.uppercased()
        var sum = 0
        for i in str.utf8 {
            sum = sum * 16 + Int(i) - 48 
            if i >= 65 {                 
                sum -= 7
            }
        }
        return "\(sum)"
    }
    static func trasformToHexVersion(versionNum: Int) -> String {
        if versionNum == -1 || versionNum == 0 {
            return ""
        }
        var versionString = String(versionNum, radix: 16)
        versionString.insert(".", at: versionString.index(versionString.startIndex, offsetBy: 1))
        return versionString
    }
    func spaceNewLineString() -> String {
        let string = (base as String)
        return string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
}