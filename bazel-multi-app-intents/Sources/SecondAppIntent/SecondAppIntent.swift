import AppIntents

struct SecondAppIntent: AppIntent {
    static let title: LocalizedStringResource = "Second App Intent"
    static let description = IntentDescription("A sample second intent module.")

    func perform() async throws -> some IntentResult & ProvidesDialog {
        .result(dialog: "Second intent executed")
    }
}
