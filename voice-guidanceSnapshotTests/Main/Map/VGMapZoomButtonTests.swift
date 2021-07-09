import SnapshotTesting
import XCTest
@testable import voice_guidance

// MARK: - VGMapZoomButtonTests
class VGMapZoomButtonTests: XCTestCase {
  
  // MARK: life cycle

  override func setUpWithError() throws {
    super.setUp()
  }

  override func tearDownWithError() throws {
    super.tearDown()
  }
  
  // MARK: test
  
  func testVGMapZoomButton_whenZoomTypeEqualsToZoomIn_snapshotTest() throws {
    let sut = VGMapZoomButton(zoomType: .zoomIn)
    [(UIUserInterfaceStyle.dark, "dark"), (UIUserInterfaceStyle.light, "light")].forEach { style, named in
      sut.overrideUserInterfaceStyle = style
      assertSnapshot(
        matching: sut,
        as: .img(precision: 0.98),
        named: named + "." + model.name
      )
    }
  }
  func testVGMapZoomButton_whenZoomTypeEqualsToZoomOut_snapshotTest() throws {
    let sut = VGMapZoomButton(zoomType: .zoomOut)
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
