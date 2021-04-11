import RxCocoa
import RxSwift
import SideMenu
import UIKit

// MARK: - VGSideMenuViewController
class VGSideMenuViewController: UIViewController {
  // MARK: property
  let disposeBag = DisposeBag()
  
  @IBOutlet private(set) weak var tableView: UITableView!
  let viewModel: VGSideMenuViewModel
  
  // MARK: initializer
  
  required init?(coder: NSCoder) {
    viewModel = VGSideMenuViewModel(sideMenus: [])
    super.init(coder: coder)
  }
  
  /// Inits view controller
  /// - Parameter viewModel: VGSideMenuViewModel
  init(viewModel: VGSideMenuViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  // MARK: life cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    viewModel.sideMenuWasUpdatedEvent
      .bind(to: tableView.rx.items) { _, _, sideMenu in
        VGSideMenuTableViewCell(title: sideMenu.title)
      }
      .disposed(by: disposeBag)
    viewModel.sideMenuWasUpdatedEvent
      .subscribe { [weak self] _ in
        self?.tableView.reloadData()
      }
      .disposed(by: disposeBag)
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    view.frame = CGRect(
      x: 0,
      y: 0,
      width: VGSideMenuNavigationController.defaultWidth,
      height: UIScreen.main.bounds.height
    )
    tableView.frame = view.frame
  }
  
  override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    super.traitCollectionDidChange(previousTraitCollection)
  }
}

// MARK: - Reactive Extension
extension Reactive where Base: VGSideMenuViewController {
  // MARK: property
  
  var itemSelected: ControlEvent<IndexPath> {
    .init(events: base.tableView.rx.itemSelected)
  }
}

// MARK: - VGSideMenuNavigationController
class VGSideMenuNavigationController: SideMenuNavigationController {
  
  // MARK: static constant
  
  static let defaultWidth = CGFloat(240)

  // MARK: initializer

  @available(*, unavailable)
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override init(rootViewController: UIViewController, settings: SideMenuSettings = SideMenuSettings()) {
    super.init(rootViewController: rootViewController)
    isNavigationBarHidden = true
    leftSide = true
    presentationStyle = .menuSlideIn
    menuWidth = VGSideMenuNavigationController.defaultWidth
    blurEffectStyle = .regular
  }
}
