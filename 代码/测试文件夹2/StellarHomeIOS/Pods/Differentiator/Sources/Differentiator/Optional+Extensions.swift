import Foundation
extension Optional {
    func unwrap() throws -> Wrapped {
        if let unwrapped = self {
            return unwrapped
        }
        else {
            debugFatalError("Error during unwrapping optional")
            throw DifferentiatorError.unwrappingOptional
        }
   }
}