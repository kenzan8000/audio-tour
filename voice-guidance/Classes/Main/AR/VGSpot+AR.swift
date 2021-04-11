import UIKit

// MARK: - VGSpot + AR
extension VGSpot {
  
  // MARK: static constant
  
  private static let arColors = [
    UIColor(red: 231.0 / 255.0, green: 76.0 / 255.0, blue: 60.0 / 255.0, alpha: 1.0),
    UIColor(red: 236.0 / 255.0, green: 240.0 / 255.0, blue: 241.0 / 255.0, alpha: 1.0),
    UIColor(red: 230.0 / 255.0, green: 126.0 / 255.0, blue: 34.0 / 255.0, alpha: 1.0),
    UIColor(red: 241.0 / 255.0, green: 196.0 / 255.0, blue: 15.0 / 255.0, alpha: 1.0),
    UIColor(red: 52.0 / 255.0, green: 73.0 / 255.0, blue: 94.0 / 255.0, alpha: 1.0),
    UIColor(red: 155.0 / 255.0, green: 89.0 / 255.0, blue: 182.0 / 255.0, alpha: 1.0),
    UIColor(red: 52.0 / 255.0, green: 152.0 / 255.0, blue: 219.0 / 255.0, alpha: 1.0),
    UIColor(red: 46.0 / 255.0, green: 204.0 / 255.0, blue: 113.0 / 255.0, alpha: 1.0),
    UIColor(red: 26.0 / 255.0, green: 188.0 / 255.0, blue: 156.0 / 255.0, alpha: 1.0),
  ]
  
  // MARK: property
  
  var arColor: UIColor {
    VGSpot.arColors[(imageId / 100) % VGSpot.arColors.count]
  }
  
  var arImage: UIImage? {
    guard let iconImage = image?.tint(color: .white) else {
      return nil
    }
    guard let bubbleBackImage = UIImage(named: "ar_bubble_back.png")?.tint(color: UIColor.white.withAlphaComponent(0.8)) else {
      return nil
    }
    guard let bubbleFrontImage = UIImage(named: "ar_bubble_front.png")?.tint(color: arColor) else {
      return nil
    }
    let size = CGSize(width: bubbleBackImage.size.width, height: bubbleBackImage.size.height)
    UIGraphicsBeginImageContextWithOptions(size, false, CGFloat(bubbleBackImage.scale))
    bubbleBackImage.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
    bubbleFrontImage.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
    iconImage.draw(
      in: CGRect(x: (size.width - iconImage.size.width) / 2.0, y: 18.0, width: iconImage.size.width, height: iconImage.size.height),
      blendMode: CGBlendMode.normal,
      alpha: CGFloat(1.0)
    )
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return newImage
  }
}
