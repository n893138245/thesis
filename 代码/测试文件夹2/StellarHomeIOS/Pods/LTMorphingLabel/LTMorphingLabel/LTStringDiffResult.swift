import Foundation
public typealias LTStringDiffResult = ([LTCharacterDiffResult], skipDrawingResults: [Bool])
public extension String {
    func diffWith(_ anotherString: String?) -> LTStringDiffResult {
        guard let anotherString = anotherString else {
            let diffResults: [LTCharacterDiffResult] =
                Array(repeating: .delete, count: self.count)
            let skipDrawingResults: [Bool] = Array(repeating: false, count: self.count)
            return (diffResults, skipDrawingResults)
        }
        let newChars = anotherString.enumerated()
        let lhsLength = self.count
        let rhsLength = anotherString.count
        var skipIndexes = [Int]()
        let leftChars = Array(self)
        let maxLength = max(lhsLength, rhsLength)
        var diffResults: [LTCharacterDiffResult] = Array(repeating: .add, count: maxLength) 
        var skipDrawingResults: [Bool] = Array(repeating: false, count: maxLength)
        for i in 0..<maxLength {
            if i > lhsLength - 1 {
                continue
            }
            let leftChar = leftChars[i]
            var foundCharacterInRhs = false
            for (j, newChar) in newChars {
                if skipIndexes.contains(j) || leftChar != newChar {
                    continue
                }
                skipIndexes.append(j)
                foundCharacterInRhs = true
                if i == j {
                    diffResults[i] = .same
                } else {
                    let offset = j - i
                    if i <= rhsLength - 1 {
                        diffResults[i] = .moveAndAdd(offset: offset)
                    } else {
                        diffResults[i] = .move(offset: offset)
                    }
                    skipDrawingResults[j] = true
                }
                break
            }
            if !foundCharacterInRhs {
                if i < rhsLength - 1 {
                    diffResults[i] = .replace
                } else {
                    diffResults[i] = .delete
                }
            }
        }
        return (diffResults, skipDrawingResults)
    }
}