import SnapshotTesting
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
  
  func testVGSideMenuViewController_whenInitialState_snapshotTest() throws {
    let sut = VGSideMenuViewController(viewModel: VGSideMenuViewModel(sideMenus: [.init(title: "Tutorial"), .init(title: "AR Tutorial")]))
    
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
