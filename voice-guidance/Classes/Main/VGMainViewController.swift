import UIKit

// MARK: - VGMainViewController
class VGMainViewController: UITabBarController {
  
  // MARK: initializer
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  /// Inits
  /// - Parameter viewControllers: viewControllers stored in the tabs
  init(viewControllers: [VGTabViewController]) {
    super.init(nibName: nil, bundle: nil)
    self.viewControllers = viewControllers
    updateTabs()
  }

  // MARK: private api
  
  /// Updates tab's images and titles
  private func updateTabs() {
    guard let tabBarItems = tabBar.items, let tabViewControllers = viewControllers as? [VGTabViewController] else {
      return
    }
    zip(tabBarItems, tabViewControllers).forEach { item, tabViewController in
      item.image = tabViewController.tabBarImage
      item.title = tabViewController.tabBarTitle
    }
  }
}

// MARK: - VGMainViewControllerFactory
typealias VGMainViewControllerFactory = () -> VGMainViewController
