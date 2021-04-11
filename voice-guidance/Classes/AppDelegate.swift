import CoreLocation
import os
import UIKit

let logger = Logger(subsystem: "\(Bundle.main.bundleIdentifier ?? "").logger", category: "main")

// MARK: - AppDelegate
class AppDelegate: UIResponder, UIApplicationDelegate {

  // MARK: property
  var window: UIWindow?
  private let userDefaults: VGUserDefaults = UserDefaults.standard
  private let storageProvider = VGStorageProvider()

  // MARK: life cycle
  
  // swiftlint:disable discouraged_optional_collection
  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
  ) -> Bool {
    storageProvider.saveInitialSpots(userDefaults: userDefaults)
    
    window = UIWindow(frame: UIScreen.main.bounds)
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
    return true
  }
  // swiftlint:enable discouraged_optional_collection
  
  func applicationWillResignActive(_ application: UIApplication) {
  }
  
  func applicationDidEnterBackground(_ application: UIApplication) {
  }
  
  func applicationWillEnterForeground(_ application: UIApplication) {
  }
  
  func applicationDidBecomeActive(_ application: UIApplication) {
  }
  
  func applicationWillTerminate(_ application: UIApplication) {
  }
}
