import RxSwift
import UIKit

// MARK: - VGTutorialViewController
class VGTutorialViewController: UIViewController {
  
  // MARK: property
  
  private let disposeBag = DisposeBag()
  let viewModel: VGTutorialViewModel
  private var slideView: VGTutorialSlideView? {
    didSet {
      oldValue?.removeFromSuperview()
      if let slideView {
        slideBackgroundView.addSubview(slideView)
        slideView.frame = slideBackgroundView.bounds
      }
    }
  }
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
    slideView = nil
  }

  // MARK: life cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.frame = UIScreen.main.bounds
    
    viewModel.slideEvent
      .subscribe { [weak self] event in
        guard let self, let slide = event.element else {
          return
        }
        self.pageControl.currentPage = slide.currentPage
        if slide == .last {
          self.doneButton.setTitle(NSLocalizedString("tutorial_button_end", comment: ""), for: .normal)
        }
      }
      .disposed(by: disposeBag)
    
    doneButton.rx.tap
      .subscribe { [weak self] _ in self?.viewModel.presentNextView() }
      .disposed(by: disposeBag)
  }
  
  // MARK: public api
  
  func presentSlideView(_ slideView: VGTutorialSlideView) {
    self.slideView = slideView
  }
}

// MARK: - VGTutorialViewControllerFactory
typealias VGTutorialViewControllerFactory = () -> VGTutorialViewController
