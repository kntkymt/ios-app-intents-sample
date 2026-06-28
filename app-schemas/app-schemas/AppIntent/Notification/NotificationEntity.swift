import AppIntents
import Foundation
import GeoToolbox
import LinkPresentation

/// An app entity that exposes a ``Notification`` to Siri, Apple Intelligence, and
/// Spotlight by conforming to the `messages` domain `message` schema.
///
/// A "運営からのメッセージ" (operator message) is interpreted as a message authored
/// by a fixed operator persona (``MessagePerson/operator``) in a single
/// announcements ``ConversationEntity``.
///
/// Structured like Apple's UnicornChat `MessageEntity`: the schema properties are
/// stored (so the macro wraps them as indexable `@Property` values) and assigned
/// in `init(notification:)`.
@AppEntity(schema: .messages.message)
struct NotificationEntity: IndexedEntity {
    static let defaultQuery = NotificationEntityQuery()

    var id: Int
    var messageType: MessageType
    var author: MessagePerson
    var isRead: Bool
    var attributes: Set<MessageAttribute>
    var conversation: ConversationEntity
    var date: Date
    var subject: AttributedString?
    var body: AttributedString?
    var attachments: [IntentFile]
    var audioMessage: IntentFile?
    var customAttachments: [CustomAttachment]
    var locations: [PlaceDescriptor]
    var links: [LinkMetadata]
    var messageEffect: MessageEffect?
    var reaction: MessageReaction?
    var referencedMessage: NotificationEntity?
    var notificationIdentifier: String?

    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(
            title: "\(subject ?? "")",
            subtitle: "\(body ?? "")"
        )
    }

    init(notification: Notification) {
        self.id = notification.id
        self.messageType = .unspecified
        self.author = .operator
        self.isRead = false
        self.attributes = []
        self.conversation = .announcements
        self.date = notification.createdDate
        self.subject = AttributedString(notification.title)
        self.body = notification.description.isEmpty ? nil : AttributedString(notification.description)
        self.attachments = []
        self.customAttachments = []
        self.locations = []
        self.links = []
    }

    struct NotificationEntityQuery: EntityQuery {
        func entities(for identifiers: [NotificationEntity.ID]) async throws -> [NotificationEntity] {
            let identifierSet = Set(identifiers)
            let notifications = await NotificationRepository().getNotifications()
            return notifications
                .filter { identifierSet.contains($0.id) }
                .map(NotificationEntity.init)
        }

        func suggestedEntities() async throws -> [NotificationEntity] {
            await NotificationRepository().getNotifications().map(NotificationEntity.init)
        }
    }
}
