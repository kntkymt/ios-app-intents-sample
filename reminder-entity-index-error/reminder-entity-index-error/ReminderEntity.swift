import AppIntents
import CoreSpotlight
import Foundation
import GeoToolbox

// MARK: - ReminderEntity

/// A minimal app entity that conforms to the `reminders.reminder` schema.
/// Only the non-optional, non-collection members are stored; every optional
/// or collection member is satisfied with a computed `nil` / `[]` value.
@AppEntity(schema: .reminders.reminder)
struct ReminderEntity: IndexedEntity {
    // MARK: Static

    static let defaultQuery = ReminderEntityQuery()

    // MARK: Stored properties (required, non-optional, non-collection)

    let id: String
    var title: String
    var isCompleted: Bool
    var list: ListEntity

    init(id: String, title: String, isCompleted: Bool, list: ListEntity) {
        self.id = id
        self.title = title
        self.isCompleted = isCompleted
        self.list = list
    }

    // MARK: Optional / collection members (avoided via computed nil or [])

    var note: AttributedString? { nil }
    var images: [IntentFile] { [] }
    var subtasks: [ReminderEntity] { [] }
    var tags: Set<String> { [] }
    // Failed to create SpotlightDefinedAttributes. Error: Error Domain=LNSpotlightCascadeTranslator Code=5 "Failed to construct Cascade attributes object" UserInfo={NSDebugDescription=Failed to construct Cascade attributes object, NSUnderlyingError=0x10b84c0c0 {Error Domain=com.apple.CascadeSets.Item Code=2 "Provided object for field url is of class Swift.__EmptyArrayStorage, expected class: NSString" UserInfo={NSDebugDescription=Provided object for field url is of class Swift.__EmptyArrayStorage, expected class: NSString}}}
    // Type: Error | Timestamp: 2026-07-04 22:05:17.678179+0900 | Library: LinkServices | Subsystem: com.apple.appintents | Category: Vocabulary | TID: 0xb443
    var urls: [URL] { [] }
    var dueDate: DateComponents? { nil }
    var recurrence: Calendar.RecurrenceRule? { nil }
    var isFlagged: Bool? { nil }
    var creationDate: Date? { nil }
    var completionDate: Date? { nil }
    var locationTrigger: LocationTriggerEntity? { nil }

    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: "\(title)")
    }

    // MARK: Query

    struct ReminderEntityQuery: EntityQuery {
        func entities(for identifiers: [ReminderEntity.ID]) async throws -> [ReminderEntity] {
            ReminderEntity.dummies.filter { identifiers.contains($0.id) }
        }
    }

    // MARK: Dummy data

    /// Three dummy reminders to donate to Spotlight.
    static var dummies: [ReminderEntity] {
        [
            ReminderEntity(id: "reminder-1", title: "Buy milk", isCompleted: false, list: .dummy),
            ReminderEntity(id: "reminder-2", title: "Walk the dog", isCompleted: false, list: .dummy),
            ReminderEntity(id: "reminder-3", title: "Read a book", isCompleted: true, list: .dummy),
        ]
    }
}

// MARK: - ListEntity

/// A minimal app entity that conforms to the `reminders.list` schema, required
/// because `ReminderEntity.list` is a non-optional `ListEntity`.
@AppEntity(schema: .reminders.list)
struct ListEntity: IndexedEntity {
    // MARK: Static

    static let defaultQuery = ListEntityQuery()

    // MARK: Stored properties

    let id: String
    var name: String

    init(id: String, name: String) {
        self.id = id
        self.name = name
    }

    // Required by the schema; not optional/array, so satisfied with a real value.
    var type: ListType { .standard }

    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: "\(name)")
    }

    // MARK: Query

    struct ListEntityQuery: EntityQuery {
        func entities(for identifiers: [ListEntity.ID]) async throws -> [ListEntity] {
            [ListEntity.dummy].filter { identifiers.contains($0.id) }
        }
    }

    // MARK: Dummy data

    static var dummy: ListEntity {
        ListEntity(id: "list-1", name: "Reminders")
    }
}

// MARK: - Supporting types (required by the schemas above)

/// Required by `ListEntity.type` (`reminders.listType` schema).
@AppEnum(schema: .reminders.listType)
enum ListType: String {
    case standard

    static let caseDisplayRepresentations: [Self: DisplayRepresentation] = [
        .standard: "Standard"
    ]
}

/// Required by `LocationTriggerEntity.event` (`reminders.locationTriggerEvent` schema).
@AppEnum(schema: .reminders.locationTriggerEvent)
enum LocationTriggerEvent: String {
    case arrive
    case depart

    static let caseDisplayRepresentations: [Self: DisplayRepresentation] = [
        .arrive: "Arrive",
        .depart: "Depart"
    ]
}

/// Required because `ReminderEntity.locationTrigger` is a `LocationTriggerEntity?`.
@AppEntity(schema: .reminders.locationTrigger)
struct LocationTriggerEntity: IndexedEntity {
    static let defaultQuery = LocationTriggerEntityQuery()

    let id: String
    var place: GeoToolbox.PlaceDescriptor
    var event: LocationTriggerEvent

    init(id: String, place: GeoToolbox.PlaceDescriptor, event: LocationTriggerEvent) {
        self.id = id
        self.place = place
        self.event = event
    }

    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: "Location Trigger")
    }

    struct LocationTriggerEntityQuery: EntityQuery {
        func entities(for identifiers: [LocationTriggerEntity.ID]) async throws -> [LocationTriggerEntity] {
            []
        }
    }
}
