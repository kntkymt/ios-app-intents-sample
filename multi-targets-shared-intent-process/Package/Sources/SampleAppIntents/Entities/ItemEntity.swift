import AppIntents

public struct ItemEntity: AppEntity {
    public var item: Item

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

    public func suggestedEntities() async throws -> [ItemEntity] {
        SampleAppIntents.Item.stub.map(ItemEntity.init)
    }
}
