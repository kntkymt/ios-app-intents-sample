import Foundation

/// A lightweight persistence helper that stores any `Codable` value in
/// `UserDefaults` by encoding it to JSON.
///
/// Declared `nonisolated` so its work (JSON encoding/decoding) runs on
/// whatever executor calls it — e.g. the `ToDoRepository` actor's background
/// executor — instead of hopping to the main actor.
nonisolated struct LocalStorage {
    private let userDefaults: UserDefaults
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    /// Encodes `value` to JSON and stores it under `key`.
    func store<T: Encodable>(_ value: T, forKey key: String) {
        guard let data = try? encoder.encode(value) else { return }
        userDefaults.set(data, forKey: key)
    }

    /// Loads and decodes the JSON value stored under `key`, if any.
    func load<T: Decodable>(_ type: T.Type, forKey key: String) -> T? {
        guard let data = userDefaults.data(forKey: key) else { return nil }
        return try? decoder.decode(type, from: data)
    }
}
