import XCTest
@testable import voice_guidance

// MARK: - VGSideMenuViewControllerTests
class VGSideMenuViewControllerTests: XCTestCase {

  // MARK: life cycle

  override func setUpWithError() throws {
    super.setUp()
  }

  override func tearDownWithError() throws {
    super.tearDown()
  }
  
  // MARK: test
  
  func testVGSideMenuViewController_whenInitialState_outletsShouldBeConnected() throws {
    let sut = VGSideMenuViewController(viewModel: VGSideMenuViewModel(sideMenus: [VGSideMenu(title: "1"), VGSideMenu(title: "2")]))
    sut.loadViewIfNeeded()
    XCTAssertNotNil(sut.tableView)
  }
}
