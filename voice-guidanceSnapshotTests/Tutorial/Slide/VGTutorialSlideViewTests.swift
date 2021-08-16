import SnapshotTesting
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
  
  func testVGTutorialSlideView_whenIntro_snapshotTest() throws {
    let sut = VGTutorialSlideView(viewModel: .intro)
    [(UIUserInterfaceStyle.dark, "dark"), (UIUserInterfaceStyle.light, "light")].forEach { style, named in
      sut.overrideUserInterfaceStyle = style
      assertSnapshot(
        matching: sut,
        as: .img(precision: 0.98),
        named: named + "." + model.name
      )
    }
  }
  
  func testVGTutorialSlideView_whenMap_snapshotTest() throws {
    let sut = VGTutorialSlideView(viewModel: .map)
    [(UIUserInterfaceStyle.dark, "dark"), (UIUserInterfaceStyle.light, "light")].forEach { style, named in
      sut.overrideUserInterfaceStyle = style
      assertSnapshot(
        matching: sut,
        as: .img(precision: 0.98),
        named: named + "." + model.name
      )
    }
  }
  
  func testVGTutorialSlideView_whenAr_snapshotTest() throws {
    let sut = VGTutorialSlideView(viewModel: .ar)
    [(UIUserInterfaceStyle.dark, "dark"), (UIUserInterfaceStyle.light, "light")].forEach { style, named in
      sut.overrideUserInterfaceStyle = style
      assertSnapshot(
        matching: sut,
        as: .img(precision: 0.98),
        named: named + "." + model.name
      )
    }
  }
  
  func testVGTutorialSlideView_whenLast_snapshotTest() throws {
    let sut = VGTutorialSlideView(viewModel: .last)
    [(UIUserInterfaceStyle.dark, "dark"), (UIUserInterfaceStyle.light, "light")].forEach { style, named in
      sut.overrideUserInterfaceStyle = style
      assertSnapshot(
        matching: sut,
        as: .img(precision: 0.98),
        named: named + "." + model.name
      )
    }
  }
}
