import AppIntents

public struct FirstAppIntent: AppIntent {
    public static let title: LocalizedStringResource = "First App Intent"
    public static let description = IntentDescription("A sample first intent module.")

    public init() {}

    public func perform() async throws -> some IntentResult & ProvidesDialog {
        .result(dialog: "First intent executed")
    }
}
