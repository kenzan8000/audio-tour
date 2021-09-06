import Combine
import RxCocoa
import RxSwift
import UIKit

// MARK: - VGSearchTableView
class VGSearchTableView: VGNibView {

  // MARK: property
  
  @IBOutlet private(set) weak var tableView: UITableView!
  
  private let disposeBag = DisposeBag()
  private var cancellable = Set<AnyCancellable>()
  
  private var keyboardHeight = CGFloat(0) {
    didSet { designTableView() }
  }
  private var tableViewTop = CGFloat(0)
  private let bottomOffset = CGFloat(16)

  // MARK: initializer
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  /// Inits
  init() {
    super.init(frame: .zero)
    NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
      .receive(on: DispatchQueue.main)
      .sink { [weak self] notification in
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
          self?.keyboardHeight = keyboardFrame.cgRectValue.height
        }
      }
      .store(in: &cancellable)
  }

  // MARK: public api
  
  /// Presents view
  /// - Parameters:
  ///   - parentView: parent view this view is presenting on
  ///   - searchView: VGSearchView
  func present(on parentView: UIView, searchView: VGSearchView) {
    frame = parentView.bounds
    tableViewTop = searchView.center.y + searchView.frame.size.height / 2.0
    designTableView()
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
  
  // MARK: private api
  
  func designTableView() {
    let bottom = frame.height - (keyboardHeight + bottomOffset)
    tableView.frame = CGRect(
      x: tableView.frame.origin.x,
      y: tableViewTop,
      width: tableView.frame.width,
      height: bottom - tableViewTop
    )
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
