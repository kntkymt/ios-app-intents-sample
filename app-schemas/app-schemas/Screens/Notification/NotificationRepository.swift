import Foundation

/// Provides the read-only system messages shown on ``NotificationScreen``.
///
/// Notifications originate from the system, so this repository only reads them.
/// For now it returns a fixed set of sample messages with stable identifiers.
actor NotificationRepository {
    /// Returns all system notifications.
    func getNotifications() -> [Notification] {
        [
            Notification(id: 1, title: "Welcome", description: "Thanks for installing the app."),
            Notification(id: 2, title: "Reminder", description: "You have to-dos waiting for you."),
            Notification(id: 3, title: "Update", description: "A new version is available.")
        ]
    }
}
