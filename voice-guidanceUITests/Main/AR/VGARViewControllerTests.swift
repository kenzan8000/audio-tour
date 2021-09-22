import XCTest
  
// MARK: - VGARViewControllerTests
class VGARViewControllerTests: XCTestCase {

  // MARK: life cycle
  
  override func setUpWithError() throws {
    continueAfterFailure = false
  }

  override func tearDownWithError() throws {
  }

  // MARK: test
  
  func testVGARViewController_whenRunningTutorial_shouldPassAll() throws {
    let app = XCUIApplication()
    app.launchArguments += [
      "-VGUserDefaults", "VGUserDefaults.doneTutorial", "Bool", "true",
      "-VGUserDefaults", "VGUserDefaults.doneARTutorial", "Bool", "false",
    ]
    app.launch()
    let arView = VGMainViewControllerPageObject(app: app).tapARTab()
    XCTAssertTrue(arView.app.tabBars["Tab Bar"].buttons["AR"].isSelected)
    arView.runTutorial()
  }
  
  func testVGARViewController_whenTappingTutorialMenu_shouldGoToTutorialView() throws {
    let app = XCUIApplication()
    app.launchArguments += [
      "-VGUserDefaults", "VGUserDefaults.doneTutorial", "Bool", "true",
      "-VGUserDefaults", "VGUserDefaults.doneARTutorial", "Bool", "true",
    ]
    app.launch()
    let arView = VGMainViewControllerPageObject(app: app).tapARTab()
    XCTAssertTrue(arView.app.tabBars["Tab Bar"].buttons["AR"].isSelected)
    let tutorialView = arView.tapTutorial()
    XCTAssertTrue(tutorialView.app.staticTexts["Welcome to Audio Tour"].exists)
  }

}
