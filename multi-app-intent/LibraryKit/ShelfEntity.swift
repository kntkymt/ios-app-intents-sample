import AppIntents

public struct ShelfEntity: AppEntity {
    public static let typeDisplayRepresentation = TypeDisplayRepresentation(name: "Shelf Entity")
    public static let defaultQuery = ShelfEntityQuery()

    public var id: String

    public var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: "\(id)")
    }

    public init(id: String) {
        self.id = id
    }
}

public struct ShelfEntityQuery: EntityQuery {
    public init() {}

    public func entities(for identifiers: [String]) async throws -> [ShelfEntity] {
        identifiers.map { ShelfEntity(id: $0) }
    }
}
