import Foundation

/// A single record of a ``TodoEntity/TodoEntityQuery`` call, capturing when it
/// ran and which query method the system invoked.
struct ReindexLog: Codable, Identifiable {
    enum Kind: String, Codable {
        /// `entities(for:)` — the system resolved specific identifiers.
        case entities
        /// `suggestedEntities()` — the system asked for suggestions.
        case suggested
        /// `reindexEntities(for:)` — a partial reindex for given identifiers.
        case reindex
        /// `reindexAllEntities()` — a full reindex of every entity.
        case reindexAll
    }

    let id: UUID
    /// When the query method was invoked.
    let date: Date
    /// Which query method was called.
    let kind: Kind
    /// The number of identifiers/entities involved, when applicable.
    let count: Int

    init(id: UUID = UUID(), date: Date = Date(), kind: Kind, count: Int) {
        self.id = id
        self.date = date
        self.kind = kind
        self.count = count
    }
}

/// Persists and retrieves ``ReindexLog`` entries through `LocalStorage`,
/// using the same UserDefaults-backed technique as `ToDoRepository`.
///
/// An `actor`, so appending is serialized and runs off the main thread.
actor ReindexLogRepository {
    private let storage: LocalStorage
    private let storageKey = "reindexLogs"

    init(storage: LocalStorage = LocalStorage()) {
        self.storage = storage
    }

    /// Returns all persisted logs, newest last, or an empty array if none exist.
    func getLogs() -> [ReindexLog] {
        storage.load([ReindexLog].self, forKey: storageKey) ?? []
    }

    /// Appends a new log entry and persists the updated list.
    func append(_ log: ReindexLog) {
        var logs = getLogs()
        logs.append(log)
        storage.store(logs, forKey: storageKey)
    }

    /// Removes all persisted logs.
    func clear() {
        storage.store([ReindexLog](), forKey: storageKey)
    }
}
