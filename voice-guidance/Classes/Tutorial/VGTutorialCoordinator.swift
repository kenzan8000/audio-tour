import RxSwift
import UIKit

// MARK: - VGTutorialCoordinator
class VGTutorialCoordinator: VGBaseCoordinator<Void> {

  // MARK: property
  
  private let rootViewController: UIViewController
  private let tutorialViewControllerFactory: VGTutorialViewControllerFactory

  // MARK: initializer
  
  /// Inits
  /// - Parameters:
  ///   - rootViewController: UIViewController
  ///   - tutorialViewControllerFactory: VGTutorialViewControllerFactory
  init(rootViewController: UIViewController, tutorialViewControllerFactory: @escaping VGTutorialViewControllerFactory) {
    self.rootViewController = rootViewController
    self.tutorialViewControllerFactory = tutorialViewControllerFactory
  }

  // MARK: VGCoordinator
  
  override func start() -> Observable<Void> {
    rootViewController.children.forEach { [weak self] in
      self?.rootViewController.remove(childViewController: $0)
    }
    rootViewController.addFullScreen(childViewController: tutorialViewControllerFactory())
    return Observable.never()
  }
}
