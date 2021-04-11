import Instructions
import UIKit
import RxCocoa
import RxSwift

// MARK: - VGARTutorial
enum VGARTutorial: Int {
  case start = 0
  case map = 1
  case end = 2
}
let VGARTutorialNumber = 3

// MARK: - VGARTutorialView
class VGARTutorialView: VGNibView, CoachMarksControllerDataSource, CoachMarksControllerDelegate {
  
  // MARK: property
  
  private let disposeBag = DisposeBag()
  
  let activeObserver = PublishSubject<Bool>()
  
  @IBOutlet private(set) weak var imageView: UIImageView!
  private var coachMarksController: CoachMarksController
  private weak var mapView: UIView?
  
  // MARK: initializer
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  /// Inits
  /// - Parameters:
  ///   - parentViewController: UIViewController
  ///   - mapView: UIView
  init(parentViewController: UIViewController, mapView: UIView) {
    coachMarksController = CoachMarksController()
    self.mapView = mapView
    super.init(frame: .zero)
    frame = parentViewController.view.bounds
    coachMarksController.overlay.isUserInteractionEnabled = true
    coachMarksController.dataSource = self
    coachMarksController.delegate = self
    coachMarksController.start(in: .currentWindow(of: parentViewController))
  }
  
  // MARK: destruction
  
  deinit {
    activeObserver.on(.completed)
  }
  
  // MARK: CoachMarksControllerDataSource
  
  func numberOfCoachMarks(for coachMarksController: CoachMarksController) -> Int { VGARTutorialNumber }
  
  func coachMarksController(
    _ coachMarksController: CoachMarksController,
    coachMarkAt index: Int
  ) -> CoachMark {
    var pointOfInterest: UIView?
    switch VGARTutorial(rawValue: index) {
    case .start:
      pointOfInterest = imageView
    case .map:
      pointOfInterest = mapView
    case .end:
      pointOfInterest = mapView
    default:
      break
    }
    return coachMarksController.helper.makeCoachMark(for: pointOfInterest ?? UIView())
  }
  
  func coachMarksController(
    _ coachMarksController: CoachMarksController,
    coachMarkViewsAt index: Int,
    madeFrom coachMark: CoachMark
  ) -> (bodyView: UIView & CoachMarkBodyView, arrowView: (UIView & CoachMarkArrowView)?) {
    let coachViews = coachMarksController.helper.makeDefaultCoachViews(
      withArrow: true,
      arrowOrientation: coachMark.arrowOrientation
    )
    coachViews.bodyView.isUserInteractionEnabled = false
    coachViews.bodyView.background.innerColor = .systemBackground
    coachViews.bodyView.background.borderColor = .secondarySystemBackground
    coachViews.bodyView.hintLabel.textColor = .label
    switch index {
    case 0:
      coachViews.bodyView.hintLabel.text = NSLocalizedString("ar_tutorial_0", comment: "")
    case 1:
      coachViews.bodyView.hintLabel.text = NSLocalizedString("ar_tutorial_1", comment: "")
    case 2:
      coachViews.bodyView.hintLabel.text = NSLocalizedString("ar_tutorial_2", comment: "")
    default:
      coachViews.bodyView.hintLabel.text = ""
    }
    coachViews.bodyView.nextLabel.isHidden = true
    coachViews.bodyView.separator.isHidden = true
    coachViews.arrowView?.background.innerColor = .systemBackground
    return (bodyView: coachViews.bodyView, arrowView: coachViews.arrowView)
  }
  
  // MARK: CoachMarksControllerDelegate
  
  func coachMarksController(
    _ coachMarksController: CoachMarksController,
    didShow coachMark: CoachMark,
    afterChanging change: ConfigurationChange,
    at index: Int
  ) {
    imageView.isHidden = true
    switch VGARTutorial(rawValue: index) {
    case .start:
      imageView.isHidden = false
      activeObserver.on(.next(true))
    case .map:
      break
    case .end:
      break
    default:
      break
    }
  }
  
  func coachMarksController(
    _ coachMarksController: CoachMarksController,
    didHide coachMark: CoachMark,
    at index: Int
  ) {
    var done = false
    switch VGARTutorial(rawValue: index) {
    case .start:
      break
    case .map:
      break
    case .end:
      done = true
    default:
      done = true
    }
    if done {
      coachMarksController.stop(immediately: true)
      activeObserver.on(.next(false))
    }
  }
}

// MARK: - Reactive Extension
extension Reactive where Base: VGARTutorialView {
  // MARK: property
  
  var active: ControlEvent<Bool> {
    ControlEvent(events: base.activeObserver)
  }
}
