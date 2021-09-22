import XCTest
  
// MARK: - VGMapViewControllerTests
class VGMapViewControllerTests: XCTestCase {

  // MARK: life cycle
  
  override func setUpWithError() throws {
    continueAfterFailure = false
  }

  override func tearDownWithError() throws {
  }

  // MARK: test
  
  func testVGMapViewController_whenTappingTutorialMenu_shouldGoToTutorialView() throws {
    let app = XCUIApplication()
    app.launchArguments += [
      "-VGUserDefaults", "VGUserDefaults.doneTutorial", "Bool", "true"
    ]
    app.launch()
    let mapView = VGMainViewControllerPageObject(app: app).tapMapTab()
    XCTAssertTrue(mapView.app.tabBars["Tab Bar"].buttons["Map"].isSelected)
    let tutorialView = mapView.tapTutorial()
    XCTAssertTrue(tutorialView.app.staticTexts["Welcome to Audio Tour"].exists)
  }

}
