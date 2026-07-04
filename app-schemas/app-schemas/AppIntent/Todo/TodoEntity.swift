import AppIntents
import CoreSpotlight
import Foundation

/// An app entity that exposes a ``ToDo`` to Siri, Apple Intelligence, and
/// Spotlight by conforming to the `reminders` domain `reminder` schema.
///
/// `TodoEntity` is a distinct type from ``ToDo`` and wraps a single `ToDo`
/// value, mapping its fields onto the properties the schema requires.
@AppEntity(schema: .reminders.reminder)
struct TodoEntity: IndexedEntity {
    static let defaultQuery = TodoEntityQuery()

    /// The underlying model value this entity represents.
    let todo: ToDo

    var id: UUID { todo.id }

    var title: String { todo.title }
    var note: AttributedString? {
        todo.description.isEmpty ? nil : AttributedString(todo.description)
    }
    var creationDate: Date? { todo.createdDate }
    var list: ListEntity {
        .default
    }
    var isCompleted: Bool {
        false
    }

    // unused values
    var images: [IntentFile] { [] }
    var subtasks: [TodoEntity] { [] }
    var tags: Set<String> { [] }
    var urls: [URL] { [URL(string: "https://example.com")!] }
    var dueDate: DateComponents? { nil }
    var recurrence: Calendar.RecurrenceRule? { nil }
    var isFlagged: Bool? { nil }
    var completionDate: Date? { nil }
    var locationTrigger: LocationTriggerEntity? { nil }

    init(todo: ToDo) {
        self.todo = todo
    }

    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(
            title: "\(todo.title)",
            subtitle: todo.description.isEmpty ? nil : "\(todo.description)"
        )
    }

    struct TodoEntityQuery: IndexedEntityQuery {
        /// Records query-method calls to UserDefaults, mirroring how to-dos are
        /// stored, so the timing of each call can be inspected later.
        private let logRepository = ReindexLogRepository()

        func entities(for identifiers: [TodoEntity.ID]) async throws -> [TodoEntity] {
            await logRepository.append(ReindexLog(kind: .entities, count: identifiers.count))
            let identifierSet = Set(identifiers)
            let todos = await ToDoRepository().getTodos()
            return todos
                .filter { identifierSet.contains($0.id) }
                .map(TodoEntity.init)
        }

        func suggestedEntities() async throws -> [TodoEntity] {
            let entities = await ToDoRepository().getTodos().map(TodoEntity.init)
            await logRepository.append(ReindexLog(kind: .suggested, count: entities.count))
            return entities
        }

        func reindexEntities(
            for identifiers: [TodoEntity.ID],
            indexDescription: CSSearchableIndexDescription
        ) async throws {
            await logRepository.append(ReindexLog(kind: .reindex, count: identifiers.count))
            try await TodoIndexer.reindex(identifiers: identifiers)
        }

        func reindexAllEntities(
            indexDescription: CSSearchableIndexDescription
        ) async throws {
            let todos = await ToDoRepository().getTodos()
            await logRepository.append(ReindexLog(kind: .reindexAll, count: todos.count))
            await TodoIndexer.reindex(todos)
        }
    }
}
