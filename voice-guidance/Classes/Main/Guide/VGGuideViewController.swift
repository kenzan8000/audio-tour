import MarkdownView
import MediaPlayer
import PullUpController
import RxSwift
import RxCocoa
import UIKit
import VYPlayIndicator

// MARK: - VGGuideViewController
class VGGuideViewController: PullUpController {
  
  // MARK: constant
  private let cornerRadius = CGFloat(20.0)
  private let shadowOpacity = Float(0.20)
  
  // MARK: property
  
  private let disposeBag = DisposeBag()
  
  var guideViewModel: VGGuideViewModel!
  let alertControllerObserver = PublishSubject<UIAlertController>()

  @IBOutlet private(set) weak var guideView: UIView!
  @IBOutlet private(set) weak var visualEffectView: UIVisualEffectView!
  @IBOutlet private(set) weak var titleLabel: UILabel!
  @IBOutlet private(set) weak var playIndicatorView: UIView!
  private var guideBodyView = MarkdownView()
  @IBOutlet private(set) weak var guideControlView: UIView!
  @IBOutlet private(set) weak var progressSlider: VGGuideProgressSlider!
  @IBOutlet private(set) weak var rateButton: UIButton!
  @IBOutlet private(set) weak var playButton: UIButton!
  @IBOutlet private(set) weak var openButton: UIButton!
  @IBOutlet private(set) weak var volumeImageView: UIImageView!
  @IBOutlet private(set) weak var volumeBackgroundView: UIView!
  
  private lazy var volumeView: MPVolumeView = {
    let volumeView = MPVolumeView(
      frame: CGRect(x: 0, y: 0, width: volumeBackgroundView.frame.width, height: volumeBackgroundView.frame.height)
    )
    volumeView.showsVolumeSlider = true
    return volumeView
  }()
  
  private lazy var playIndicator: VYPlayIndicator = {
    let indicator = VYPlayIndicator()
    indicator.frame = CGRect(x: 0, y: 0, width: playIndicatorView.frame.width, height: playIndicatorView.frame.height)
    return indicator
  }()
  
  var pullUpModel: VGGuidePullUpModel
  override var pullUpControllerMiddleStickyPoints: [CGFloat] {
    pullUpModel.pullUpControllerMiddleStickyPoints
  }
  override var pullUpControllerPreferredSize: CGSize {
    pullUpModel.pullUpControllerPreferredSize
  }
  
  // MARK: initializer
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  /// Inits guide view controller
  /// - Parameter viewModel: VGGuideViewModel
  /// - Parameter pullUpModel: VGGuidePullUpModel
  init(viewModel: VGGuideViewModel, pullUpModel: VGGuidePullUpModel) {
    self.pullUpModel = pullUpModel
    guideViewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  // MARK: destruction
  
  deinit {
    guideViewModel.stopTts()
    alertControllerObserver.on(.completed)
    guideBodyView.removeFromSuperview()
    volumeView.removeFromSuperview()
    playIndicator.state = .stopped
    playIndicator.removeFromSuperlayer()
  }

  // MARK: life cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    designView()
    bindViewModel()
    bindView()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    guideViewModel.initNotification()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    guideViewModel.deinitNotification()
    guideViewModel.pauseTts()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    let parentWidth = (parent?.view.frame.width ?? view.frame.width)
    let parentHeight = (parent?.view.frame.height ?? view.frame.height)
    guideView.frame = CGRect(
      x: 0,
      y: 0,
      width: parentWidth,
      height: parentHeight - (parent?.view.safeAreaInsets.top ?? 0) - (parent?.view.safeAreaInsets.bottom ?? 0) + cornerRadius
    )
    let guideBodyViewY = titleLabel.frame.origin.y + titleLabel.frame.height
    guideBodyView.frame = CGRect(
      x: 0,
      y: guideBodyViewY,
      width: parentWidth,
      height: guideControlView.frame.origin.y - guideBodyViewY
    )
  }
  
  // MARK: Open methods
  
  /// called before the pull up controller's view move to a point.
  /// - Parameter point: The target point, expressed in the pull up controller coordinate system
  override func pullUpControllerWillMove(to point: CGFloat) {
    if let parentView = view.superview {
      parentView.bringSubviewToFront(view)
    }
  }
  
  /// called after the pull up controller's view move to a point.
  /// - Parameter point: The target point, expressed in the pull up controller coordinate system
  override func pullUpControllerDidMove(to point: CGFloat) {
    if point <= pullUpModel.bottomY {
      dismissGuideViewController()
    }
  }

  // MARK: public api
  
  /// present guide view controller
  /// - Parameters:
  ///   - vc: view controller under guide view controller
  ///   - animated: if animated
  func presentGuideViewController(on vc: UIViewController, animated: Bool) {
    pullUpModel = VGGuidePullUpModel(bottomSafeAreaInset: vc.view.safeAreaInsets.bottom, peekY: vc.view.frame.height - vc.view.safeAreaInsets.top)
    vc.addPullUpController(
      self,
      initialStickyPointOffset: pullUpModel.peekY,
      animated: animated
    )
  }
  
  /// dismiss guide view controller
  func dismissGuideViewController() {
    if guideViewModel.ttsIsSpeaking {
      guideViewModel.stopTts()
    }
  }
  
  /// Returns if the point is in view
  /// - Parameter point: CGPoint
  /// - Returns: Bool
  func isOnView(point: CGPoint) -> Bool {
    view.frame.contains(point)
  }
  
  // MARK: private api
  
  /// Design view
  private func designView() {
    view.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
    view.layer.shadowColor = UIColor.black.cgColor
    view.layer.shadowOpacity = shadowOpacity
    view.layer.shadowPath = UIBezierPath(
      roundedRect: CGRect(x: view.bounds.origin.x, y: view.bounds.origin.y, width: view.bounds.width, height: cornerRadius),
      cornerRadius: cornerRadius
    ).cgPath
    guideView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    visualEffectView.layer.cornerRadius = cornerRadius
    visualEffectView.layer.masksToBounds = true
    titleLabel.text = guideViewModel.spotName
    view.addSubview(guideBodyView)
    guideBodyView.load(markdown: guideViewModel.spotBody)
    playButton.setImage(
      UIImage(systemName: "play.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 20)),
      for: .normal
    )
    playButton.tintColor = .secondaryLabel
    playIndicatorView.layer.addSublayer(playIndicator)
    view.bringSubviewToFront(playIndicatorView)
    volumeBackgroundView.addSubview(volumeView)
    volumeImageView.image = UIImage(
      systemName: "speaker.fill",
      withConfiguration: UIImage.SymbolConfiguration(pointSize: 26)
    )?
      .withRenderingMode(.alwaysTemplate)
      .tint(color: .systemGray)
    openButton.setImage(
      UIImage(systemName: "ellipsis", withConfiguration: UIImage.SymbolConfiguration(pointSize: 20)),
      for: .normal
    )
    openButton.tintColor = .systemBlue
  }
  
  /// Binds view model
  private func bindViewModel() {
    guideViewModel.ttsRateEvent
      .subscribe { [weak self] _ in
        self?.rateButton.setTitle(
          self?.guideViewModel.ttsRateTitle,
          for: .normal
        )
      }
      .disposed(by: disposeBag)
    guideViewModel.ttsIsSpeakingEvent
      .subscribe { [weak self] event in
        var icon = "play.fill"
        if let ttsIsSpeaking = event.element, ttsIsSpeaking {
          icon = "pause.fill"
          self?.playIndicator.state = .playing
        } else {
          self?.playIndicator.state = .stopped
        }
        self?.playButton.setImage(
          UIImage(systemName: icon, withConfiguration: UIImage.SymbolConfiguration(pointSize: 20)),
          for: .normal
        )
        self?.playButton.tintColor = .secondaryLabel
      }
      .disposed(by: disposeBag)
    guideViewModel.ttsProgressEvent
      .subscribe { [weak self] event in
        guard let progress = event.element else {
          return
        }
        self?.progressSlider.setProgress(progress, animated: true)
      }
      .disposed(by: disposeBag)
  }
  
  /// Bind view
  private func bindView() {
    playButton.rx.tap
      .subscribe { [weak self] _ in
        if self?.guideViewModel.ttsIsSpeaking ?? true {
          self?.guideViewModel.pauseTts()
        } else {
          self?.guideViewModel.playTts()
        }
      }
      .disposed(by: disposeBag)
    rateButton.rx.tap
      .subscribe { [weak self] _ in self?.guideViewModel.toggleTtsRate() }
      .disposed(by: disposeBag)
    openButton.rx.tap
      .subscribe { [weak self] _ in
        guard let self = self else {
          return
        }
        let alertController: UIAlertController = .guide(
          title: self.guideViewModel.spotName,
          message: nil,
          preferredStyle: .actionSheet,
          coordinate: self.guideViewModel.spotCoordinate
        )
        self.alertControllerObserver.on(.next(alertController))
      }
      .disposed(by: disposeBag)
    progressSlider.rx.value
      .subscribe { [weak self] event in
        if let value = event.element {
          self?.guideViewModel.updateTtsProgress(value)
        }
      }
      .disposed(by: disposeBag)
  }
}

// MARK: - Reactive Extension
extension Reactive where Base: VGGuideViewController {
  // MARK: property
  var alertWillAppear: ControlEvent<UIAlertController> {
    ControlEvent(events: base.alertControllerObserver)
  }
}
