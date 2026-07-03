import AppIntents
import Foundation

@AppEnum(schema: .books.contentType)
public enum BookContentType: String, AppEnum {
    case audiobook
    case ebook
    case unknown

    public static let caseDisplayRepresentations: [Self: DisplayRepresentation] = [
        .audiobook: "Audiobook",
        .ebook: "eBook",
        .unknown: "Unknown",
    ]
}

@AppEntity(schema: .books.book)
public struct BookEntity: AppEntity {
    public struct Query: EntityStringQuery {
        public init() {}

        public func entities(for identifiers: [BookEntity.ID]) async throws -> [BookEntity] {
            BookEntity.sampleBooks().filter { identifiers.contains($0.id) }
        }

        public func entities(matching string: String) async throws -> [BookEntity] {
            BookEntity.sampleBooks().filter {
                $0.title?.localizedCaseInsensitiveContains(string) == true
            }
        }
    }

    public static let defaultQuery = Query()

    public var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: "\(title ?? "Book")")
    }

    public var id = UUID()

    @Property
    public var title: String?

    @Property
    public var seriesTitle: String?

    @Property
    public var author: String?

    @Property
    public var genre: String?

    @Property
    public var purchaseDate: Date?

    @Property
    public var contentType: BookContentType?

    @Property
    public var url: URL?

    public init() {}

    public static func sampleBooks() -> [BookEntity] {
        [
            makeSample(
                id: UUID(uuidString: "00000000-0000-0000-0000-000000000001")!,
                title: "The Swift Journey",
                seriesTitle: "Swift Chronicles",
                author: "Ann Author",
                genre: "Adventure",
                contentType: .ebook
            ),
            makeSample(
                id: UUID(uuidString: "00000000-0000-0000-0000-000000000002")!,
                title: "Bazel Deep Dive",
                seriesTitle: nil,
                author: "Bob Builder",
                genre: "Technology",
                contentType: .audiobook
            ),
            makeSample(
                id: UUID(uuidString: "00000000-0000-0000-0000-000000000003")!,
                title: "App Intents in Action",
                seriesTitle: "Frameworks in Action",
                author: "Carol Coder",
                genre: "Technology",
                contentType: .unknown
            ),
        ]
    }

    private static func makeSample(
        id: UUID,
        title: String,
        seriesTitle: String?,
        author: String,
        genre: String,
        contentType: BookContentType
    ) -> BookEntity {
        var book = BookEntity()
        book.id = id
        book.title = title
        book.seriesTitle = seriesTitle
        book.author = author
        book.genre = genre
        book.purchaseDate = Date(timeIntervalSince1970: 1_700_000_000)
        book.contentType = contentType
        book.url = URL(string: "https://example.com/books/\(id.uuidString.lowercased())")
        return book
    }
}

@AppIntent(schema: .books.openBook)
public struct OpenBookIntent: OpenIntent {
    @Parameter
    public var target: BookEntity

    public init() {}

    public func perform() async throws -> some IntentResult {
        .result()
    }
}
