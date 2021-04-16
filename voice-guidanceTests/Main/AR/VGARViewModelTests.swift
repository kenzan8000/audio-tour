import CoreLocation
import XCTest
@testable import voice_guidance

// MARK: - VGARViewModelTests
class VGARViewModelTests: XCTestCase {

  // MARK: property
  
  var sut: VGARViewModel!
  
  // MARK: life cycle

  override func setUpWithError() throws {
    let storageProvider = VGStorageProvider(source: Bundle(for: type(of: VGARViewModelTests())), name: "VGCoreData", group: "org.kenzan8000.voice-guidanceTests")
    sut = VGARViewModel(
      storageProvider: storageProvider,
      locationManager: VGMockLocationManager(delegate: nil, authorizationStatus: .authorizedWhenInUse)
    )
    super.setUp()
  }

  override func tearDownWithError() throws {
    sut = nil
    super.tearDown()
  }
  
  // MARK: test
  
  func testVGARViewModel_whenDefaultCoordinate_spotsShouldBeMoreThanZero() throws {
    sut.updateLocation(CLLocation(coordinate: VGARMap.defaultCoordinate, altitude: 0.0))
    XCTAssertGreaterThan(sut.spots.count, 0)
    XCTAssertGreaterThan(sut.spotNodes.count, 0)
  }
  
  func testVGARViewModel_whenDefaultCoordinate_searchResultShouldBeMoreThanZero() throws {
    sut.updateLocation(CLLocation(coordinate: VGARMap.defaultCoordinate, altitude: 0.0))
    sut.search(text: "")
    XCTAssertGreaterThan(sut.searchResult.count, 0)
  }

  func testVGARViewModel_whenCloseToGoldenGateBridgeAndSearchIt_searchResultShouldBeOne() throws {
    sut.updateLocation(CLLocation(coordinate: CLLocationCoordinate2D(latitude: 37.813916, longitude: -122.478257), altitude: 0.0))
    sut.search(text: "The Golden Gate Bridge")
    XCTAssertEqual(sut.searchResult.count, 1)
  }
}
