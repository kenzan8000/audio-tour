import XCTest
  
// MARK: - VGTutorialViewControllerPageObject
struct VGTutorialViewControllerPageObject {
  // MARK: property
  
  let app: XCUIApplication
  let permission = XCUIApplication(bundleIdentifier: "com.apple.springboard")
  
  private var nextButton: XCUIElement {
    app.buttons["Next"]
  }
  private var doneButton: XCUIElement {
    app.buttons["Done"]
  }
  private var locationPermissionAlert: XCUIElement {
    permission.alerts["Allow “Audio Tour” to use your location?"]
  }
  private var cameraPermissionAlert: XCUIElement {
    permission.alerts["“Audio Tour” Would Like to Access the Camera"]
  }
  
  // MARK: publiic api
  
  func runTutorial() -> VGMainViewControllerPageObject {
    XCTContext.runActivity(named: "Tutorial") { _ in
      XCTContext.runActivity(named: "page 1") { _ in
        nextButton.tap()
      }
      XCTContext.runActivity(named: "page 2") { _ in
        nextButton.tap()
        if locationPermissionAlert.waitForExistence(timeout: 10.0) {
          locationPermissionAlert.buttons["Allow While Using App"].tap()
        }
      }
      XCTContext.runActivity(named: "page 3") { _ in
        nextButton.tap()
        if cameraPermissionAlert.waitForExistence(timeout: 10.0) {
          cameraPermissionAlert.buttons["OK"].tap()
        }
      }
      XCTContext.runActivity(named: "page 4") { _ in
        doneButton.tap()
      }
    }
    return .init(app: app)
  }
}
