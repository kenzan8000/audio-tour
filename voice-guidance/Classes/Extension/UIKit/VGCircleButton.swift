import UIKit
import RxCocoa
import RxSwift

// MARK: - VGCircleButton
class VGCircleButton: VGNibView {
  
  // MARK: property
  
  private let disposeBag = DisposeBag()
  
  @IBOutlet private(set) weak var button: UIButton!
  @IBOutlet private(set) weak var buttonBackgroundView: UIView!

  // MARK: initializer
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  /// Inits with button image
  /// - Parameter image: button image
  init(image: UIImage?) {
    super.init(frame: .zero)
    button.setImage(image, for: .normal)
    designView()
  }
  
  // MARK: private api
  
  /// Design view
  private func designView() {
    buttonBackgroundView.layer.cornerRadius = buttonBackgroundView.frame.size.width / 2.0
    buttonBackgroundView.layer.masksToBounds = false
      
    buttonBackgroundView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
    buttonBackgroundView.layer.shadowColor = UIColor.black.cgColor
    buttonBackgroundView.layer.shadowOpacity = 0.2
    let offset = CGFloat(0.0)
    let rect = CGRect(
      x: -offset,
      y: -offset,
      width: bounds.width + offset * 2.0,
      height: bounds.height + offset * 2.0
    )
    buttonBackgroundView.layer.shadowPath = UIBezierPath(
      roundedRect: rect,
      cornerRadius: buttonBackgroundView.frame.size.width / 2.0
    ).cgPath
      
    button.layer.cornerRadius = buttonBackgroundView.frame.size.width / 2.0
    button.layer.masksToBounds = false
    button.layer.borderColor = UIColor.gray.cgColor
    button.layer.borderWidth = 0.5
    button.clipsToBounds = true
  }
  
}

// MARK: - Reactive Extension
extension Reactive where Base: VGCircleButton {
  var tap: ControlEvent<Void> {
    .init(events: base.button.rx.tap)
  }
}
