import RxSwift
import UIKit

// MARK: - VGTutorialViewController
class VGTutorialViewController: UIViewController {
  
  // MARK: property
  
  private let disposeBag = DisposeBag()
  private let viewModel: VGTutorialViewModel
  private var slideView: VGTutorialSlideView?
  @IBOutlet private(set) weak var slideBackgroundView: UIView!
  @IBOutlet private(set) weak var pageControl: UIPageControl!
  @IBOutlet private(set) weak var doneButton: UIButton!
  
  // MARK: initializer
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  /// Inits
  /// - Parameter viewModel: VGTutorialViewModel
  init(viewModel: VGTutorialViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  // MARK: destruction
  
  deinit {
    slideView?.removeFromSuperview()
  }

  // MARK: life cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.frame = UIScreen.main.bounds
    observeViewModel()
    bindView()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
  }
  
  // MARK: public api
  
  /// Presents view
  /// - Parameter view: Updates the tutorial scene by the view value (VGTutorialView)
  func present(_ tutorial: VGTutorial) {
    slideView?.removeFromSuperview()
    pageControl.currentPage = tutorial.currentPage
    doneButton.setTitle(NSLocalizedString("tutorial_button_next", comment: ""), for: .normal)
    switch tutorial {
    case .intro:
      presentIntro()
    case .map:
      presentMap()
    case .ar:
      presentAr()
    case .last:
      doneButton.setTitle(NSLocalizedString("tutorial_button_end", comment: ""), for: .normal)
      presentEnd()
    case .end:
      NotificationCenter.default.post(name: .startMain, object: nil)
      return
    }
    if let slideView = slideView {
      slideBackgroundView.addSubview(slideView)
      slideView.frame = slideBackgroundView.bounds
    }
  }
  
  // MARK: private api
  
  /// Init view model settings
  private func observeViewModel() {
    viewModel.tutorialEvent
      .subscribe { [weak self] event in
        guard let self = self, let view = event.element else {
          return
        }
        self.present(view)
      }
      .disposed(by: disposeBag)
  }
  
  /// Binds view
  private func bindView() {
    doneButton.rx.tap
      .subscribe { [weak self] _ in
        self?.viewModel.nextView()
      }
      .disposed(by: disposeBag)
  }
  
  /// Presents intro tutorial view
  private func presentIntro() {
    slideView = VGTutorialSlideView(
      heading: NSLocalizedString("tutorial_title_01", comment: ""),
      paragraph: NSLocalizedString("tutorial_body_01", comment: ""),
      scenaryImage: UIImage(named: "tutorial_scenary_01"),
      tutorialImage: nil
    )
  }
  
  /// Presents map tutorial view
  private func presentMap() {
    slideView = VGTutorialSlideView(
      heading: NSLocalizedString("tutorial_title_02", comment: ""),
      paragraph: NSLocalizedString("tutorial_body_02", comment: ""),
      scenaryImage: UIImage(named: "tutorial_scenary_02"),
      tutorialImage: UIImage(named: "tutorial_02")
    )
  }
  
  /// Presents ar tutorial view
  private func presentAr() {
    slideView = VGTutorialSlideView(
      heading: NSLocalizedString("tutorial_title_03", comment: ""),
      paragraph: NSLocalizedString("tutorial_body_03", comment: ""),
      scenaryImage: UIImage(named: "tutorial_scenary_03"),
      tutorialImage: UIImage(named: "tutorial_03")
    )
  }
  
  /// Presents end tutorial view
  private func presentEnd() {
    slideView = VGTutorialSlideView(
      heading: NSLocalizedString("tutorial_title_04", comment: ""),
      paragraph: NSLocalizedString("tutorial_body_04", comment: ""),
      scenaryImage: UIImage(named: "tutorial_scenary_04"),
      tutorialImage: nil
    )
  }
}

// MARK: - VGTutorialViewControllerFactory
typealias VGTutorialViewControllerFactory = () -> VGTutorialViewController
