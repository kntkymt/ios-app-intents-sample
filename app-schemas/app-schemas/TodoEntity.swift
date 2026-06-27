import AppIntents
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
    var urls: [URL] { [] }
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

    struct TodoEntityQuery: EntityQuery {
        func entities(for identifiers: [TodoEntity.ID]) async throws -> [TodoEntity] {
            let identifierSet = Set(identifiers)
            let todos = await ToDoRepository().getTodos()
            return todos
                .filter { identifierSet.contains($0.id) }
                .map(TodoEntity.init)
        }

        func suggestedEntities() async throws -> [TodoEntity] {
            await ToDoRepository().getTodos().map(TodoEntity.init)
        }
    }
}
