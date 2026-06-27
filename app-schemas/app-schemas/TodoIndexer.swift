import AppIntents
import CoreSpotlight
import Foundation

/// Donates ``TodoEntity`` instances to a named Spotlight index so the system
/// (Spotlight, Siri, Apple Intelligence) can discover the app's to-dos.
enum TodoIndexer {
    private static let index = CSSearchableIndex(name: "TodosIndex")

    /// Replaces the indexed to-dos with the current set.
    static func reindex(_ todos: [ToDo]) async {
        do {
            try await index.deleteAppEntities(ofType: TodoEntity.self)
            try await index.indexAppEntities(todos.map(TodoEntity.init))
        } catch {
            print("Failed to index to-dos: \(error)")
        }
    }
}
