import UIKit

// MARK: - VGMainViewController
class VGMainViewController: UITabBarController {

  // MARK: properties
  
  private var tabViewControllers: [VGTabViewController]
  
  // MARK: initializer
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  /// Inits
  /// - Parameter viewControllers: viewControllers stored in the tabs
  init(viewControllers: [VGTabViewController]) {
    tabViewControllers = viewControllers
    super.init(nibName: nil, bundle: nil)
    self.viewControllers = viewControllers
    updateTabs()
  }
  
  // MARK: life cycle

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  // MARK: private api
  
  /// Updates tab's images and titles
  private func updateTabs() {
    guard let tabBarItems = tabBar.items else {
      return
    }
    for (i, item) in tabBarItems.enumerated() {
      item.image = tabViewControllers[i].tabBarImage
      item.title = tabViewControllers[i].tabBarTitle
    }
  }
}

// MARK: - VGMainViewControllerFactory
typealias VGMainViewControllerFactory = () -> VGMainViewController
