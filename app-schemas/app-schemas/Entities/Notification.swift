import Foundation

/// A single system message shown on ``NotificationScreen``.
///
/// For now its shape mirrors ``ToDo``; the fields can diverge later as the
/// notification feature grows.
struct Notification: Codable, Identifiable, Equatable {
    let id: Int
    var title: String
    var description: String
    let createdDate: Date

    init(id: Int, title: String, description: String, createdDate: Date = Date()) {
        self.id = id
        self.title = title
        self.description = description
        self.createdDate = createdDate
    }
}
