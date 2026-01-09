import AppIntents

public struct SearchItemIntent: AppIntent {
    public static let title: LocalizedStringResource = "Search Items"

    public init() {}

    @Dependency
    var logger: Logger

    public func perform() async throws -> some ReturnsValue<[ItemEntity]> {
        await logger.trace()

        return .result(value: Item.stub.map {
            ItemEntity(item: $0)
        })
    }
}
