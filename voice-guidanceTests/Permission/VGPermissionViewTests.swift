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
  
  func testVGPermissionView_whenInitialState_outletsShouldBeConnected() throws {
    let sut = VGPermissionView(
      viewModel: VGPermissionViewModel(
        permissionType: .locationAndVideo,
        locationManager: VGLocationManagerDummy(delegate: nil, authorizationStatus: .authorizedWhenInUse),
        captureDevice: VGCaptureDeviceStub(authorizationStatus: .authorized)
      )
    )
    XCTAssertNotNil(sut.headingLable)
    XCTAssertNotNil(sut.paragraphLable)
    XCTAssertNotNil(sut.cameraPermissionView)
    XCTAssertNotNil(sut.cameraPermissionButton)
    XCTAssertNotNil(sut.cameraPermissionStatusImageView)
    XCTAssertNotNil(sut.locationPermissionButton)
    XCTAssertNotNil(sut.locationPermissionStatusImageView)
  }
  
  func testVGPermissionView_whenPermissionTypeIsLocationAndVideo_shouldDisplayCameraPermission() throws {
    let sut = VGPermissionView(
      viewModel: VGPermissionViewModel(
        permissionType: .locationAndVideo,
        locationManager: VGLocationManagerDummy(delegate: nil, authorizationStatus: .authorizedWhenInUse),
        captureDevice: VGCaptureDeviceStub(authorizationStatus: .authorized)
      )
    )
    XCTAssertFalse(sut.cameraPermissionView.isHidden)
  }
  
  func testVGPermissionView_whenPermissionTypeIsVideo_shouldDisplayCameraPermission() throws {
    let sut = VGPermissionView(
      viewModel: VGPermissionViewModel(
        permissionType: .video,
        locationManager: VGLocationManagerDummy(delegate: nil, authorizationStatus: .authorizedWhenInUse),
        captureDevice: VGCaptureDeviceStub(authorizationStatus: .authorized)
      )
    )
    XCTAssertFalse(sut.cameraPermissionView.isHidden)
  }
  
  func testVGPermissionView_whenPermissionTypeIsLocation_shouldNotDisplayCameraPermission() throws {
    let sut = VGPermissionView(
      viewModel: VGPermissionViewModel(
        permissionType: .location,
        locationManager: VGLocationManagerDummy(delegate: nil, authorizationStatus: .authorizedWhenInUse),
        captureDevice: VGCaptureDeviceStub(authorizationStatus: .authorized)
      )
    )
    XCTAssertTrue(sut.cameraPermissionView.isHidden)
  }
  
  func testVGPermissionView_whenPermissionTypeIsLocationAndVideoAndBothAreAuthorized_buttonsShouldNotBeEnabled() throws {
    let sut = VGPermissionView(
      viewModel: VGPermissionViewModel(
        permissionType: .locationAndVideo,
        locationManager: VGLocationManagerDummy(delegate: nil, authorizationStatus: .authorizedWhenInUse),
        captureDevice: VGCaptureDeviceStub(authorizationStatus: .authorized)
      )
    )
    XCTAssertFalse(sut.locationPermissionStatusImageView.isHidden)
    XCTAssertTrue(sut.locationPermissionButton.titleColor(for: .normal) == .systemBlue)
    XCTAssertFalse(sut.locationPermissionButton.isUserInteractionEnabled)
    XCTAssertFalse(sut.cameraPermissionStatusImageView.isHidden)
    XCTAssertTrue(sut.cameraPermissionButton.titleColor(for: .normal) == .systemBlue)
    XCTAssertFalse(sut.cameraPermissionButton.isUserInteractionEnabled)
  }
  
  func testVGPermissionView_whenPermissionTypeIsLocationAndVideoAndLocationIsNotAuthorized_locationButtonShouldBeEnabled() throws {
    let sut = VGPermissionView(
      viewModel: VGPermissionViewModel(
        permissionType: .location,
        locationManager: VGLocationManagerDummy(delegate: nil, authorizationStatus: .denied),
        captureDevice: VGCaptureDeviceStub(authorizationStatus: .authorized)
      )
    )
    XCTAssertTrue(sut.locationPermissionStatusImageView.isHidden)
    XCTAssertTrue(sut.locationPermissionButton.titleColor(for: .normal) == .secondaryLabel)
    XCTAssertTrue(sut.locationPermissionButton.isUserInteractionEnabled)
    XCTAssertFalse(sut.cameraPermissionStatusImageView.isHidden)
    XCTAssertTrue(sut.cameraPermissionButton.titleColor(for: .normal) == .systemBlue)
    XCTAssertFalse(sut.cameraPermissionButton.isUserInteractionEnabled)
  }
  
  func testVGPermissionView_whenPermissionTypeIsLocationAndVideoAndCameraIsNotAuthorized_cameraButtonShouldBeEnabled() throws {
    let sut = VGPermissionView(
      viewModel: VGPermissionViewModel(
        permissionType: .video,
        locationManager: VGLocationManagerDummy(delegate: nil, authorizationStatus: .authorizedWhenInUse),
        captureDevice: VGCaptureDeviceStub(authorizationStatus: .denied)
      )
    )
    XCTAssertFalse(sut.locationPermissionStatusImageView.isHidden)
    XCTAssertTrue(sut.locationPermissionButton.titleColor(for: .normal) == .systemBlue)
    XCTAssertFalse(sut.locationPermissionButton.isUserInteractionEnabled)
    XCTAssertTrue(sut.cameraPermissionStatusImageView.isHidden)
    XCTAssertTrue(sut.cameraPermissionButton.titleColor(for: .normal) == .secondaryLabel)
    XCTAssertTrue(sut.cameraPermissionButton.isUserInteractionEnabled)
  }
}
