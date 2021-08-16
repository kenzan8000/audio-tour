import RxSwift
import UIKit

// MARK: - VGTutorialSlide
enum VGTutorialSlide: Int {
  case intro = 0
  case map = 1
  case ar = 2
  case last = 3
  case end = 4
  
  var currentPage: Int { rawValue }
  
  var next: VGTutorialSlide {
    switch self {
    case .intro:
      return .map
    case .map:
      return .ar
    case .ar:
      return .last
    case .last:
      return .end
    default:
      return .end
    }
  }
}

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
    tutorialViewController.presentSlideView(.init(viewModel: .intro))
    self.tutorialViewController = tutorialViewController
    return Observable.never()
  }
  
  func presentSlide(_ slide: VGTutorialSlide) {
    switch slide {
    case .intro:
      tutorialViewController?.presentSlideView(.init(viewModel: .intro))
    case .map:
      tutorialViewController?.presentSlideView(.init(viewModel: .map))
    case .ar:
      tutorialViewController?.presentSlideView(.init(viewModel: .ar))
    case .last:
      tutorialViewController?.presentSlideView(.init(viewModel: .last))
    case .end:
      NotificationCenter.default.post(name: .startMain, object: nil)
    }
  }
}
