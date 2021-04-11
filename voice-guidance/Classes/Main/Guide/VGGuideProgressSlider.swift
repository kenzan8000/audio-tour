import UIKit

// MARK: - VGGuideProgressSlider
class VGGuideProgressSlider: UISlider {
  // MARK: property
  var progress = Float(0.0)

  // MARK: initializer
  override func awakeFromNib() {
    super.awakeFromNib()
    self.isContinuous = true
    self.setThumbImage(
      UIImage(named: "guide_sliderthumb.png")?.tint(color: .systemBlue),
      for: .normal
    )
  }

  // MARK: public api
  /// set progress
  ///
  /// - Parameters:
  ///   - progress: Float value representing current progress 0.0~1.0
  ///   - animated: if animated
  func setProgress(_ progress: Float, animated: Bool) {
    self.progress = progress
    self.setProgress(self.progress, duration: 2.0, animated: animated)
  }
  
  /// pause
  func pause() {
    self.setProgress(self.progress, duration: 0.5, animated: true)
  }
  
  /// set progress
  ///
  /// - Parameters:
  ///   - progress: Float value representing current progress 0.0~1.0
  ///   - duration: animation duration
  ///   - animated: if animated
  func setProgress(_ progress: Float, duration: TimeInterval, animated: Bool) {
    self.layer.removeAllAnimations()
    if animated && abs(progress - self.value) < 0.2 {
      UIView.animate(withDuration: duration) { [weak self] in self?.setValue(progress, animated: animated) }
    } else {
      self.setValue(progress, animated: false)
    }
  }
}
