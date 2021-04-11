import RxCocoa
import RxSwift
import UIKit

// MARK: - VGSearchTableView
class VGSearchTableView: VGNibView {

  // MARK: property
  
  private let disposeBag = DisposeBag()
  
  @IBOutlet private(set) weak var tableView: UITableView!

  // MARK: initializer
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  /// Inits
  init() {
    super.init(frame: .zero)
  }

  // MARK: public api
  
  /// Presents view
  /// - Parameters:
  ///   - parentView: parent view this view is presenting on
  ///   - searchView: VGSearchView
  func present(on parentView: UIView, searchView: VGSearchView) {
    frame = parentView.bounds
    let top = searchView.center.y + searchView.frame.size.height / 2.0
    let bottom = tableView.frame.origin.y + tableView.frame.height
    tableView.frame = CGRect(
      x: tableView.frame.origin.x,
      y: top,
      width: tableView.frame.width,
      height: bottom - top
    )
    parentView.addSubview(self)
  }
  
  /// Dismisses view
  func dismiss() {
    removeFromSuperview()
  }
  
  /// Reloads data
  func reloadsData() {
    tableView.reloadData()
  }
}

// MARK: - Reactive Extension
extension Reactive where Base: VGSearchTableView {
  // MARK: property
  
  var itemSelected: ControlEvent<IndexPath> {
    .init(events: base.tableView.rx.itemSelected)
  }
  
  func items<Sequence: Swift.Sequence, Source: ObservableType>(_ source: Source) -> (_ cellFactory: @escaping (UITableView, Int, Sequence.Element) -> UITableViewCell) -> Disposable where Source.Element == Sequence {
    base.tableView.rx.items(source)
  }
}
