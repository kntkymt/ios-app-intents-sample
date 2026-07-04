# Indexing `@AppEntity(schema: .reminders.reminder)` emits warning about incorrect type of url (expected NSString but got NSURL)

FB23563297

Indexing `@AppEntity(schema: .reminders.reminder)` emits warning about incorrect type of url (expected NSString but got NSURL).

> {CSInlineDonation[async]: "devplaceholder.XXXX.reminder_entity_index_error" add-update-items:3 delete-items:0}: Encountered translation error for item: ReminderEntity/reminder-3 error: Error Domain=LNSpotlightCascadeTranslator Code=5 "Failed to construct Cascade attributes object" UserInfo={NSDebugDescription=Failed to construct Cascade attributes object, NSUnderlyingError=0x10d45fc30 {Error Domain=com.apple.CascadeSets.Item Code=2 "Provided object for field url is of class Swift.__EmptyArrayStorage, expected class: NSString" UserInfo={NSDebugDescription=Provided object for field url is of class Swift.__EmptyArrayStorage, expected class: NSString}}}
Type: Error | Timestamp: 2026-07-04 22:23:14.279294+0900 | Library: CoreSpotlight | Subsystem: com.apple.corespotlight | Category: index | TID: 0xf09f

```
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


import SwiftUI
import Playgrounds
import AppIntents
import CoreSpotlight

@main struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct ContentView: View {
    var body: some View {
        Text("Hello, world!")
            .padding()
            .onAppear {
                Task {
                    try? await CSSearchableIndex.default().indexAppEntities(ReminderEntity.dummies)
                }
            }
    }
}
```