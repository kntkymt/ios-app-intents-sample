import Foundation
import Observation

/// Shared navigation state that bridges ``OpenAppIntent`` to ``RootView``.
///
/// The intent runs outside of any view, so it records which ``AppScreen`` to
/// show here. ``RootView`` observes ``selectedScreen`` and selects the matching
/// tab in its `TabView`.
@MainActor
@Observable
final class AppNavigation {
    static let shared = AppNavigation()

    private init() {}

    /// The screen the app should currently display.
    var selectedScreen: AppScreen = .todo
}
