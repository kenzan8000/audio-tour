import UIKit

// MARK: - VGTestingRootViewController
class VGTestingRootViewController: UIViewController {

  // MARK: - life cycle
  
  override func loadView() {
    let label = UILabel()
    label.text = "Running Unit Tests..."
    label.textAlignment = .center
    label.textColor = .white
    view = label
  }
}
