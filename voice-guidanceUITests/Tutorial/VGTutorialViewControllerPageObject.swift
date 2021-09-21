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
  
  func runTutorial() -> XCUIApplication {
    // page 1
    nextButton.tap()
    // page 2
    nextButton.tap()
    if locationPermissionAlert.waitForExistence(timeout: 10.0) {
      locationPermissionAlert.buttons["Allow While Using App"].tap()
    }
    // page 3
    nextButton.tap()
    if cameraPermissionAlert.waitForExistence(timeout: 10.0) {
      cameraPermissionAlert.buttons["OK"].tap()
    }
    // page 4
    doneButton.tap()
    
    return app
  }
}
