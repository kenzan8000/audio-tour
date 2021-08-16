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
    let sut = VGTutorialSlideView(viewModel: .intro)
    XCTAssertNotNil(sut.headingLabel)
    XCTAssertNotNil(sut.paragraphLabel)
    XCTAssertNotNil(sut.scenaryImageView)
    XCTAssertNotNil(sut.tutorialImageView)
  }

  func testVGTutorialSlideView_whenInitialState_contentsShouldBeEqualToPassedParameters() throws {
    let viewModel = VGTutorialSlideViewModel.map
    let sut = VGTutorialSlideView(viewModel: viewModel)
    XCTAssertEqual(sut.headingLabel.text, viewModel.heading)
    XCTAssertEqual(sut.paragraphLabel.text, viewModel.paragraph)
    XCTAssertEqual(sut.scenaryImageView.image, viewModel.scenaryImage)
    XCTAssertEqual(sut.tutorialImageView.image, viewModel.tutorialImage)
  }
}
