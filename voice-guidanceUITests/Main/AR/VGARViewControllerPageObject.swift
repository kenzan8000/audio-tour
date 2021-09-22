import XCTest
  
// MARK: - VGARViewControllerPageObject
struct VGARViewControllerPageObject {
  // MARK: property
  
  let app: XCUIApplication
  let permission = XCUIApplication(bundleIdentifier: "com.apple.springboard")
  
  private var overlay: XCUIElement {
    app.otherElements["AccessibilityIdentifiers.overlayView"]
  }
  private var menuButton: XCUIElement {
    app.buttons["more"]
  }
 
  // MARK: publiic api
      
  func runTutorial() {
    XCTContext.runActivity(named: "Tutorial") { _ in
      menuButton.tap()
      app.tables/*@START_MENU_TOKEN@*/.staticTexts["How to Use AR"]/*[[".cells.staticTexts[\"How to Use AR\"]",".staticTexts[\"How to Use AR\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
      XCTContext.runActivity(named: "page 1") { _ in
        overlay.tap()
      }
      XCTContext.runActivity(named: "page 2") { _ in
        overlay.tap()
      }
      XCTContext.runActivity(named: "page 3") { _ in
        overlay.tap()
      }
    }
  }
  
  func tapTutorial() -> VGTutorialViewControllerPageObject {
    menuButton.tap()
    app.tables.staticTexts["Tutorial"].tap()
    return .init(app: app)
  }
 
}
