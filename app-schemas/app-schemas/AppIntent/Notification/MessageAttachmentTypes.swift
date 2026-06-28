import AppIntents
import Foundation

// Additional supporting types required by the `.messages.message` schema. This
// read-only sample never populates them, but the schema still requires the
// properties (and therefore the types) to exist.

/// A visual effect applied to a message, conforming to the `messages` domain
/// `messageEffect` schema.
@AppEnum(schema: .messages.messageEffect)
enum MessageEffect: String {
    case unspecified

    static let caseDisplayRepresentations: [Self: DisplayRepresentation] = [
        .unspecified: "Unspecified"
    ]
}

/// A custom reaction (tapback) on a message, conforming to the `messages` domain
/// `customReaction` schema.
@AppEnum(schema: .messages.customReaction)
enum CustomReaction: String {
    case unspecified

    static let caseDisplayRepresentations: [Self: DisplayRepresentation] = [
        .unspecified: "Unspecified"
    ]
}

/// The reaction on a message: either a custom tapback or a free-form text
/// reaction. The `.messages.message` schema models `reaction` as this union.
@UnionValue
enum MessageReaction {
    case custom(CustomReaction)
    case text(AttributedString)
}

/// A custom attachment on a message, conforming to the `messages` domain
/// `customAttachment` schema. Unused in this sample.
@AppEntity(schema: .messages.customAttachment)
struct CustomAttachment {
    static let defaultQuery = CustomAttachmentQuery()

    let id: String

    var sourceName: String? { nil }
    var description: String? { nil }

    var displayRepresentation: DisplayRepresentation { "Attachment" }

    struct CustomAttachmentQuery: EntityQuery {
        func entities(for identifiers: [CustomAttachment.ID]) async throws -> [CustomAttachment] {
            []
        }
    }
}
