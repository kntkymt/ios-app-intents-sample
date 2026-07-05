import AppIntents
import Intermediate

public struct ExtensionPingIntent: AppIntent {
    public static let title: LocalizedStringResource = "Extension Ping Intent"
    public static let description = IntentDescription(
        "An intent provided by an App Intents extension.")

    public init() {}

    public func perform() async throws -> some IntentResult & ProvidesDialog {
        let _ = IntermediateHelper()
        return .result(dialog: "Pong from extension")
    }
}

@main
public struct IntentsExtension: AppIntentsExtension {
    public init() {}
}
