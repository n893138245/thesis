import UIKit
extension LTMorphingLabel {
    @objc
    func PixelateLoad() {
        effectClosures["Pixelate\(LTMorphingPhases.disappear)"] = {
            char, index, progress in
            return LTCharacterLimbo(
                char: char,
                rect: self.previousRects[index],
                alpha: CGFloat(1.0 - progress),
                size: self.font.pointSize,
                drawingProgress: CGFloat(progress))
        }
        effectClosures["Pixelate\(LTMorphingPhases.appear)"] = {
            char, index, progress in
            return LTCharacterLimbo(
                char: char,
                rect: self.newRects[index],
                alpha: CGFloat(progress),
                size: self.font.pointSize,
                drawingProgress: CGFloat(1.0 - progress)
            )
        }
        drawingClosures["Pixelate\(LTMorphingPhases.draw)"] = {
            limbo in
            if limbo.drawingProgress > 0.0 {
                let charImage = self.pixelateImageForCharLimbo(
                    limbo,
                    withBlurRadius: limbo.drawingProgress * 6.0
                )
                charImage.draw(in: limbo.rect)
                return true
            }
            return false
        }
    }
    fileprivate func pixelateImageForCharLimbo(
        _ charLimbo: LTCharacterLimbo,
        withBlurRadius blurRadius: CGFloat
        ) -> UIImage {
            let scale = min(UIScreen.main.scale, 1.0 / blurRadius)
            UIGraphicsBeginImageContextWithOptions(charLimbo.rect.size, false, scale)
            let fadeOutAlpha = min(1.0, max(0.0, charLimbo.drawingProgress * -2.0 + 2.0 + 0.01))
            let rect = CGRect(
                x: 0,
                y: 0,
                width: charLimbo.rect.size.width,
                height: charLimbo.rect.size.height
            )
            String(charLimbo.char).draw(in: rect, withAttributes: [
                .font: self.font as Any,
                .foregroundColor: self.textColor.withAlphaComponent(fadeOutAlpha)
            ])
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return newImage!
    }
}