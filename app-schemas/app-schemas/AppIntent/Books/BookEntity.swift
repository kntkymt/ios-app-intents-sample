import AppIntents
import Foundation

/// A minimal app entity that conforms to the `books` domain `book` schema.
@AppEntity(schema: .books.book)
struct BookEntity {
    static let typeDisplayRepresentation: TypeDisplayRepresentation = "book"

//    static var isAssistantOnly: Bool {
//        true
//    }

    static let defaultQuery = BookEntityQuery()

    let id: UUID

    var title: String?
    var seriesTitle: String?
    var author: String?
    var genre: String?
    var purchaseDate: Date?
    var url: URL?

    // Schema properties must be assigned in the initializer rather than via
    // inline field defaults for the `@AppEntity(schema:)` macro.
    init(id: UUID = UUID(), title: String? = nil) {
        self.id = id
        self.title = title
        self.seriesTitle = nil
        self.author = nil
        self.genre = nil
        self.purchaseDate = nil
        self.url = nil
    }

    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: "\(title ?? "")")
    }

    struct BookEntityQuery: EntityQuery {
        func entities(for identifiers: [BookEntity.ID]) async throws -> [BookEntity] {
            identifiers.map { BookEntity(id: $0) }
        }
    }
}

/// A query that provides ``BookEntity`` values to the system for a given
/// `String` input.
struct BookIntentValueQuery: IntentValueQuery {
    /// Records query-method calls to UserDefaults so the timing of each call
    /// can be inspected later.
    private let logRepository = LogRepository()

    func values(for input: String) async throws -> [BookEntity] {
        let books = [BookEntity(title: "hoge")]
        await logRepository.append(Log(callerName: #function, count: books.count))
        return books
    }
}
