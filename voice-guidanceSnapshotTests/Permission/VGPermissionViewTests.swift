import SnapshotTesting
import XCTest
@testable import voice_guidance

// MARK: - VGPermissionViewTests
class VGPermissionViewTests: XCTestCase {

  // MARK: life cycle

  override func setUpWithError() throws {
    super.setUp()
  }

  override func tearDownWithError() throws {
    super.tearDown()
  }
  
  // MARK: test
  
  func testVGPermissionView_whenPermissionTypeIsLocationAndVideoAndBothAuthorized_snapshotTest() throws {
    let sut = VGPermissionView(
      viewModel: VGPermissionViewModel(
        permissionType: .locationAndVideo,
        locationManager: VGMockLocationManager(delegate: nil, authorizationStatus: .authorizedWhenInUse),
        captureDevice: VGMockCaptureDevice(authorizationStatus: .authorized)
      )
    )
    [(UIUserInterfaceStyle.dark, "dark"), (UIUserInterfaceStyle.light, "light")].forEach { style, named in
      sut.overrideUserInterfaceStyle = style
      assertSnapshot(
        matching: sut,
        as: .image(precision: 0.98, traits: .iPhone8(.portrait)),
        named: named
      )
    }
  }
  
  func testVGPermissionView_whenPermissionTypeIsLocationAndVideoAndLocationNotAuthorized_snapshotTest() throws {
    let sut = VGPermissionView(
      viewModel: VGPermissionViewModel(
        permissionType: .locationAndVideo,
        locationManager: VGMockLocationManager(delegate: nil, authorizationStatus: .denied),
        captureDevice: VGMockCaptureDevice(authorizationStatus: .authorized)
      )
    )
    [(UIUserInterfaceStyle.dark, "dark"), (UIUserInterfaceStyle.light, "light")].forEach { style, named in
      sut.overrideUserInterfaceStyle = style
      assertSnapshot(
        matching: sut,
        as: .image(precision: 0.98, traits: .iPhone8(.portrait)),
        named: named
      )
    }
  }
  
  func testVGPermissionView_whenPermissionTypeIsLocationAndVideoAndCameraNotAuthorized_snapshotTest() throws {
    let sut = VGPermissionView(
      viewModel: VGPermissionViewModel(
        permissionType: .locationAndVideo,
        locationManager: VGMockLocationManager(delegate: nil, authorizationStatus: .authorizedWhenInUse),
        captureDevice: VGMockCaptureDevice(authorizationStatus: .denied)
      )
    )
    [(UIUserInterfaceStyle.dark, "dark"), (UIUserInterfaceStyle.light, "light")].forEach { style, named in
      sut.overrideUserInterfaceStyle = style
      assertSnapshot(
        matching: sut,
        as: .image(precision: 0.98, traits: .iPhone8(.portrait)),
        named: named
      )
    }
  }
  
  func testVGPermissionView_whenPermissionTypeIsLocationAndVideoAndBothNotAuthorized_snapshotTest() throws {
    let sut = VGPermissionView(
      viewModel: VGPermissionViewModel(
        permissionType: .locationAndVideo,
        locationManager: VGMockLocationManager(delegate: nil, authorizationStatus: .denied),
        captureDevice: VGMockCaptureDevice(authorizationStatus: .denied)
      )
    )
    [(UIUserInterfaceStyle.dark, "dark"), (UIUserInterfaceStyle.light, "light")].forEach { style, named in
      sut.overrideUserInterfaceStyle = style
      assertSnapshot(
        matching: sut,
        as: .image(precision: 0.98, traits: .iPhone8(.portrait)),
        named: named
      )
    }
  }
}
