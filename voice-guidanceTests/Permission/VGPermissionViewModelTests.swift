import AVFoundation
import CoreLocation
import XCTest
@testable import voice_guidance

// MARK: - VGPermissionViewModelTests
class VGPermissionViewModelTests: XCTestCase {

  // MARK: life cycle

  override func setUpWithError() throws {
    super.setUp()
  }

  override func tearDownWithError() throws {
    super.tearDown()
  }
  
  // MARK: test
  
  func testVGPermissionViewModel_whenPermissionTypeIsLocationAndVideo_shouldBeAuthorized() throws {
    let locations: [CLAuthorizationStatus] = [.notDetermined, .restricted, .denied, .authorizedWhenInUse, .authorizedAlways]
    let videos: [AVAuthorizationStatus] = [.notDetermined, .restricted, .denied, .authorized]
    locations.forEach { location in
      videos.forEach { video in
        let result = VGPermissionViewModel.authorized(
          permissionType: .locationAndVideo,
          locationManager: VGMockLocationManager(delegate: nil, authorizationStatus: location),
          captureDevice: VGMockCaptureDevice(authorizationStatus: video)
        )
        let authorized = (location == .authorizedAlways || location == .authorizedWhenInUse) && video == .authorized
        XCTAssertEqual(result, authorized)
      }
    }
  }
  
  func testVGPermissionViewModel_whenPermissionTypeIsLocation_shouldBeAuthorized() throws {
    let locations: [CLAuthorizationStatus] = [.notDetermined, .restricted, .denied, .authorizedWhenInUse, .authorizedAlways]
    let videos: [AVAuthorizationStatus] = [.notDetermined, .restricted, .denied, .authorized]
    locations.forEach { location in
      videos.forEach { video in
        let result = VGPermissionViewModel.authorized(
          permissionType: .location,
          locationManager: VGMockLocationManager(delegate: nil, authorizationStatus: location),
          captureDevice: VGMockCaptureDevice(authorizationStatus: video)
        )
        let authorized = location == .authorizedAlways || location == .authorizedWhenInUse
        XCTAssertEqual(result, authorized)
      }
    }
  }
  
  func testVGPermissionViewModel_whenPermissionTypeIsVideo_shouldBeAuthorized() throws {
    let locations: [CLAuthorizationStatus] = [.notDetermined, .restricted, .denied, .authorizedWhenInUse, .authorizedAlways]
    let videos: [AVAuthorizationStatus] = [.notDetermined, .restricted, .denied, .authorized]
    locations.forEach { location in
      videos.forEach { video in
        let result = VGPermissionViewModel.authorized(
          permissionType: .video,
          locationManager: VGMockLocationManager(delegate: nil, authorizationStatus: location),
          captureDevice: VGMockCaptureDevice(authorizationStatus: video)
        )
        let authorized = video == .authorized
        XCTAssertEqual(result, authorized)
      }
    }
  }

  func testVGPermissionViewModel_whenPermissionTypeIsNotNeeded_shouldBeAuthorized() throws {
    let locations: [CLAuthorizationStatus] = [.notDetermined, .restricted, .denied, .authorizedWhenInUse, .authorizedAlways]
    let videos: [AVAuthorizationStatus] = [.notDetermined, .restricted, .denied, .authorized]
    locations.forEach { location in
      videos.forEach { video in
        let result = VGPermissionViewModel.authorized(
          permissionType: .notNeeded,
          locationManager: VGMockLocationManager(delegate: nil, authorizationStatus: location),
          captureDevice: VGMockCaptureDevice(authorizationStatus: video)
        )
        XCTAssertTrue(result)
      }
    }
  }

  func testVGPermissionViewModel_whenPermissionTypeIsLocationAndVideo_shouldBeDetermined() throws {
    let locations: [CLAuthorizationStatus] = [.notDetermined, .restricted, .denied, .authorizedWhenInUse, .authorizedAlways]
    let videos: [AVAuthorizationStatus] = [.notDetermined, .restricted, .denied, .authorized]
    locations.forEach { location in
      videos.forEach { video in
        let result = VGPermissionViewModel.determined(
          permissionType: .locationAndVideo,
          locationManager: VGMockLocationManager(delegate: nil, authorizationStatus: location),
          captureDevice: VGMockCaptureDevice(authorizationStatus: video)
        )
        let determined = location != .notDetermined && video != .notDetermined
        XCTAssertEqual(result, determined)
      }
    }
  }
  
  func testVGPermissionViewModel_whenPermissionTypeIsLocation_shouldBeDetermined() throws {
    let locations: [CLAuthorizationStatus] = [.notDetermined, .restricted, .denied, .authorizedWhenInUse, .authorizedAlways]
    let videos: [AVAuthorizationStatus] = [.notDetermined, .restricted, .denied, .authorized]
    locations.forEach { location in
      videos.forEach { video in
        let result = VGPermissionViewModel.determined(
          permissionType: .location,
          locationManager: VGMockLocationManager(delegate: nil, authorizationStatus: location),
          captureDevice: VGMockCaptureDevice(authorizationStatus: video)
        )
        let determined = location != .notDetermined
        XCTAssertEqual(result, determined)
      }
    }
  }
  
  func testVGPermissionViewModel_whenPermissionTypeIsVideo_shouldBeDetermined() throws {
    let locations: [CLAuthorizationStatus] = [.notDetermined, .restricted, .denied, .authorizedWhenInUse, .authorizedAlways]
    let videos: [AVAuthorizationStatus] = [.notDetermined, .restricted, .denied, .authorized]
    locations.forEach { location in
      videos.forEach { video in
        let result = VGPermissionViewModel.determined(
          permissionType: .video,
          locationManager: VGMockLocationManager(delegate: nil, authorizationStatus: location),
          captureDevice: VGMockCaptureDevice(authorizationStatus: video)
        )
        let determined = video != .notDetermined
        XCTAssertEqual(result, determined)
      }
    }
  }

  func testVGPermissionViewModel_whenPermissionTypeIsNotNeeded_shouldBeDetermined() throws {
    let locations: [CLAuthorizationStatus] = [.notDetermined, .restricted, .denied, .authorizedWhenInUse, .authorizedAlways]
    let videos: [AVAuthorizationStatus] = [.notDetermined, .restricted, .denied, .authorized]
    locations.forEach { location in
      videos.forEach { video in
        let result = VGPermissionViewModel.determined(
          permissionType: .notNeeded,
          locationManager: VGMockLocationManager(delegate: nil, authorizationStatus: location),
          captureDevice: VGMockCaptureDevice(authorizationStatus: video)
        )
        XCTAssertTrue(result)
      }
    }
  }
}
