import AppIntents
import Foundation

/// The list a ``TodoEntity`` belongs to, conforming to the `reminders` domain
/// `list` schema. This sample uses a single, fixed default list.
@AppEntity(schema: .reminders.list)
struct ListEntity {
    static let defaultQuery = ListEntityQuery()

    let id: String

    var name: String
    var type: ListType

    init(id: String, name: String, type: ListType = .standard) {
        self.id = id
        self.name = name
        self.type = type
    }

    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: "\(name)")
    }

    struct ListEntityQuery: EntityQuery {
        func entities(for identifiers: [ListEntity.ID]) async throws -> [ListEntity] {
            identifiers.contains(ListEntity.default.id) ? [.default] : []
        }

        func suggestedEntities() async throws -> [ListEntity] {
            [.default]
        }
    }
}

extension ListEntity {
    /// The single list used to hold every to-do in this sample.
    static let `default` = ListEntity(id: "default", name: "ToDo")
}

/// The type of a reminder list, conforming to the `reminders` domain
/// `listType` schema.
@AppEnum(schema: .reminders.listType)
enum ListType: String {
    case standard

    static let caseDisplayRepresentations: [Self: DisplayRepresentation] = [
        .standard: "Standard"
    ]
}
