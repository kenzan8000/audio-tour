import RxCocoa
import RxSwift
import UIKit

// MARK: - VGSearchView
class VGSearchView: VGNibView {
  
  // MARK: property
  
  private let disposeBag = DisposeBag()
  
  @IBOutlet private(set) weak var textFieldBackgroundView: UIView!
  @IBOutlet private(set) weak var textField: UITextField!
  @IBOutlet private(set) weak var activeButton: UIButton!
  @IBOutlet private(set) weak var menuButton: UIButton!
  @IBOutlet private(set) weak var backButton: UIButton!
  @IBOutlet private(set) weak var clearButton: UIButton!
  @IBOutlet private(set) weak var spotImageView: UIImageView!
  var searchTableView: VGSearchTableView
  
  let activeObserver = PublishSubject<Bool>()
  let textObserver = PublishSubject<String>()
  let tapMenuObserver = PublishSubject<UIButton>()
  let tapItemObserver = PublishSubject<IndexPath>()

  // MARK: initializer
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  /// Inits
  /// - Parameter parentView: UIView
  init(on view: UIView) {
    searchTableView = VGSearchTableView()
    super.init(frame: .zero)
    textField.placeholder = NSLocalizedString("search_placeholder", comment: "")
      
    designView(parentView: view)
    bindView()
  }
  
  // MARK: destruction
  
  deinit {
    activeObserver.on(.completed)
    textObserver.on(.completed)
    tapMenuObserver.on(.completed)
    tapItemObserver.on(.completed)
  }
  
  // MARK: public api
  
  /// Ends searching
  func endSearch() {
    textField.resignFirstResponder()
    activeObserver.on(.next(false))
    activeButton.isHidden = false
    menuButton.isHidden = false
    backButton.isHidden = true
    searchTableView.dismiss()
  }
  
  // MARK: private api
  
  /// Designs view
  /// - Parameter parentView: parent view for presenting on
  private func designView(parentView: UIView) {
    frame = CGRect(x: 0, y: 0, width: parentView.frame.width, height: frame.size.height)
    textFieldBackgroundView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
    textFieldBackgroundView.layer.shadowColor = UIColor.black.cgColor
    textFieldBackgroundView.layer.shadowOpacity = 0.2
  }
  
  /// Binds view
  private func bindView() {
    activeButton.rx.tap
      .subscribe { [weak self] _ in
        self?.startSearch()
      }
      .disposed(by: disposeBag)
    menuButton.rx.tap
      .subscribe { [weak self] _ in
        if let self = self {
          self.tapMenuObserver.on(.next(self.menuButton))
        }
      }
      .disposed(by: disposeBag)
    backButton.rx.tap
      .subscribe { [weak self] _ in
        self?.endSearch()
      }
      .disposed(by: disposeBag)
    clearButton.rx.tap
      .subscribe { [weak self] _ in
        guard let self = self else {
          return
        }
        self.resetSearch()
      }
      .disposed(by: disposeBag)
    textField.rx.text.changed.asObservable()
      .subscribe { [weak self] event in
        guard let self = self, let text = event.element else {
          return
        }
        if text?.isEmpty ?? true {
          self.resetSearch()
        } else {
          self.clearButton.isHidden = false
        }
        self.textObserver.on(.next(text ?? ""))
        self.searchTableView.reloadsData()
      }
      .disposed(by: disposeBag)
    searchTableView.rx.itemSelected
      .subscribe { [weak self] event in
        if let self = self, let indexPath = event.element {
          self.tapItemObserver.on(.next(indexPath))
        }
      }
      .disposed(by: disposeBag)
  }
  
  /// Starts searching
  private func startSearch() {
    textField.becomeFirstResponder()
    activeObserver.on(.next(true))
    activeButton.isHidden = true
    menuButton.isHidden = true
    backButton.isHidden = false
    if let parentView = superview {
      searchTableView.present(on: parentView, searchView: self)
      parentView.bringSubviewToFront(self)
    }
  }
  
  /// Resets search
  private func resetSearch() {
    textField.text = ""
    spotImageView.image = nil
    clearButton.isHidden = true
    textObserver.on(.next(""))
  }
}

// MARK: - Reactive Extension
extension Reactive where Base: VGSearchView {
  // MARK: property
  
  var active: ControlEvent<Bool> {
    ControlEvent(events: base.activeObserver)
  }
  
  var text: ControlEvent<String> {
    ControlEvent(events: base.textObserver)
  }
  
  var tapMenu: ControlEvent<UIButton> {
    ControlEvent(events: base.tapMenuObserver)
  }
  
  var tapItem: ControlEvent<IndexPath> {
    ControlEvent(events: base.tapItemObserver)
  }
  
  func items<Sequence: Swift.Sequence, Source: ObservableType>(_ source: Source) -> (_ cellFactory: @escaping (UITableView, Int, Sequence.Element) -> UITableViewCell) -> Disposable where Source.Element == Sequence {
    base.searchTableView.rx.items(source)
  }
}

// MARK: - VGSearchViewFactory
typealias VGSearchViewFactory = (_ view: UIView) -> VGSearchView
