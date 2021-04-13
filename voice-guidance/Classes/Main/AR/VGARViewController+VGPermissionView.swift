// MARK: - VGARViewController + VGPermissionView
extension VGARViewController {
  
  // MARK: public api
  
  /// Calls when deiniting permission view
  func cleanUpPermissionView() {
    permissionView?.removeFromSuperview()
    permissionViewWillDisappearDisposable?.dispose()
    permissionView = nil
    permissionViewWillDisappearDisposable = nil
  }
  
  /// Presents permission view
  func presentPermissionView(locationManagerFactory: @escaping VGLocationManagerFactory) {
    permissionView = VGPermissionView(
      viewModel: VGPermissionViewModel(
        permissionType: .locationAndVideo,
        locationManager: locationManagerFactory(),
        captureDevice: VGAVCaptureDevice()
      )
    )
    if let permissionView = permissionView {
      permissionView.frame = view.frame
      view.addSubview(permissionView)
      permissionViewWillDisappearDisposable = permissionView.rx.willDisappear
        .subscribe { [weak self] _ in self?.cleanUpPermissionView() }
    }
  }
}
