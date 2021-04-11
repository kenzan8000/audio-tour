import UIKit

// MARK: - VGTabViewControllerProtocol
protocol VGTabViewControllerProtocol {
  // MARK: property
  var tabBarImage: UIImage? { get }
  var tabBarTitle: String? { get }
}

// MARK: - VGTabViewController
class VGTabViewController: UIViewController, VGTabViewControllerProtocol {
  // MARK: property
  var tabBarImage: UIImage? { nil }
  var tabBarTitle: String? { nil }
}
