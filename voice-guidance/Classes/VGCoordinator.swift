import Foundation
import RxSwift

// MARK: - VGCoordinator
/// Base abstract coordinator generic over the return type of the `start` method.
class VGCoordinator<ResultType> {

  /// Typealias which will allows to access a ResultType of the Coordainator by `CoordinatorName.CoordinationResult`.
  typealias CoordinationResult = ResultType
  
  // MARK: property

  /// Utility `DisposeBag` used by the subclasses.
  let disposeBag = DisposeBag()

  /// Unique identifier.
  private let identifier = UUID()

  /// Dictionary of the child coordinators. Every child coordinator should be added
  /// to that dictionary in order to keep it in memory.
  /// Key is an `identifier` of the child coordinator and value is the coordinator itself.
  /// Value type is `Any` because Swift doesn't allow to store generic types in the array.
  private var childCoordinators = [UUID: Any]()
  
  // MARK: public api

  /// Starts job of the coordinator.
  ///
  /// - Returns: Result of coordinator job.
  // swiftlint:disable unavailable_function
  func start() -> Observable<ResultType> {
    fatalError("Start method should be implemented.")
  }
  // swiftlint:enable unavailable_function
  
  /// 1. Stores coordinator in a dictionary of child coordinators.
  /// 2. Calls method `start()` on that coordinator.
  /// 3. On the `onNext:` of returning observable of method `start()` removes coordinator from the dictionary.
  ///
  /// - Parameter coordinator: Coordinator to start.
  /// - Returns: Result of `start()` method.
  func coordinate<T>(to coordinator: VGCoordinator<T>) -> Observable<T> {
    store(coordinator: coordinator)
    return coordinator
      .start()
      .do { [weak self] _ in self?.free(coordinator: coordinator) }
  }

  // MARK: private api
  
  /// Stores coordinator to the `childCoordinators` dictionary.
  ///
  /// - Parameter coordinator: Child coordinator to store.
  private func store<T>(coordinator: VGCoordinator<T>) {
    childCoordinators[coordinator.identifier] = coordinator
  }

  /// Release coordinator from the `childCoordinators` dictionary.
  ///
  /// - Parameter coordinator: Coordinator to release.
  private func free<T>(coordinator: VGCoordinator<T>) {
    childCoordinators[coordinator.identifier] = nil
  }
}
