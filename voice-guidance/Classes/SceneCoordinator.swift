import RxSwift
import UIKit

// MARK: - SceneCoordinator
class SceneCoordinator: VGBaseCoordinator<Void> {

  // MARK: property
  
  private let window: UIWindow
  private let userDefaults: VGUserDefaults
  private let storageProvider: VGStorageProvider

  // MARK: initializer
  
  /// Inits
  /// - Parameters:
  ///   - window: UIWIndow
  ///   - userDefaults: VGUserDefaults
  ///   - storageProvider: VGStorageProvider
  init(window: UIWindow, userDefaults: VGUserDefaults, storageProvider: VGStorageProvider) {
    self.window = window
    self.userDefaults = userDefaults
    self.storageProvider = storageProvider
  }

  // MARK: VGCoordinator
  
  override func start() -> Observable<Void> {
    let coordinator = VGRootCoordinator(window: window, userDefaults: userDefaults, storageProvider: storageProvider)
    return coordinate(to: coordinator)
  }
}
