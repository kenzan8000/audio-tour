import UIKit

// MARK: - VGSearchTableViewCell
class VGSearchTableViewCell: VGNibTableViewCell {
  
  // MARK: property
  
  @IBOutlet private(set) weak var iconImageView: UIImageView!
  @IBOutlet private(set) weak var titleLabel: UILabel!

  // MARK: initializer
  
  @available(*, unavailable)
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  /// Inits
  /// - Parameters:
  ///   - viewModel: VGSearchTableViewCellModel
  init(viewModel: VGSearchTableViewCellModel) {
    super.init(
      style: .default,
      reuseIdentifier: nil
    )
    iconImageView.image = viewModel.image
    titleLabel.text = viewModel.title
  }
}
