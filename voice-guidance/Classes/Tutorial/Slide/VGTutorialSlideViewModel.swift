import UIKit

// MARK: - VGTutorialSlideViewModel
struct VGTutorialSlideViewModel {
  
  // MARK: static constant
  
  static let intro = VGTutorialSlideViewModel(
    heading: NSLocalizedString("tutorial_title_01", comment: ""),
    paragraph: NSLocalizedString("tutorial_body_01", comment: ""),
    scenaryImage: UIImage(named: "tutorial_scenary_01"),
    tutorialImage: nil
  )
  static let map = VGTutorialSlideViewModel(
    heading: NSLocalizedString("tutorial_title_02", comment: ""),
    paragraph: NSLocalizedString("tutorial_body_02", comment: ""),
    scenaryImage: UIImage(named: "tutorial_scenary_02"),
    tutorialImage: UIImage(named: "tutorial_02")
  )
  static let ar = VGTutorialSlideViewModel(
    heading: NSLocalizedString("tutorial_title_03", comment: ""),
    paragraph: NSLocalizedString("tutorial_body_03", comment: ""),
    scenaryImage: UIImage(named: "tutorial_scenary_03"),
    tutorialImage: UIImage(named: "tutorial_03")
  )
  static let last = VGTutorialSlideViewModel(
    heading: NSLocalizedString("tutorial_title_04", comment: ""),
    paragraph: NSLocalizedString("tutorial_body_04", comment: ""),
    scenaryImage: UIImage(named: "tutorial_scenary_04"),
    tutorialImage: nil
  )
  
  // MARK: property
  
  let heading: String
  let paragraph: String
  let scenaryImage: UIImage?
  let tutorialImage: UIImage?
}
