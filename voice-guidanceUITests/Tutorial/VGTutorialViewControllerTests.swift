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
  
  func testVGTutorialViewController_whenRunningTutorial_shouldGoToMapViewAfterTutorial() throws {
    let app = XCUIApplication()
    app.launchArguments += ["-VGUserDefaults", "VGUserDefaults.doneTutorial", "Bool", "false"]
    app.launch()
    let tutorialView = VGTutorialViewControllerPageObject(app: app)
    XCTAssertTrue(tutorialView.app.staticTexts["Welcome to Audio Tour"].exists)
    let mainView = tutorialView.runTutorial()
    XCTAssertTrue(mainView.app.tabBars["Tab Bar"].buttons["Map"].isSelected)
  }
}
