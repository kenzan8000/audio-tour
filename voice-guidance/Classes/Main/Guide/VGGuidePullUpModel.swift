import UIKit

// MARK: - VGGuidePullUpModel
class VGGuidePullUpModel: ObservableObject {
  
  // MARK: constant
  
  let bottomY = CGFloat(0.0)
  let middleY = CGFloat(84.0)
  var peekY: CGFloat
  var bottomSafeAreaInset: CGFloat
  
  // MARK: property

  var pullUpControllerMiddleStickyPoints: [CGFloat] {
    [bottomY, middleY + bottomSafeAreaInset, peekY]
  }
  var pullUpControllerPreferredSize: CGSize {
    CGSize(width: UIScreen.main.bounds.width, height: peekY)
  }
  
  // MARK: initializer
  
  /// Inits
  /// - Parameters:
  ///   - bottomSafeAreaInset: CGFloat
  ///   - peekY: CGFloat
  init(bottomSafeAreaInset: CGFloat, peekY: CGFloat) {
    self.peekY = peekY
    self.bottomSafeAreaInset = bottomSafeAreaInset
  }
}
