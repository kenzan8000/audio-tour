import RxSwift
import UIKit

// MARK: - SceneDelegate
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  
  // MARK: property
  
  var window: UIWindow?
  private var sceneCoordinator: SceneCoordinator?
  private let disposeBag = DisposeBag()
  private let userDefaults: VGUserDefaults = UserDefaults.standard
  private let storageProvider = VGStorageProvider()

  // MARK: - life cycle
  
  func scene(
    _ scene: UIScene,
    willConnectTo session: UISceneSession,
    options connectionOptions: UIScene.ConnectionOptions
  ) {
    guard let windowScene = (scene as? UIWindowScene) else {
      return
    }
    window = UIWindow(windowScene: windowScene)
    guard let window = window else {
      return
    }
    
    storageProvider.saveInitialSpots(userDefaults: userDefaults)
    
    sceneCoordinator = SceneCoordinator(window: window, userDefaults: userDefaults, storageProvider: storageProvider)
    sceneCoordinator?.start()
      .subscribe()
      .disposed(by: disposeBag)
  }

  func sceneDidDisconnect(_ scene: UIScene) {
  }

  func sceneDidBecomeActive(_ scene: UIScene) {
  }

  func sceneWillResignActive(_ scene: UIScene) {
  }

  func sceneWillEnterForeground(_ scene: UIScene) {
  }

  func sceneDidEnterBackground(_ scene: UIScene) {
  }
}
