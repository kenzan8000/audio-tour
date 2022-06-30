import MarkdownView
import UIKit

// MARK: - MarkdownView + Scroll
extension MarkdownView {
  func enableScrollIfContentHeightIsGreaterThanHeight(contentHeight: CGFloat? = nil) {
    isScrollEnabled = (contentHeight ?? intrinsicContentSize.height) > frame.height
  }
}
