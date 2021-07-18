import UIKit

// MARK: - VGTestingAppDelegate
@objc(VGTestingAppDelegate)
class VGTestingAppDelegate: UIResponder, UIApplicationDelegate {
func application(
  _ application: UIApplication,
  didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    true
  }

  func application(
    _ application: UIApplication,
    configurationForConnecting connectingSceneSession: UISceneSession,
    options: UIScene.ConnectionOptions
  ) -> UISceneConfiguration {
    let sceneConfiguration = UISceneConfiguration(name: nil, sessionRole: connectingSceneSession.role)
    sceneConfiguration.delegateClass = VGTestingSceneDelegate.self
    sceneConfiguration.storyboard = nil
    return sceneConfiguration
  }
}
