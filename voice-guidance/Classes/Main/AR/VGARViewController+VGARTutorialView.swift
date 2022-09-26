// MARK: - VGARViewController + VGARTutorialView
extension VGARViewController {
  
  // MARK: public api
  
  /// Calls when deiniting tutorial view
  /// - Parameter userDefaults: VGUserDefaults
  func cleanUpTutorialView(userDefaults: VGUserDefaults) {
    tutorialView?.removeFromSuperview()
    tutorialViewWillDisappearDisposable?.dispose()
    tutorialView = nil
    tutorialViewWillDisappearDisposable = nil
    userDefaults.set(true, forKey: VGUserDefaultsKey.doneARTutorial)
    _ = userDefaults.synchronize()
  }
  
  /// Presents tutorial view
  /// - Parameters:
  ///   - forced: forced to display
  ///   - userDefaults: VGUserDefaults
  func presentTutorialView(forced: Bool, userDefaults: VGUserDefaults) {
    if !forced && userDefaults.bool(forKey: VGUserDefaultsKey.doneARTutorial) {
      return
    }
    cleanUpTutorialView(userDefaults: userDefaults)
    tutorialView = VGARTutorialView(
      parentViewController: self,
      mapView: mapBackgroundView
    )
    guard let tutorialView else {
      return
    }
    view.addSubview(tutorialView)
    tutorialViewWillDisappearDisposable = tutorialView.rx.active
      .subscribe { [weak self] event in
        let active = event.element ?? true
        if !active {
          self?.cleanUpTutorialView(userDefaults: userDefaults)
        }
      }
  }
}
