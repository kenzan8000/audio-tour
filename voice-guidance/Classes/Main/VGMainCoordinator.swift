import RxSwift
import UIKit

// MARK: - VGMainTab
enum VGMainTab {
  case map
  case ar
}

// MARK: - VGMainCoordinator
class VGMainCoordinator: VGBaseCoordinator<Void> {

  // MARK: property
  
  private let rootViewController: UIViewController
  private let mainViewControllerFactory: VGMainViewControllerFactory

  // MARK: initializer
  
  /// Inits
  /// - Parameters:
  ///   - rootViewController: UIViewController
  ///   - mainViewControllerFactory: VGMainViewControllerFactory
  init(rootViewController: UIViewController, mainViewControllerFactory: @escaping VGMainViewControllerFactory) {
    self.rootViewController = rootViewController
    self.mainViewControllerFactory = mainViewControllerFactory
  }

  // MARK: VGCoordinator
  
  override func start() -> Observable<Void> {
    rootViewController.children.forEach { [weak self] in
      self?.rootViewController.remove(childViewController: $0)
    }
    let mainViewController = mainViewControllerFactory()
    rootViewController.addFullScreen(childViewController: mainViewController)
    return Observable.never()
  }
}
