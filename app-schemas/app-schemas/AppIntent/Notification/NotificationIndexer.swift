import AppIntents
import CoreSpotlight
import Foundation

/// Donates ``NotificationEntity`` instances to Spotlight so the system
/// (Spotlight, Siri, Apple Intelligence) can discover the app's notifications.
///
/// Follows Apple's UnicornChat sample: the author and conversation the messages
/// reference are `IndexedEntity` types and are indexed first, then the messages.
enum NotificationIndexer {

    /// Indexes the current notifications (and the author/conversation they
    /// reference) into Spotlight.
    ///
    /// Notifications have stable identifiers, so re-indexing updates the existing
    /// entries in place — no need to delete first.
    static func reindex(_ notifications: [Notification]) async {
        let messageEntities = notifications.map(NotificationEntity.init)
        do {
            try await CSSearchableIndex.default().indexAppEntities([MessagePerson.operator])
            try await CSSearchableIndex.default().indexAppEntities([ConversationEntity.announcements])
            try await CSSearchableIndex.default().indexAppEntities(messageEntities)
        } catch {
            print("Failed to index notifications: \(error)")
        }
    }
}
