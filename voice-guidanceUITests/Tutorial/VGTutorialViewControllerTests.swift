import XCTest
  
// MARK: - VGTutorialViewControllerTests
class VGTutorialViewControllerTests: XCTestCase {

  // MARK: life cycle
  
  override func setUpWithError() throws {
    continueAfterFailure = false
  }

  override func tearDownWithError() throws {
  }

  // MARK: test
  
  func testVGTutorialViewController_whenInitialState_uiTest() throws {
    let app = XCUIApplication()
    let permission = XCUIApplication(bundleIdentifier: "com.apple.springboard")
    app.launchArguments += ["-VGUserDefaults", "VGUserDefaults.doneTutorial", "Bool", "false"]
    app.launch()
    
    app.buttons["Next"].tap()
    
    app.buttons["Next"].tap()
    if permission.alerts["Allow “Audio Tour” to use your location?"].waitForExistence(timeout: 2.5) {
      permission.alerts["Allow “Audio Tour” to use your location?"].buttons["Allow While Using App"].tap()
    }
    
    app.buttons["Next"].tap()
    if permission.alerts["“Audio Tour” Would Like to Access the Camera"].waitForExistence(timeout: 2.5) {
      permission.alerts["“Audio Tour” Would Like to Access the Camera"].buttons["OK"].tap()
    }
    
    app.buttons["Done"].tap()
  }
}
