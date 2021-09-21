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
    app.launchArguments += ["-VGUserDefaults", "VGUserDefaults.doneTutorial", "Bool", "false"]
    app.launch()
    _ = VGTutorialViewControllerPageObject(app: app).runTutorial()
  }
}
