// import CoreLocation
import RxSwift
import UIKit

// MARK: - VGRootCoordinator
class VGRootCoordinator: VGBaseCoordinator<Void> {

  // MARK: property
  
  private let window: UIWindow
  private let userDefaults: VGUserDefaults
  private let storageProvider: VGStorageProvider
  private let tutorialViewControllerFactory: VGTutorialViewControllerFactory
  private let mainViewControllerFactory: VGMainViewControllerFactory

  // MARK: initializer
  
  /// Inits
  /// - Parameters:
  ///   - window: UIWIndow
  ///   - userDefaults: VGUserDefaults
  ///   - storageProvider: VGStorageProvider
  ///   - tutorialViewControllerFactory: tutorialViewControllerFactory
  ///   - mainViewControllerFactory: mainViewControllerFactory
  init(
    window: UIWindow,
    userDefaults: VGUserDefaults,
    storageProvider: VGStorageProvider,
    tutorialViewControllerFactory: @escaping VGTutorialViewControllerFactory,
    mainViewControllerFactory: @escaping VGMainViewControllerFactory
  ) {
    self.window = window
    self.userDefaults = userDefaults
    self.storageProvider = storageProvider
    self.tutorialViewControllerFactory = tutorialViewControllerFactory
    self.mainViewControllerFactory = mainViewControllerFactory
  }

  // MARK: VGCoordinator
  
  override func start() -> Observable<Void> {
    let viewModel = VGRootViewModel(userDefaults: userDefaults)
    window.rootViewController = VGRootViewController(viewModel: viewModel)
    viewModel.viewSubject
      .subscribe { [weak self] event in
        guard let self = self, let view = event.element else {
          return
        }
        switch view {
        case .main:
          self.presentMain()
        case .tutorial:
          self.presentTutorial()
        }
      }
      .disposed(by: disposeBag)
    window.makeKeyAndVisible()
    return Observable.never()
  }
  
  // MARK: private api
  
  /// Presents tutorial root view
  private func presentTutorial() {
    guard let rootViewController = window.rootViewController else {
      return
    }
    let coordinator = VGTutorialCoordinator(
      rootViewController: rootViewController,
      tutorialViewControllerFactory: tutorialViewControllerFactory
    )
    _ = coordinate(to: coordinator)
  }
  
  /// Presents main root view
  private func presentMain() {
    window.rootViewController?.children.forEach { [weak self] in
      self?.window.rootViewController?.remove(childViewController: $0)
    }
    window.rootViewController?.addFullScreen(childViewController: mainViewControllerFactory())
  }
}
