import AppIntents

public struct FirstAppIntent: AppIntent {
    public static let title: LocalizedStringResource = "First App Intent"
    public static let description = IntentDescription("A sample first intent module.")

    public init() {}

    public func perform() async throws -> some IntentResult & ProvidesDialog {
        .result(dialog: "First intent executed")
    }
}

public struct CounterEntity: AppEntity {
    public static let typeDisplayRepresentation = TypeDisplayRepresentation(name: "Counter Entity")
    public static let defaultQuery = CounterEntityQuery()

    public var id: String

    public var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: "\(id)")
    }

    public init(id: String) {
        self.id = id
    }
}

public struct CounterEntityQuery: EntityQuery {
    public init() {}

    public func entities(for identifiers: [String]) async throws -> [CounterEntity] {
        identifiers.map { CounterEntity(id: $0) }
    }
}
