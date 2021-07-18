import CoreLocation
import UIKit

// MARK: - SceneDelegate
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  
  // MARK: property
  
  var window: UIWindow?
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
    
    storageProvider.saveInitialSpots(userDefaults: userDefaults)
    
    window = UIWindow(windowScene: windowScene)
    window?.makeKeyAndVisible()
    window?.rootViewController = VGRootViewController(
      viewModel: VGRootViewModel(userDefaults: userDefaults),
      tutorialViewControllerFactory: { [unowned self] in
        VGTutorialViewController(
          viewModel: VGTutorialViewModel(
            userDefaults: userDefaults,
            locationManagerFactory: { CLLocationManager() },
            captureDeviceFactory: { VGAVCaptureDevice() }
          )
        )
      },
      mainViewControllerFactory: { [unowned self] in
        VGMainDependencyContainer().makeMainViewController(
          mapDependencyContainer: VGMapDependencyContainer(),
          arDependencyContainer: VGARDependencyContainer(),
          userDefaults: userDefaults,
          storageProvider: storageProvider
        ) { CLLocationManager() }
      }
    )
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
