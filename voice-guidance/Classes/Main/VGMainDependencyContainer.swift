// MARK: - VGMainDependencyContainer
class VGMainDependencyContainer {
  /// Creates VGMainViewController
  /// - Parameters:
  ///   - mapDependencyContainer: VGMapDependencyContainer
  ///   - arDependencyContainer: VGARDependencyContainer
  ///   - locationManagerFactory: VGLocationManagerFactory
  ///   - userDefaults: VGUserDefaults
  ///   - storageProvider: VGStorageProvider
  /// - Returns: VGMainViewController
  func makeMainViewController(
    mapDependencyContainer: VGMapDependencyContainer,
    arDependencyContainer: VGARDependencyContainer,
    userDefaults: VGUserDefaults,
    storageProvider: VGStorageProvider,
    locationManagerFactory: @escaping VGLocationManagerFactory
  ) -> VGMainViewController {
    VGMainViewController(viewControllers: [
      VGMapViewController(
        viewModel: VGMapViewModel(storageProvider: storageProvider),
        userDefaults: userDefaults,
        mapViewFactory: { view in mapDependencyContainer.makeMapView(on: view) },
        searchViewFactory: { view in mapDependencyContainer.makeSearchView(on: view) }
      ),
      VGARViewController(
        viewModel: VGARViewModel(storageProvider: storageProvider, locationManager: locationManagerFactory()),
        userDefaults: userDefaults,
        locationManagerFactory: locationManagerFactory,
        mapViewFactory: { view in arDependencyContainer.makeMapView(on: view) },
        searchViewFactory: { view in arDependencyContainer.makeSearchView(on: view) }
      )
    ])
  }
}
