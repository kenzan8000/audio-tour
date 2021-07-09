import CoreLocation
import SnapshotTesting
import UIKit
import XCTest
@testable import voice_guidance

// MARK: - VGGuideProgressSliderTests
class VGGuideProgressSliderTests: XCTestCase {
  
  // MARK: life cycle

  override func setUpWithError() throws {
    super.setUp()
  }

  override func tearDownWithError() throws {
    super.tearDown()
  }
  
  // MARK: test
  
  func testVGGuideProgressSlider_whenInitialState_snapshotTest() throws {
    let sut = VGGuideProgressSlider(frame: CGRect(origin: .zero, size: CGSize(width: 353, height: 28)))
    
    [(UIUserInterfaceStyle.dark, "dark"), (UIUserInterfaceStyle.light, "light")].forEach { style, named in
      sut.overrideUserInterfaceStyle = style
      assertSnapshot(
        matching: sut,
        as: .img(precision: 0.98),
        named: named + "." + model.name
      )
    }
  }
  
  func testVGGuideProgressSlider_whenProgressEqualsToHalf_snapshotTest() throws {
    let sut = VGGuideProgressSlider(frame: CGRect(origin: .zero, size: CGSize(width: 353, height: 28)))
    sut.setProgress(0.5, animated: false)
    
    [(UIUserInterfaceStyle.dark, "dark"), (UIUserInterfaceStyle.light, "light")].forEach { style, named in
      sut.overrideUserInterfaceStyle = style
      assertSnapshot(
        matching: sut,
        as: .img(precision: 0.98),
        named: named + "." + model.name
      )
    }
  }
  
  func testVGGuideProgressSlider_whenProgressEqualsToFull_snapshotTest() throws {
    let sut = VGGuideProgressSlider(frame: CGRect(origin: .zero, size: CGSize(width: 353, height: 28)))
    sut.setProgress(1.0, animated: false)
    
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
