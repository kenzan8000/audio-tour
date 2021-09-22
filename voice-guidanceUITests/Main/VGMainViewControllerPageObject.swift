import XCTest
  
// MARK: - VGMainViewControllerPageObject
struct VGMainViewControllerPageObject {
  // MARK: property
  
  let app: XCUIApplication
  let permission = XCUIApplication(bundleIdentifier: "com.apple.springboard")
 
  private var tabBar: XCUIElement {
    XCUIApplication().tabBars["Tab Bar"]
  }
  private var locationPermissionAlert: XCUIElement {
    permission.alerts["Allow “Audio Tour” to use your location?"]
  }
  private var cameraPermissionAlert: XCUIElement {
    permission.alerts["“Audio Tour” Would Like to Access the Camera"]
  }
  
  // MARK: publiic api
  
  func tapMapTab() -> VGMapViewControllerPageObject {
    if locationPermissionAlert.waitForExistence(timeout: 10.0) {
      locationPermissionAlert.buttons["Allow While Using App"].tap()
    }
    tabBar.buttons["Map"].tap()
    return .init(app: app)
  }
  
  func tapARTab() -> VGARViewControllerPageObject {
    if locationPermissionAlert.waitForExistence(timeout: 10.0) {
      locationPermissionAlert.buttons["Allow While Using App"].tap()
    }
    tabBar.buttons["AR"].tap()
    if cameraPermissionAlert.waitForExistence(timeout: 10.0) {
      cameraPermissionAlert.buttons["OK"].tap()
    }
    return .init(app: app)
  }
}
