import AppIntents

struct ItemEntity: AppEntity, Identifiable {
    static var typeDisplayRepresentation: TypeDisplayRepresentation = "Item"
    static var defaultQuery = ItemQuery()

    var id: String
    var imageURL: URL

    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(
            title: "Item \(id)",
            image: .init(url: imageURL)
        )
    }
}

extension ItemEntity {
    static var stub: [ItemEntity] {
        [
            ItemEntity(
                id: "1",
                imageURL: URL(string: "https://avatars.githubusercontent.com/u/44288050?v=4")!
            ),
            ItemEntity(
                id: "2",
                imageURL: URL(string: "https://avatars.githubusercontent.com/u/42816656?s=48&v=4")!,
            )
        ]
    }
}

struct ItemQuery: EntityQuery {
    func entities(for identifiers: [ItemEntity.ID]) async throws -> [ItemEntity] {
        identifiers.compactMap { id in ItemEntity.stub.first { $0.id == id } }
    }

    func suggestedEntities() async throws -> [ItemEntity] {
        ItemEntity.stub
    }
}

struct GetItemsIntent: AppIntent {
    static var title: LocalizedStringResource = "Get Items"

    func perform() async throws -> some IntentResult & ReturnsValue<[ItemEntity]> {
        .result(value: ItemEntity.stub)
    }
}
