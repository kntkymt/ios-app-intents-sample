import AppIntents

struct FirstAppIntent: AppIntent {
    static let title: LocalizedStringResource = "First App Intent"
    static let description = IntentDescription("A sample first intent module.")

    func perform() async throws -> some IntentResult & ProvidesDialog {
        .result(dialog: "First intent executed")
    }
}
