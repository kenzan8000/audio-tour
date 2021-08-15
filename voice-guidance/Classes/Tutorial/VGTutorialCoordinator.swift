import RxSwift
import UIKit

// MARK: - VGTutorialCoordinator
class VGTutorialCoordinator: VGBaseCoordinator<Void> {

  // MARK: property
  
  private let rootViewController: UIViewController
  private let tutorialViewControllerFactory: VGTutorialViewControllerFactory
  private var tutorialViewController: VGTutorialViewController?

  // MARK: initializer
  
  /// Inits
  /// - Parameters:
  ///   - rootViewController: UIViewController
  ///   - tutorialViewControllerFactory: VGTutorialViewControllerFactory
  init(rootViewController: UIViewController, tutorialViewControllerFactory: @escaping VGTutorialViewControllerFactory) {
    self.rootViewController = rootViewController
    self.tutorialViewControllerFactory = tutorialViewControllerFactory
  }
  
  // MARK: deinit
  
  deinit {
    tutorialViewController = nil
  }

  // MARK: VGCoordinator
  
  override func start() -> Observable<Void> {
    rootViewController.children.forEach { [weak self] in
      self?.rootViewController.remove(childViewController: $0)
    }
    let tutorialViewController = tutorialViewControllerFactory()
    rootViewController.addFullScreen(childViewController: tutorialViewController)
    tutorialViewController.viewModel
      .slideEvent
      .subscribe { [weak self] event in
        guard let self = self, let slide = event.element else {
          return
        }
        self.presentSlide(slide)
      }
      .disposed(by: disposeBag)
    tutorialViewController.presentSlideView(.intro)
    self.tutorialViewController = tutorialViewController
    return Observable.never()
  }
  
  func presentSlide(_ slide: VGTutorialSlide) {
    switch slide {
    case .intro:
      tutorialViewController?.presentSlideView(.intro)
    case .map:
      tutorialViewController?.presentSlideView(.map)
    case .ar:
      tutorialViewController?.presentSlideView(.ar)
    case .last:
      tutorialViewController?.presentSlideView(.last)
    case .end:
      NotificationCenter.default.post(name: .startMain, object: nil)
    }
  }
}
