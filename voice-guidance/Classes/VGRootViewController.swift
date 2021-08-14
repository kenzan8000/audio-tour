// MARK: - VGRootViewController
class VGRootViewController: VGNiblessViewController {
  // MARK: properties
  
  let viewModel: VGRootViewModel
  
  // MARK: initializer
  
  /// Inits
  /// - Parameters:
  ///   - viewModel: rootViewModel
  init(viewModel: VGRootViewModel) {
    self.viewModel = viewModel
    super.init()
  }
}
