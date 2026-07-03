import AppIntents
import SwiftUI

/// Displays a read-only list of system messages.
struct NotificationScreen: View {
    private let repository = NotificationRepository()

    @State private var navigation = AppNavigation.shared
    @State private var notifications: [Notification] = []

    var body: some View {
        // The path is driven by `AppNavigation` so `OpenNotificationIntent` can
        // push a `NotificationDetailScreen` from outside the view hierarchy.
        NavigationStack(path: $navigation.notificationPath) {
            List(notifications) { notification in
                NavigationLink(value: notification) {
                    NotificationRow(notification: notification)
                }
                // On-screen awareness: tie each visible row to its app entity so
                // Siri and Apple Intelligence know which notifications are onscreen.
                .appEntityIdentifier(
                    EntityIdentifier(for: NotificationEntity.self, identifier: notification.id)
                )
            }
            .navigationTitle("Notifications")
            .navigationDestination(for: Notification.self) { notification in
                NotificationDetailScreen(notification: notification)
            }
        }
        .task { await load() }
    }

    private func load() async {
        notifications = await repository.getNotifications()
        // Index the current notifications when the screen first appears.
        await NotificationIndexer.reindex(notifications)
    }
}

/// A read-only row for a single notification.
private struct NotificationRow: View {
    let notification: Notification

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(notification.title)
                .font(.headline)
            Text(notification.description)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Text(notification.createdDate, format: .dateTime.year().month().day().hour().minute())
                .font(.caption)
                .foregroundStyle(.tertiary)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    NotificationScreen()
}
