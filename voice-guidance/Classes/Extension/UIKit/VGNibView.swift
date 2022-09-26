import UIKit

// MARK: - VGNibView
class VGNibView: UIView {
  
  // MARK: property

  @IBOutlet weak var view: UIView!
  
  // MARK: initializer
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setUpNib()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setUpNib()
  }
  
  // MARK: public api
  
  override func prepareForInterfaceBuilder() {
    super.prepareForInterfaceBuilder()
    setUpNib()
    view?.prepareForInterfaceBuilder()
  }
  
  // MARK: private api
  
  /// Sets up nib
  private func setUpNib() {
    backgroundColor = .clear
      
    view = loadViewFromNib()
    self.frame = view.frame
    view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    view.translatesAutoresizingMaskIntoConstraints = true
      
    addSubview(view)
    view.anchorAllEdgesToSuperview()
  }
  
  /// Loads view from nib
  /// - Returns: view
  private func loadViewFromNib() -> UIView? {
    let bundle = Bundle(for: type(of: self))
    let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
    let nibView = nib.instantiate(withOwner: self, options: nil).first as? UIView
      
    return nibView
  }
}

extension UIView {
  
  func anchorAllEdgesToSuperview() {
    self.translatesAutoresizingMaskIntoConstraints = false
    if #available(iOS 9.0, *) {
      if let superview {
        addSuperviewConstraint(constraint: topAnchor.constraint(equalTo: (superview.topAnchor)))
        addSuperviewConstraint(constraint: leftAnchor.constraint(equalTo: (superview.leftAnchor)))
        addSuperviewConstraint(constraint: bottomAnchor.constraint(equalTo: (superview.bottomAnchor)))
        addSuperviewConstraint(constraint: rightAnchor.constraint(equalTo: (superview.rightAnchor)))
      }
    } else {
      for attribute: NSLayoutConstraint.Attribute in [.left, .top, .right, .bottom] {
        anchorToSuperview(attribute: attribute)
      }
    }
  }

  func anchorToSuperview(attribute: NSLayoutConstraint.Attribute) {
    addSuperviewConstraint(constraint: NSLayoutConstraint(item: self, attribute: attribute, relatedBy: .equal, toItem: superview, attribute: attribute, multiplier: 1.0, constant: 0.0))
  }

  func addSuperviewConstraint(constraint: NSLayoutConstraint) {
    superview?.addConstraint(constraint)
  }
  
}
