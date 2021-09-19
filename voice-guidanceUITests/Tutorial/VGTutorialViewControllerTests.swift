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
  
  func test() throws {
    let app = XCUIApplication()
    app.launchArguments += ["-VGUserDefaults", "doneTutorial", "false"]
    app.launch()
  }
}
