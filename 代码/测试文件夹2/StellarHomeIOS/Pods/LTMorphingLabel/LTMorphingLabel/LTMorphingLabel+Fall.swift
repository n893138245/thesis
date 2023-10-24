import UIKit
extension LTMorphingLabel {
    @objc
    func FallLoad() {
        progressClosures["Fall\(LTMorphingPhases.progress)"] = {
            (index: Int, progress: Float, isNewChar: Bool) in
            if isNewChar {
                return min(
                    1.0,
                    max(
                        0.0,
                        progress
                            - self.morphingCharacterDelay
                            * Float(index)
                            / 1.7
                    )
                )
            }
            let j: Float = Float(sin(Double(index))) * 1.7
            return min(1.0, max(0.0001, progress + self.morphingCharacterDelay * Float(j)))
        }
        effectClosures["Fall\(LTMorphingPhases.disappear)"] = {
            char, index, progress in
            return LTCharacterLimbo(
                char: char,
                rect: self.previousRects[index],
                alpha: CGFloat(1.0 - progress),
                size: self.font.pointSize,
                drawingProgress: CGFloat(progress))
        }
        effectClosures["Fall\(LTMorphingPhases.appear)"] = {
            char, index, progress in
            let currentFontSize = CGFloat(
                LTEasing.easeOutQuint(progress, 0.0, Float(self.font.pointSize))
            )
            let yOffset = CGFloat(self.font.pointSize - currentFontSize)
            return LTCharacterLimbo(
                char: char,
                rect: self.newRects[index].offsetBy(dx: 0, dy: yOffset),
                alpha: CGFloat(self.morphingProgress),
                size: currentFontSize,
                drawingProgress: 0.0
            )
        }
        drawingClosures["Fall\(LTMorphingPhases.draw)"] = {
            limbo in
            if limbo.drawingProgress > 0.0 {
                let context = UIGraphicsGetCurrentContext()
                var charRect = limbo.rect
                context!.saveGState()
                let charCenterX = charRect.origin.x + (charRect.size.width / 2.0)
                var charBottomY = charRect.origin.y + charRect.size.height - self.font.pointSize / 6
                var charColor: UIColor = self.textColor
                if limbo.drawingProgress > 0.5 {
                    let ease = CGFloat(
                        LTEasing.easeInQuint(
                            Float(limbo.drawingProgress - 0.4),
                            0.0,
                            1.0,
                            0.5
                        )
                    )
                    charBottomY += ease * 10.0
                    let fadeOutAlpha = min(
                        1.0,
                        max(
                            0.0,
                            limbo.drawingProgress * -2.0 + 2.0 + 0.01
                        )
                    )
                    charColor = self.textColor.withAlphaComponent(fadeOutAlpha)
                }
                charRect = CGRect(
                    x: charRect.size.width / -2.0,
                    y: charRect.size.height * -1.0 + self.font.pointSize / 6,
                    width: charRect.size.width,
                    height: charRect.size.height)
                context!.translateBy(x: charCenterX, y: charBottomY)
                let angle = Float(sin(Double(limbo.rect.origin.x)) > 0.5 ? 168 : -168)
                let rotation = CGFloat(
                    LTEasing.easeOutBack(
                        min(
                            1.0,
                            Float(limbo.drawingProgress)
                        ),
                        0.0,
                        1.0
                    ) * angle
                )
                context!.rotate(by: rotation * CGFloat(Double.pi) / 180.0)
                let s = String(limbo.char)
                let attributes: [NSAttributedString.Key: Any] = [
                    .font: self.font.withSize(limbo.size),
                    .foregroundColor: charColor
                ]
                s.draw(in: charRect, withAttributes: attributes)
                context!.restoreGState()
                return true
            }
            return false
        }
    }
}