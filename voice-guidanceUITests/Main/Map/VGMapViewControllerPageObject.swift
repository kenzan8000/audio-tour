import XCTest
  
// MARK: - VGMapViewControllerPageObject
struct VGMapViewControllerPageObject {
  // MARK: property
  
  let app: XCUIApplication
  let permission = XCUIApplication(bundleIdentifier: "com.apple.springboard")
 
  private var menuButton: XCUIElement {
    app.buttons["more"]
  }
  
  // MARK: publiic api
  
  func tapTutorial() -> VGTutorialViewControllerPageObject {
    menuButton.tap()
    app.tables.staticTexts["Tutorial"].tap()
    return .init(app: app)
  }
 
}
