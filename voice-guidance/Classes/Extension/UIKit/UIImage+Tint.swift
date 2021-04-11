import UIKit

// MARK: - UIImage+Tint
extension UIImage {
  
  /// Returns a UIImage with a color
  ///
  /// - Parameter color: color of image you are going ot generate
  /// - Returns:a UIImage with a color
  func tint(color: UIColor) -> UIImage? {
    UIGraphicsBeginImageContextWithOptions(size, false, 0)
    color.setFill()
    let drawRect = CGRect(
      x: 0,
      y: 0,
      width: size.width,
      height: size.height
    )
    UIRectFill(drawRect)
    draw(in: drawRect, blendMode: .destinationIn, alpha: 1)
    let tintedImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return tintedImage
  }
}
