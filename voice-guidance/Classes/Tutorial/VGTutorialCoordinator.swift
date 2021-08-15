import RxSwift
import UIKit

// MARK: - VGTutorialCoordinator
class VGTutorialCoordinator: VGBaseCoordinator<Void> {

  // MARK: property
  
  private let rootViewController: UIViewController
  private let tutorialViewControllerFactory: VGTutorialViewControllerFactory
  private var tutorialViewController: VGTutorialViewController?
  private var slideView: VGTutorialSlideView = .intro {
    didSet {
      oldValue.removeFromSuperview()
      tutorialViewController?.slideBackgroundView.addSubview(slideView)
      slideView.frame = tutorialViewController?.slideBackgroundView.bounds ?? .zero
    }
  }

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
    slideView.removeFromSuperview()
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
      .tutorialEvent
      .subscribe { [weak self] event in
        guard let self = self, let slide = event.element else {
          return
        }
        self.presentSlide(slide)
      }
      .disposed(by: disposeBag)
    self.tutorialViewController = tutorialViewController
    slideView = .intro
    return Observable.never()
  }
  
  func presentSlide(_ slide: VGTutorialSlide) {
    switch slide {
    case .intro:
      self.slideView = .intro
    case .map:
      self.slideView = .map
    case .ar:
      self.slideView = .ar
    case .last:
      self.slideView = .last
    case .end:
      NotificationCenter.default.post(name: .startMain, object: nil)
    }
  }
}
