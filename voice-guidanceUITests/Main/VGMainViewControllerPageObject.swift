import XCTest
  
// MARK: - VGMainViewControllerPageObject
struct VGMainViewControllerPageObject {
  // MARK: property
  
  let app: XCUIApplication
  let permission = XCUIApplication(bundleIdentifier: "com.apple.springboard")
 
  private var tabBar: XCUIElement {
    XCUIApplication().tabBars["Tab Bar"]
  }
  
  // MARK: publiic api
  
  func tapMapTab() -> VGMapViewControllerPageObject {
    tabBar.buttons["Map"].tap()
    return .init(app: app)
  }
  
  func tapARTab() -> VGARViewControllerPageObject {
    tabBar.buttons["AR"].tap()
    return .init(app: app)
  }
}
