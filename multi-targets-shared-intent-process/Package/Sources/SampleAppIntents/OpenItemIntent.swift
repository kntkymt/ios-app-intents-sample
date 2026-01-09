import AppIntents

public struct OpenItemIntent: OpenIntent {
    public static let title: LocalizedStringResource = "Open Item"

    public init(target: ItemEntity) {
        self.target = target
    }

    public init() {}

    @Parameter(title: "Item")
    public var target: ItemEntity

    @Dependency
    var logger: Logger

    public func perform() async throws -> some IntentResult {
        await logger.trace()
        return .result()
    }
}
