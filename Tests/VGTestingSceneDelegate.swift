import UIKit

// MARK: - VGTestingSceneDelegate
class VGTestingSceneDelegate: UIResponder, UIWindowSceneDelegate {

  // MARK: - property
  
  var window: UIWindow?

  // MARK: - life cycle
  
  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    guard let windowScene = (scene as? UIWindowScene) else { return }
    window = UIWindow(windowScene: windowScene)
    window?.rootViewController = VGTestingRootViewController()
    window?.makeKeyAndVisible()
  }
}
