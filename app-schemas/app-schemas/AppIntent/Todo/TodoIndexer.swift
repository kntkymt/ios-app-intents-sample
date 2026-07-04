import AppIntents
import CoreSpotlight
import Foundation

/// Donates ``TodoEntity`` instances to a named Spotlight index so the system
/// (Spotlight, Siri, Apple Intelligence) can discover the app's to-dos.
enum TodoIndexer {
    private static let index = CSSearchableIndex(name: "TodosIndex")

    static func deleteAllIndex() async {
        do {
            try await index.deleteAppEntities(ofType: TodoEntity.self)
        } catch {
            print("Failed to delete index to-dos: \(error)")
        }
    }

    /// Replaces the indexed to-dos with the current set.
    static func reindex(_ todos: [ToDo]) async {
        do {
            try await index.deleteAppEntities(ofType: TodoEntity.self)
            try await index.indexAppEntities(todos.map(TodoEntity.init))
        } catch {
            print("Failed to index to-dos: \(error)")
        }
    }

    /// Reindexes only the to-dos matching the given identifiers, used by
    /// ``TodoEntity/TodoEntityQuery`` when the system requests a partial
    /// reindex through `IndexedEntityQuery`.
    static func reindex(identifiers: [ToDo.ID]) async throws {
        let identifierSet = Set(identifiers)
        let todos = await ToDoRepository().getTodos()
            .filter { identifierSet.contains($0.id) }
        try await index.indexAppEntities(todos.map(TodoEntity.init))
    }
}
