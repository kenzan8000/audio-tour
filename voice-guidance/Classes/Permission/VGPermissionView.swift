import UIKit
import RxCocoa
import RxSwift

// MARK: - VGPermissionView
class VGPermissionView: VGNibView {
  
  // MARK: property
  
  private let disposeBag = DisposeBag()
  
  let willDisappearObserver = PublishSubject<Bool>()
  
  private let viewModel: VGPermissionViewModel
  
  @IBOutlet private(set) weak var headingLable: UILabel!
  @IBOutlet private(set) weak var paragraphLable: UILabel!
  @IBOutlet private(set) weak var cameraPermissionView: UIView!
  @IBOutlet private(set) weak var cameraPermissionButton: UIButton!
  @IBOutlet private(set) weak var cameraPermissionStatusImageView: UIImageView!
  @IBOutlet private(set) weak var locationPermissionButton: UIButton!
  @IBOutlet private(set) weak var locationPermissionStatusImageView: UIImageView!

  // MARK: initializer
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  /// Inits
  /// - Parameters:
  ///   - viewModel: VGPermissionViewModel
  init(viewModel: VGPermissionViewModel) {
    self.viewModel = viewModel
    super.init(frame: .zero)
    designView()
    bindViewModel()
  }
  
  // MARK: destruction
  
  deinit {
    willDisappearObserver.on(.completed)
  }
  
  // MARK: private api
  
  /// Binds view model
  private func bindViewModel() {
    bindPermissionTypeEvent()
    bindCameraAuthorizationStatusEvent()
    bindLocationAuthorizationStatusEvent()
    bindButtonEvent()
  }
  
  /// Binds permission type event
  private func bindPermissionTypeEvent() {
    viewModel.permissionTypeEvent
      .subscribe { [weak self] event in
        guard let self = self, let permissionType = event.element else {
          return
        }
        switch permissionType {
        case .locationAndVideo, .video:
          self.cameraPermissionView.isHidden = false
        case .notNeeded:
          self.willDisappearObserver.on(.next(true))
        default:
          self.cameraPermissionView.isHidden = true
        }
      }
      .disposed(by: disposeBag)
  }
  
  /// Binds camera authorization event
  private func bindCameraAuthorizationStatusEvent() {
    viewModel.cameraAuthorizationStatusEvent
      .subscribe { [weak self] event in
        guard let self = self, let authorizationStatus = event.element else {
          return
        }
        switch authorizationStatus {
        case .denied, .restricted:
          self.cameraPermissionButton.isUserInteractionEnabled = true
          self.cameraPermissionButton.setTitleColor(.secondaryLabel, for: .normal)
          self.cameraPermissionButton.setTitle(NSLocalizedString("permission_camera_not_enabled", comment: ""), for: .normal)
          self.cameraPermissionStatusImageView.isHidden = true
        default:
          self.cameraPermissionButton.isUserInteractionEnabled = false
          self.cameraPermissionButton.setTitleColor(.systemBlue, for: .normal)
          self.cameraPermissionButton.setTitle(NSLocalizedString("permission_camera_enabled", comment: ""), for: .normal)
          self.cameraPermissionStatusImageView.isHidden = false
        }
      }
      .disposed(by: disposeBag)
  }
  
  /// Binds location authorization event
  private func bindLocationAuthorizationStatusEvent() {
    viewModel.locationAuthorizationStatusEvent
      .subscribe { [weak self] event in
        guard let self = self, let authorizationStatus = event.element else {
          return
        }
        switch authorizationStatus {
        case .denied, .restricted:
          self.locationPermissionButton.isUserInteractionEnabled = true
          self.locationPermissionButton.setTitleColor(.secondaryLabel, for: .normal)
          self.locationPermissionButton.setTitle(NSLocalizedString("permission_location_not_enabled", comment: ""), for: .normal)
          self.locationPermissionStatusImageView.isHidden = true
        default:
          self.locationPermissionButton.isUserInteractionEnabled = false
          self.locationPermissionButton.setTitleColor(.systemBlue, for: .normal)
          self.locationPermissionButton.setTitle(NSLocalizedString("permission_location_enabled", comment: ""), for: .normal)
          self.locationPermissionStatusImageView.isHidden = false
        }
      }
      .disposed(by: disposeBag)
  }
  
  /// Binds button event
  private func bindButtonEvent() {
    cameraPermissionButton.rx.tap
      .subscribe { [weak self] _ in self?.viewModel.openSettings() }
      .disposed(by: disposeBag)
    locationPermissionButton.rx.tap
      .subscribe { [weak self] _ in self?.viewModel.openSettings() }
      .disposed(by: disposeBag)
  }
  
  /// Designs view
  private func designView() {
    headingLable.text = NSLocalizedString("permission_title", comment: "")
    paragraphLable.text = NSLocalizedString("permission_subtitle", comment: "")
    cameraPermissionButton.imageView?.contentMode = .scaleAspectFit
    locationPermissionButton.imageView?.contentMode = .scaleAspectFit
    cameraPermissionButton.imageView?.tintColor = .secondaryLabel
    locationPermissionButton.imageView?.tintColor = .secondaryLabel
  }
  
}
  
// MARK: - Reactive Extension
extension Reactive where Base: VGPermissionView {
  var willDisappear: ControlEvent<Bool> {
    ControlEvent(events: base.willDisappearObserver)
  }
}
