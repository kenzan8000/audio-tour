import SnapshotTesting
import XCTest
@testable import voice_guidance

// MARK: - VGTutorialViewControllerTests
class VGTutorialViewControllerTests: XCTestCase {

  // MARK: property
  
  var sut: VGTutorialViewController!
  
  // MARK: life cycle

  override func setUpWithError() throws {
    sut = VGTutorialViewController(
      viewModel: VGTutorialViewModel(
        userDefaults: VGMockUserDefaults(),
        locationManagerFactory: { VGMockLocationManager(delegate: nil, authorizationStatus: .authorizedWhenInUse) },
        captureDeviceFactory: { VGMockCaptureDevice(authorizationStatus: .authorized) }
      )
    )
    sut.loadViewIfNeeded()
    super.setUp()
  }

  override func tearDownWithError() throws {
    sut = nil
    super.tearDown()
  }
  
  // MARK: test
  
  func testVGTutorialViewController_whenIntro_snapshotTest() throws {
    sut.present(.intro)
    [(UIUserInterfaceStyle.dark, "dark"), (UIUserInterfaceStyle.light, "light")].forEach { style, named in
      sut.overrideUserInterfaceStyle = style
      assertSnapshot(
        matching: sut,
        as: .img(precision: 0.98),
        named: named + "." + model.name
      )
    }
  }
  
  func testVGTutorialViewController_whenMap_snapshotTest() throws {
    sut.present(.map)
    [(UIUserInterfaceStyle.dark, "dark"), (UIUserInterfaceStyle.light, "light")].forEach { style, named in
      sut.overrideUserInterfaceStyle = style
      assertSnapshot(
        matching: sut,
        as: .img(precision: 0.98),
        named: named + "." + model.name
      )
    }
  }
  
  func testVGTutorialViewController_whenAr_snapshotTest() throws {
    sut.present(.ar)
    [(UIUserInterfaceStyle.dark, "dark"), (UIUserInterfaceStyle.light, "light")].forEach { style, named in
      sut.overrideUserInterfaceStyle = style
      assertSnapshot(
        matching: sut,
        as: .img(precision: 0.98),
        named: named + "." + model.name
      )
    }
  }
  
  func testVGTutorialViewController_whenLast_snapshotTest() throws {
    sut.present(.last)
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
