import UIKit
import RxCocoa
import RxSwift
  
// MARK: - VGTutorialSlideView
class VGTutorialSlideView: VGNibView {
  
  // MARK: static constant
  
  static let intro = VGTutorialSlideView(
    heading: NSLocalizedString("tutorial_title_01", comment: ""),
    paragraph: NSLocalizedString("tutorial_body_01", comment: ""),
    scenaryImage: UIImage(named: "tutorial_scenary_01"),
    tutorialImage: nil
  )
  static let map = VGTutorialSlideView(
    heading: NSLocalizedString("tutorial_title_02", comment: ""),
    paragraph: NSLocalizedString("tutorial_body_02", comment: ""),
    scenaryImage: UIImage(named: "tutorial_scenary_02"),
    tutorialImage: UIImage(named: "tutorial_02")
  )
  static let ar = VGTutorialSlideView(
    heading: NSLocalizedString("tutorial_title_03", comment: ""),
    paragraph: NSLocalizedString("tutorial_body_03", comment: ""),
    scenaryImage: UIImage(named: "tutorial_scenary_03"),
    tutorialImage: UIImage(named: "tutorial_03")
  )
  static let last = VGTutorialSlideView(
    heading: NSLocalizedString("tutorial_title_04", comment: ""),
    paragraph: NSLocalizedString("tutorial_body_04", comment: ""),
    scenaryImage: UIImage(named: "tutorial_scenary_04"),
    tutorialImage: nil
  )
  
  // MARK: property
  
  @IBOutlet private(set) weak var headingLabel: UILabel!
  @IBOutlet private(set) weak var paragraphLabel: UILabel!
  @IBOutlet private(set) weak var scenaryImageView: UIImageView!
  @IBOutlet private(set) weak var tutorialImageView: UIImageView!

  // MARK: initializer
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  /// Inits
  /// - Parameters:
  ///   - heading: heading string
  ///   - paragraph: paragraph string
  ///   - scenaryImage: scenary image
  ///   - tutorialImage: tutorial  image or nil
  init(heading: String, paragraph: String, scenaryImage: UIImage?, tutorialImage: UIImage?) {
    super.init(frame: .zero)
    headingLabel.text = heading
    paragraphLabel.text = paragraph
    scenaryImageView.image = scenaryImage
    tutorialImageView.image = tutorialImage
    if let scenaryImage = scenaryImage {
      let height = UIScreen.main.bounds.width * scenaryImage.size.height / scenaryImage.size.width
      let bottom = scenaryImageView.frame.origin.y + scenaryImageView.frame.height
      scenaryImageView.frame = CGRect(
        x: 0, y: bottom - height, width: scenaryImageView.frame.width, height: height
      )
    }
  }
}
