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
            title: "\(displayTitle)",
            subtitle: "\(displaySubTitle)",
            image: item.thumbnailURLs.first.map { .init(url: $0) }
        )
    }

    public static let defaultQuery = ItemEntityQuery()
}

private extension ItemEntity {
    var displayTitle: AttributedString {
        var string = AttributedString(item.name)
        string.font = .footnote

        return string
    }

    var displaySubTitle: AttributedString {
        var string = AttributedString("¥" + item.price.description)
        string[string.range(of: "¥")!].font = .footnote
        string.foregroundColor = .primary
        string[string.range(of: item.price.description)!].font = .body

        return string
    }
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
            .map {
                ItemEntity(item: .init(id: $0))
            }
    }

    public func suggestedEntities() async throws -> [ItemEntity] {
        SampleAppIntents.Item.stub.map(ItemEntity.init)
    }
}
