import AppIntents

public struct SecondAppIntent: AppIntent {
    public static let title: LocalizedStringResource = "Second App Intent"
    public static let description = IntentDescription("A sample second intent module.")

    public init() {}

    public func perform() async throws -> some IntentResult & ProvidesDialog {
        .result(dialog: "Second intent executed")
    }
}

@AssistantIntent(schema: .system.search)
public struct TransitiveSearchIntent: ShowInAppSearchResultsIntent {
    public static let searchScopes: [StringSearchScope] = [.general]

    @Parameter
    public var criteria: StringSearchCriteria

    public init() {}

    public func perform() async throws -> some IntentResult {
        .result()
    }
}

public struct SecondAppIntentPackage: AppIntentsPackage {}
