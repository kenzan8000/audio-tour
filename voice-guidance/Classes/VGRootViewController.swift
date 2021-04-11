import RxSwift

// MARK: - VGRootViewController
class VGRootViewController: VGNiblessViewController {
  // MARK: properties
  
  let disposeBag = DisposeBag()
  let viewModel: VGRootViewModel
  let tutorialViewControllerFactory: VGTutorialViewControllerFactory
  let mainViewControllerFactory: VGMainViewControllerFactory
  
  // MARK: initializer
  
  /// Inits
  /// - Parameters:
  ///   - viewModel: rootViewModel
  ///   - tutorialViewControllerFactory: tutorialViewControllerFactory
  ///   - mainViewControllerFactory: mainViewControllerFactory
  init(
    viewModel: VGRootViewModel,
    tutorialViewControllerFactory: @escaping VGTutorialViewControllerFactory,
    mainViewControllerFactory: @escaping VGMainViewControllerFactory
  ) {
    self.viewModel = viewModel
    self.tutorialViewControllerFactory = tutorialViewControllerFactory
    self.mainViewControllerFactory = mainViewControllerFactory
    super.init()
  }
  
  // MARK: life cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    observeViewModel()
  }
  
  // MARK: public api
  
  /// Presents view
  /// - Parameter view: Updates the scene by the view value (VGRootView)
  func present(_ view: VGRootView) {
    switch view {
    case .tutorial:
      presentTutorial()
    case .main:
      presentMain()
    }
  }
  
  // MARK: private api
  
  /// Init view model settings
  private func observeViewModel() {
    subscribe(to: viewModel.viewSubject)
  }
  
  /// Subscribes observable
  /// - Parameter observable: Observable<VGRootView>
  private func subscribe(to observable: Observable<VGRootView>) {
    observable
      .subscribe { [weak self] event in
        guard let self = self, let view = event.element else {
          return
        }
        self.present(view)
      }
      .disposed(by: disposeBag)
  }
  
  /// Presents tutorial root view
  private func presentTutorial() {
    children.forEach { remove(childViewController: $0) }
    addFullScreen(childViewController: tutorialViewControllerFactory())
  }
  
  /// Presents main root view
  private func presentMain() {
    children.forEach { remove(childViewController: $0) }
    addFullScreen(childViewController: mainViewControllerFactory())
  }
}
