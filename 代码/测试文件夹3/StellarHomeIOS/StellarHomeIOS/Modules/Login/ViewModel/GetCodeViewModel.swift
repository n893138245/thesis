import UIKit
enum ValidateFailReason{
    case emptyInput
    case other(String)
}
enum ValidateResult {
    case ok
    case failed(ValidateFailReason)
    var isOk: Bool {
        if case ValidateResult.ok = self {
            return true
        }else{
            return false
        }
    }
}
class GetCodeViewModel: NSObject {
    struct Input {
        let userPhoneNum: Observable<(String,String)>
        let sendCodeTap: Observable<Void>
    }
    struct Output {
        var userPhoneValidateResult: Observable<ValidateResult>!
        var sendCodeResult: Observable<Bool>!
    }
    var output: Output
    init(input: Input) {
        output = Output()
        output.userPhoneValidateResult = input.userPhoneNum
            .flatMapLatest { (userPhoneNum,region) -> Observable<ValidateResult> in
                return ValidateService.validateChinesePhoneNum(inputString: userPhoneNum)
        }
        .share(replay: 1)
    }
}