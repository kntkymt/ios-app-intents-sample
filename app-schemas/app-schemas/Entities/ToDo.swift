import Foundation

/// A single to-do entry.
struct ToDo: Codable, Identifiable, Equatable {
    let id: UUID
    var title: String
    var description: String
    let createdDate: Date

    init(id: UUID = UUID(), title: String, description: String, createdDate: Date = Date()) {
        self.id = id
        self.title = title
        self.description = description
        self.createdDate = createdDate
    }
}
