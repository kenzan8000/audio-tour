import UIKit

// MARK: - VGNibTableViewCell
class VGNibTableViewCell: UITableViewCell {
  
  // MARK: property

  @IBOutlet weak var tableViewCell: UITableViewCell!
  
  // MARK: initializer
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setUpNib()
  }
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setUpNib()
  }
  
  // MARK: public api
  
  override func prepareForInterfaceBuilder() {
    super.prepareForInterfaceBuilder()
    setUpNib()
    tableViewCell?.prepareForInterfaceBuilder()
  }
  
  // MARK: private api
  
  /// Sets up nib
  private func setUpNib() {
    backgroundColor = .clear
      
    tableViewCell = loadTableViewCellFromNib()
    self.frame = tableViewCell.frame
    tableViewCell.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    tableViewCell.translatesAutoresizingMaskIntoConstraints = true
      
    addSubview(tableViewCell)
    tableViewCell.anchorAllEdgesToSuperview()
  }
  
  /// Loads view from nib
  /// - Returns: tableViewCell
  private func loadTableViewCellFromNib() -> UITableViewCell? {
    let bundle = Bundle(for: type(of: self))
    let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
    let nibTableViewCell = nib.instantiate(withOwner: self, options: nil).first as? UITableViewCell
    return nibTableViewCell
  }
}
