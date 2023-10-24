import UIKit
import RxSwift
class ValidateService {
    static func validateUserPhoneNum(userPhoneNum : String ,region : String) -> Observable<ValidateResult>{
        return Observable<ValidateResult>.create { (anyObserver) -> Disposable in
            if userPhoneNum.isEmpty{
                anyObserver.onNext(.failed(.emptyInput))
                anyObserver.onCompleted()
                return Disposables.create()
            }
            var regionString = ""
            if region.isEmpty{
                regionString = "CN"
            }else{
                regionString = region
            }
            var result = false
            do {
                let phoneUtil = NBPhoneNumberUtil.sharedInstance()
                let phoneNumber: NBPhoneNumber = try phoneUtil?.parse(userPhoneNum, defaultRegion: regionString) ?? NBPhoneNumber()
                result = phoneUtil?.isValidNumber(phoneNumber) ?? false
                if result{
                    anyObserver.onNext(.ok)
                    anyObserver.onCompleted()
                    return Disposables.create()
                }else{
                    anyObserver.onNext(.failed(.other(StellarLocalizedString("VALIDATEFAILED_PHONENUM"))))
                    return Disposables.create()
                }
            }
            catch _ {
                anyObserver.onNext(.failed(.other(StellarLocalizedString("VALIDATEFAILED_PHONENUM"))))
                return Disposables.create()
            }
        }
    }
    static func validatePasssword(text: String) -> Observable<ValidateResult>{
        return Observable<ValidateResult>.create { (anyObserver) -> Disposable in
            if text.isEmpty{
                anyObserver.onNext(.failed(.emptyInput))
                anyObserver.onCompleted()
                return Disposables.create()
            }
            let predicateString = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z_\\d$@$!%*#?&]{6,32}$"
            let predicate = NSPredicate(format: "SELF MATCHES %@", predicateString)
            let isCurrect = predicate.evaluate(with: text)
            if !isCurrect{
                anyObserver.onNext(.failed(.other("6-32位，必须包含一个字母和一个数字，支持特殊字符_@$!%*#?&")))
                return Disposables.create()
            }
            anyObserver.onNext(.ok)
            anyObserver.onCompleted()
            return Disposables.create()
        }
    }
    static func validateEmail(text: String) -> Observable<ValidateResult>{
        return Observable<ValidateResult>.create { (anyObserver) -> Disposable in
            if text.isEmpty{
                anyObserver.onNext(.failed(.emptyInput))
                anyObserver.onCompleted()
                return Disposables.create()
            }
            let predicateString = "(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
            let predicate = NSPredicate(format: "SELF MATCHES %@", predicateString)
            let isCurrect = predicate.evaluate(with: text)
            if !isCurrect{
                anyObserver.onNext(.failed(.other("请输入正确的邮箱")))
                return Disposables.create()
            }
            anyObserver.onNext(.ok)
            anyObserver.onCompleted()
            return Disposables.create()
        }
    }
    static func validateCode(inputString: String) -> Observable<ValidateResult>{
        return Observable<ValidateResult>.create { (anyObserver) -> Disposable in
            if inputString.isEmpty{
                anyObserver.onNext(.failed(.emptyInput))
                anyObserver.onCompleted()
                return Disposables.create()
            }
            let numString = "[0-9]*"
            let predicate = NSPredicate(format: "SELF MATCHES %@", numString)
            let isNumber = predicate.evaluate(with: inputString)
            if !isNumber{
                anyObserver.onNext(.failed(.other("必须是数字")))
                return Disposables.create()
            }
            if inputString.count != 4{
                anyObserver.onNext(.failed(.other("必须是4位数字")))
                return Disposables.create()
            }
            anyObserver.onNext(.ok)
            anyObserver.onCompleted()
            return Disposables.create()
        }
    }
    static func validateChinese(inputString: String, isVoiceControl: Bool = true) -> Observable<ValidateResult>{
        return Observable<ValidateResult>.create { (anyObserver) -> Disposable in
            if inputString.isEmpty{
                anyObserver.onNext(.failed(.emptyInput))
                anyObserver.onCompleted()
                return Disposables.create()
            }
            var predicateString = "^[\\u4e00-\\u9fa5]{2,6}$"
            var tipMessage = "必须是2~6位中文"
            if !isVoiceControl {
                predicateString = "[^\\[\\]`~!#$^&()=|{}':;',?~！#￥……&（）——|{}【】‘；：”“'。，、？.<>/]{1,32}$"
                tipMessage = "1~32位，不支持符号：`~!#$^&()=|{}':;',[].<>/?￥……——【】‘；：”“'。，、"
            }
            let predicate = NSPredicate(format: "SELF MATCHES %@", predicateString)
            let isCurrect = predicate.evaluate(with: inputString)
            if !isCurrect{
                anyObserver.onNext(.failed(.other(tipMessage)))
                return Disposables.create()
            }
            anyObserver.onNext(.ok)
            anyObserver.onCompleted()
            return Disposables.create()
        }
    }
    static func validateChinesePhoneNum(inputString: String) -> Observable<ValidateResult>{
        return Observable<ValidateResult>.create { (anyObserver) -> Disposable in
            if inputString.isEmpty{
                anyObserver.onNext(.failed(.emptyInput))
                anyObserver.onCompleted()
                return Disposables.create()
            }
            let numString = "^1[0-9]{10}$"
            let predicate = NSPredicate(format: "SELF MATCHES %@", numString)
            let isNumber = predicate.evaluate(with: inputString)
            if !isNumber{
                anyObserver.onNext(.failed(.other(StellarLocalizedString("VALIDATEFAILED_PHONENUM"))))
                return Disposables.create()
            }
            anyObserver.onNext(.ok)
            anyObserver.onCompleted()
            return Disposables.create()
        }
    }
}