import UIKit

// MARK: - VGSideMenuTableViewCell
class VGSideMenuTableViewCell: VGNibTableViewCell {
  
  // MARK: property
  
  @IBOutlet private(set) weak var titleLabel: UILabel!
  private let viewModel: VGSideMenuTableViewCellModel

  // MARK: initializer
  
  @available(*, unavailable)
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  /// Inits
  /// - Parameters:
  ///   - viewModel: VGSideMenuTableViewCellModel
  init(viewModel: VGSideMenuTableViewCellModel) {
    self.viewModel = viewModel
    super.init(
      style: .default,
      reuseIdentifier: nil
    )
    titleLabel.text = viewModel.title
  }
}
