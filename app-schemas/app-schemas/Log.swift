import Foundation

/// A single, general-purpose log record capturing when something ran and which
/// function recorded it. Call sites pass `#function` so the caller's name is
/// stored alongside the timestamp.
struct Log: Codable, Identifiable {
    let id: UUID
    /// When the log was recorded.
    let date: Date
    /// The name of the function that recorded the log (typically `#function`).
    let callerName: String
    /// The number of items involved, when applicable.
    let count: Int

    init(id: UUID = UUID(), date: Date = Date(), callerName: String, count: Int) {
        self.id = id
        self.date = date
        self.callerName = callerName
        self.count = count
    }
}

/// Persists and retrieves ``Log`` entries through `LocalStorage`, using the same
/// UserDefaults-backed technique as `ToDoRepository`.
///
/// An `actor`, so appending is serialized and runs off the main thread.
actor LogRepository {
    private let storage: LocalStorage
    private let storageKey = "logs"

    init(storage: LocalStorage = LocalStorage()) {
        self.storage = storage
    }

    /// Returns all persisted logs, newest last, or an empty array if none exist.
    func getLogs() -> [Log] {
        storage.load([Log].self, forKey: storageKey) ?? []
    }

    /// Appends a new log entry and persists the updated list.
    func append(_ log: Log) {
        var logs = getLogs()
        logs.append(log)
        storage.store(logs, forKey: storageKey)
    }

    /// Removes all persisted logs.
    func clear() {
        storage.store([Log](), forKey: storageKey)
    }
}
