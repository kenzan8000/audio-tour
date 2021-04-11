import XCTest
@testable import voice_guidance

// MARK: - VGTutorialSlideViewTests
class VGTutorialSlideViewTests: XCTestCase {

  // MARK: life cycle

  override func setUpWithError() throws {
    super.setUp()
  }

  override func tearDownWithError() throws {
    super.tearDown()
  }
  
  // MARK: test
  
  func testVGTutorialSlideView_whenInitialState_outletsShouldBeConnected() throws {
    let sut = VGTutorialSlideView(
      heading: "heading",
      paragraph: "paragraph",
      scenaryImage: nil,
      tutorialImage: nil
    )
    XCTAssertNotNil(sut.headingLabel)
    XCTAssertNotNil(sut.paragraphLabel)
    XCTAssertNotNil(sut.scenaryImageView)
    XCTAssertNotNil(sut.tutorialImageView)
  }
}
