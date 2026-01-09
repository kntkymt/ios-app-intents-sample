import AppIntents

public struct ItemEntity: AppEntity {
    public var item: Item
    // 50kb
    public var data: [51_200 of UInt8] = .init(repeating: 0)

    public var id: Int {
        item.id
    }

    public init(item: Item) {
        self.item = item
    }

    public static var typeDisplayRepresentation: TypeDisplayRepresentation {
        TypeDisplayRepresentation(
            name: LocalizedStringResource("Item")
        )
    }

    public var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(
            title: "\(item.name)",
            subtitle: "pid: \(item.pid)",
            image: item.thumbnailURLs.first.map { .init(url: $0) }
        )
    }

    public static let defaultQuery = ItemEntityQuery()
}

public struct ItemEntityQuery: EntityQuery {

    @Dependency
    var logger: Logger

    public init() {}
    // 1. user tap cell of visual intelligence
    // 2. EntityQuery.entities(for:) will be called
    // 3. OpenIntent will be called using return value of 2.
    // The compiler automatically determine 3.'s OpenIntent type cuz OpenItemtent is unique for each Entity
    public func entities(for identifiers: [ItemEntity.ID]) async throws -> [ItemEntity] {
        await logger.trace()
        return identifiers
            .lazy
            .compactMap { id in
                SampleAppIntents.Item.stub.first { $0.id == id }
            }.map {
                ItemEntity(item: $0)
            }
    }
}
