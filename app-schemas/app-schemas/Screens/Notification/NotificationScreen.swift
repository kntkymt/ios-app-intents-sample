import SwiftUI

/// Displays a read-only list of system messages.
struct NotificationScreen: View {
    private let repository = NotificationRepository()

    @State private var notifications: [Notification] = []

    var body: some View {
        NavigationStack {
            List(notifications) { notification in
                NotificationRow(notification: notification)
            }
            .navigationTitle("Notifications")
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
