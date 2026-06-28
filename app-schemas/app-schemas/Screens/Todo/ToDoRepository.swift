import Foundation

/// Persists and retrieves `ToDo` entries through `LocalStorage`.
///
/// An `actor`, so all storage access is serialized and runs off the main
/// thread on the actor's executor. Callers `await` its methods.
actor ToDoRepository {
    private let storage: LocalStorage
    private let storageKey = "todos"

    init(storage: LocalStorage = LocalStorage()) {
        self.storage = storage
    }

    /// Returns all persisted to-dos, or an empty array if none exist.
    func getTodos() -> [ToDo] {
        storage.load([ToDo].self, forKey: storageKey) ?? []
    }

    /// Appends a new to-do and persists the updated list.
    func addTodo(todo: ToDo) {
        var todos = getTodos()
        todos.append(todo)
        storage.store(todos, forKey: storageKey)
    }

    /// Replaces the persisted list with `todos`.
    func updateTodos(_ todos: [ToDo]) {
        storage.store(todos, forKey: storageKey)
    }
}
