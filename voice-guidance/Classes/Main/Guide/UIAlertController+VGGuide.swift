import CoreLocation
import RxSwift
import UIKit

// MARK: - UIAlertController + Guide
extension UIAlertController {
  
  // MARK: static methods
  
  /// Returns alert controller for voice guide
  /// - Parameters:
  ///   - title: title of alert
  ///   - message: message of alert
  ///   - preferredStyle: preferredStyle of alert
  ///   - coordinate: spot's coordinate
  /// - Returns: alert controller for voice guide
  static func guideOpenInMap(
    title: String?,
    message: String?,
    preferredStyle: UIAlertController.Style,
    coordinate: CLLocationCoordinate2D
  ) -> UIAlertController {
    let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
    alert.addAction(
      UIAlertAction(
        title: NSLocalizedString("guide_actionsheet_1", comment: ""),
        style: .default
      ) { _ in
        if let url = URL(string: "http://maps.apple.com/?daddr=\(coordinate.latitude),\(coordinate.longitude)") {
          UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
      }
    )
    alert.addAction(
      UIAlertAction(
        title: NSLocalizedString("guide_actionsheet_2", comment: ""),
        style: .default
      ) { _ in
        if let url = URL(string: "https://maps.google.com/?daddr=\(coordinate.latitude),\(coordinate.longitude)") {
          UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
      }
    )
    alert.addAction(
      UIAlertAction(
        title: NSLocalizedString("guide_actionsheet_3", comment: ""),
        style: .cancel
      ) { _ in }
    )
    return alert
  }
  
}
