import UIKit

// MARK: - VGSideMenuTableViewCell
class VGSideMenuTableViewCell: VGNibTableViewCell {
  
  // MARK: property
  
  @IBOutlet private(set) weak var titleLabel: UILabel!

  // MARK: initializer
  
  @available(*, unavailable)
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  /// Inits
  /// - Parameters:
  ///   - image: icon image
  init(title: String) {
    super.init(
      style: .default,
      reuseIdentifier: nil
    )
    titleLabel.text = title
  }
}
