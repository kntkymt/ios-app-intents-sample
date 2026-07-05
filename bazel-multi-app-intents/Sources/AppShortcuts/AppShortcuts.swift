import AppIntents
import FirstAppIntent
import Intermediate

public struct ParentIntent: AppIntent {
    public static let title: LocalizedStringResource = "Parent Intent"
    public static let description = IntentDescription(
        "An intent returning an AppEntity declared in a dependency module.")

    public init() {}

    public func perform() async throws -> some IntentResult & ReturnsValue<CounterEntity> {
        let _ = IntermediateHelper()
        return .result(value: CounterEntity(id: "parent"))
    }
}

public struct MultiAppShortcuts: AppShortcutsProvider {
    public static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: ParentIntent(),
            phrases: [
                "Run parent intent in \(.applicationName)",
            ],
            shortTitle: "Run Parent Intent",
            systemImageName: "1.circle"
        )
    }

    public init() {}
}

public struct MultiAppIntentsPackage: AppIntentsPackage {
    public static var includedPackages: [any AppIntentsPackage.Type] {
        [
            FirstAppIntentPackage.self,
            IntermediatePackage.self,
        ]
    }
}
