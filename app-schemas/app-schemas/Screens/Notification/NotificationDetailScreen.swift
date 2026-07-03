import AppIntents
import SwiftUI

/// Shows the full detail of a single ``Notification``.
///
/// The view associates itself with the matching ``NotificationEntity`` via
/// `appEntityIdentifier`, so while it's onscreen Siri and Apple Intelligence
/// know which notification the person is looking at ("on screen awareness").
struct NotificationDetailScreen: View {
    let notification: Notification

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(notification.title)
                    .font(.title2)
                    .fontWeight(.bold)

                Text(notification.createdDate, format: .dateTime.year().month().day().hour().minute())
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Text(notification.description)
                    .font(.body)

                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
        }
        .navigationTitle(notification.title)
        .navigationBarTitleDisplayMode(.inline)
        .appEntityIdentifier(
            EntityIdentifier(for: NotificationEntity.self, identifier: notification.id)
        )
    }
}

#Preview {
    NavigationStack {
        NotificationDetailScreen(
            notification: Notification(id: 1, title: "Welcome", description: "Thanks for installing the app.")
        )
    }
}
