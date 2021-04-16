import Foundation
import UIKit

// MARK: - VGMapZoomButton
class VGMapZoomButton: VGCircleButton {
  
  // MARK: enum
  
  enum ZoomType {
    case zoomIn
    case zoomOut
  }
  
  // MARK: property
  
  var zoomType: ZoomType
  
  // MARK: initializer
  
  /// Inits
  /// - Parameter zoomType:  zoomIn or zoomOut
  init(zoomType: ZoomType) {
    var image: UIImage?
    switch zoomType {
    case .zoomIn:
      image = UIImage(
        systemName: "plus",
        withConfiguration: UIImage.SymbolConfiguration(weight: .bold)
      )?
      .withRenderingMode(.alwaysTemplate)
      .tint(color: .label)
    case .zoomOut:
      image = UIImage(
        systemName: "minus",
        withConfiguration: UIImage.SymbolConfiguration(weight: .bold)
      )?
      .withRenderingMode(.alwaysTemplate)
      .tint(color: .label)
    }
    self.zoomType = zoomType
    super.init(image: image)
  }
  
  // MARK: life cycle
  
  override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    super.traitCollectionDidChange(previousTraitCollection)
    changeTraitCollection()
  }
  
  // MARK: public api
  
  /// Calls when changing UITraitCollection
  func changeTraitCollection() {
    var image: UIImage?
    switch zoomType {
    case .zoomIn:
      image = UIImage(
        systemName: "plus",
        withConfiguration: UIImage.SymbolConfiguration(weight: .bold)
      )?
      .withRenderingMode(.alwaysTemplate)
      .tint(color: .label)
    case .zoomOut:
      image = UIImage(
        systemName: "minus",
        withConfiguration: UIImage.SymbolConfiguration(weight: .bold)
      )?
      .withRenderingMode(.alwaysTemplate)
      .tint(color: .label)
    }
    button.setImage(image, for: .normal)
  }
  
}
