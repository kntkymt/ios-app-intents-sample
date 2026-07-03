import Foundation
import Observation

/// Shared navigation state that bridges the app's `OpenIntent`s to ``RootView``.
///
/// The intents run outside of any view, so they record which ``AppScreen`` to
/// show (and, for notifications, which detail to push) here. ``RootView`` and
/// ``NotificationScreen`` observe this state and drive their navigation.
@MainActor
@Observable
final class AppNavigation {
    static let shared = AppNavigation()

    private init() {}

    /// The screen the app should currently display.
    var selectedScreen: AppScreen = .todo

    /// The navigation stack for the Notifications tab. Appending a
    /// ``Notification`` pushes its ``NotificationDetailScreen``.
    var notificationPath: [Notification] = []
}
