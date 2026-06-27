import AppIntents
import GeoToolbox

// `reminders.reminder` requires the `locationTrigger` property to be declared,
// so its type must exist and conform to the schema. This sample never uses it
// (the value is always nil), so these are minimal stubs that only satisfy the
// compiler's schema requirements.

@AppEntity(schema: .reminders.locationTrigger)
struct LocationTriggerEntity {
    static let defaultQuery = LocationTriggerEntityQuery()

    let id: String
    var place: PlaceDescriptor
    var event: LocationTriggerEvent

    var displayRepresentation: DisplayRepresentation { "Location Trigger" }

    struct LocationTriggerEntityQuery: EntityQuery {
        func entities(for identifiers: [LocationTriggerEntity.ID]) async throws -> [LocationTriggerEntity] {
            []
        }
    }
}

@AppEnum(schema: .reminders.locationTriggerEvent)
enum LocationTriggerEvent: String {
    case arrive
    case depart

    static let caseDisplayRepresentations: [Self: DisplayRepresentation] = [
        .arrive: "Arrive",
        .depart: "Depart"
    ]
}
