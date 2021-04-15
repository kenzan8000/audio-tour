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
    let sut = VGTutorialSlideView(
      heading: NSLocalizedString("tutorial_title_01", comment: ""),
      paragraph: NSLocalizedString("tutorial_body_01", comment: ""),
      scenaryImage: UIImage(named: "tutorial_scenary_01"),
      tutorialImage: nil
    )
    [(UIUserInterfaceStyle.dark, "dark"), (UIUserInterfaceStyle.light, "light")].forEach { style, named in
      sut.overrideUserInterfaceStyle = style
      assertSnapshot(
        matching: sut,
        as: .image(precision: 0.98, traits: .iPhoneX(.portrait)),
        named: named
      )
    }
  }
  
  func testVGTutorialSlideView_whenMap_snapshotTest() throws {
    let sut = VGTutorialSlideView(
      heading: NSLocalizedString("tutorial_title_02", comment: ""),
      paragraph: NSLocalizedString("tutorial_body_02", comment: ""),
      scenaryImage: UIImage(named: "tutorial_scenary_02"),
      tutorialImage: UIImage(named: "tutorial_02")
    )
    [(UIUserInterfaceStyle.dark, "dark"), (UIUserInterfaceStyle.light, "light")].forEach { style, named in
      sut.overrideUserInterfaceStyle = style
      assertSnapshot(
        matching: sut,
        as: .image(precision: 0.98, traits: .iPhoneX(.portrait)),
        named: named
      )
    }
  }
  
  func testVGTutorialSlideView_whenAr_snapshotTest() throws {
    let sut = VGTutorialSlideView(
      heading: NSLocalizedString("tutorial_title_03", comment: ""),
      paragraph: NSLocalizedString("tutorial_body_03", comment: ""),
      scenaryImage: UIImage(named: "tutorial_scenary_03"),
      tutorialImage: UIImage(named: "tutorial_03")
    )
    [(UIUserInterfaceStyle.dark, "dark"), (UIUserInterfaceStyle.light, "light")].forEach { style, named in
      sut.overrideUserInterfaceStyle = style
      assertSnapshot(
        matching: sut,
        as: .image(precision: 0.98, traits: .iPhoneX(.portrait)),
        named: named
      )
    }
  }
  
  func testVGTutorialSlideView_whenLast_snapshotTest() throws {
    let sut = VGTutorialSlideView(
      heading: NSLocalizedString("tutorial_title_04", comment: ""),
      paragraph: NSLocalizedString("tutorial_body_04", comment: ""),
      scenaryImage: UIImage(named: "tutorial_scenary_04"),
      tutorialImage: nil
    )
    [(UIUserInterfaceStyle.dark, "dark"), (UIUserInterfaceStyle.light, "light")].forEach { style, named in
      sut.overrideUserInterfaceStyle = style
      assertSnapshot(
        matching: sut,
        as: .image(precision: 0.98, traits: .iPhoneX(.portrait)),
        named: named
      )
    }
  }
}
