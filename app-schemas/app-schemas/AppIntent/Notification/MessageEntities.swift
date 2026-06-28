import AppIntents
import Foundation

// Supporting types required by the `.messages.message` schema that ``NotificationEntity``
// conforms to. A "運営からのメッセージ" (operator message) is modeled as a message
// authored by a fixed operator persona in a single "Announcements" conversation.
//
// Following Apple's UnicornChat sample, the author (`MessagePerson`) and the
// `ConversationEntity` both conform to `IndexedEntity` and store their schema
// properties (assigned via a custom initializer). That stored/indexed shape is
// what lets `indexAppEntities` bridge a message's author/conversation into
// Spotlight without crashing.

/// The kind of a message, conforming to the `messages` domain `messageType` schema.
@AppEnum(schema: .messages.messageType)
enum MessageType: String {
    case unspecified

    static let caseDisplayRepresentations: [Self: DisplayRepresentation] = [
        .unspecified: "Unspecified"
    ]
}

/// An attribute of a message, conforming to the `messages` domain
/// `messageAttribute` schema. Unused in this sample (the set is always empty).
@AppEnum(schema: .messages.messageAttribute)
enum MessageAttribute: String {
    case unspecified

    static let caseDisplayRepresentations: [Self: DisplayRepresentation] = [
        .unspecified: "Unspecified"
    ]
}

/// An attribute of a conversation, conforming to the `messages` domain
/// `conversationAttribute` schema. Unused in this sample.
@AppEnum(schema: .messages.conversationAttribute)
enum ConversationAttribute: String {
    case unspecified

    static let caseDisplayRepresentations: [Self: DisplayRepresentation] = [
        .unspecified: "Unspecified"
    ]
}

/// A participant in a conversation, conforming to the `messages` domain
/// `messagePerson` schema.
@AppEntity(schema: .messages.messagePerson)
struct MessagePerson: IndexedEntity {
    static let defaultQuery = MessagePersonQuery()

    var id: String
    var person: IntentPerson

    init(id: String, person: IntentPerson) {
        self.id = id
        self.person = person
    }

    var displayRepresentation: DisplayRepresentation {
        person.displayRepresentation
    }

    struct MessagePersonQuery: EntityQuery {
        func entities(for identifiers: [MessagePerson.ID]) async throws -> [MessagePerson] {
            identifiers.contains(MessagePerson.operator.id) ? [.operator] : []
        }

        func suggestedEntities() async throws -> [MessagePerson] {
            [.operator]
        }
    }
}

extension MessagePerson {
    /// The fixed "運営" (service operator) that authors every notification.
    ///
    /// Modeled as an app concept: an `.applicationDefined` identifier and handle
    /// with a display name (not a real contact / email / phone).
    static let `operator` = MessagePerson(
        id: "operator",
        person: IntentPerson(
            identifier: .applicationDefined("operator"),
            name: .displayName("運営"),
            handle: IntentPerson.Handle(applicationDefined: "operator")
        )
    )
}

/// A conversation that groups messages, conforming to the `messages` domain
/// `conversation` schema. This sample uses a single, fixed announcements channel.
@AppEntity(schema: .messages.conversation)
struct ConversationEntity: IndexedEntity {
    static let defaultQuery = ConversationEntityQuery()

    var id: String
    var recipients: [MessagePerson]
    var displayName: String
    var previewText: AttributedString
    var conversationName: String?
    var isRead: Bool
    var attributes: Set<ConversationAttribute>
    var dateLastActive: Date?

    init(
        id: String,
        recipients: [MessagePerson],
        displayName: String,
        previewText: AttributedString,
        conversationName: String?,
        isRead: Bool,
        attributes: Set<ConversationAttribute>,
        dateLastActive: Date?
    ) {
        self.id = id
        self.recipients = recipients
        self.displayName = displayName
        self.previewText = previewText
        self.conversationName = conversationName
        self.isRead = isRead
        self.attributes = attributes
        self.dateLastActive = dateLastActive
    }

    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: "\(displayName)")
    }

    struct ConversationEntityQuery: EntityQuery {
        func entities(for identifiers: [ConversationEntity.ID]) async throws -> [ConversationEntity] {
            identifiers.contains(ConversationEntity.announcements.id) ? [.announcements] : []
        }

        func suggestedEntities() async throws -> [ConversationEntity] {
            [.announcements]
        }
    }
}

extension ConversationEntity {
    /// The single channel that carries all operator announcements.
    static let announcements = ConversationEntity(
        id: "announcements",
        recipients: [.operator],
        displayName: "Announcements",
        previewText: AttributedString("運営からのお知らせ"),
        conversationName: "Announcements",
        isRead: false,
        attributes: [],
        dateLastActive: nil
    )
}
