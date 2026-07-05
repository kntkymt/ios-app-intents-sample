import AppIntents
import Intermediate

struct ExtensionPingIntent: AppIntent {
    static let title: LocalizedStringResource = "Extension Ping Intent"
    static let description = IntentDescription("An intent provided by an App Intents extension.")

    func perform() async throws -> some IntentResult & ProvidesDialog {
        let _ = IntermediateHelper()
        return .result(dialog: "Pong from extension")
    }
}

@main
struct IntentsExtension: AppIntentsExtension {
}
