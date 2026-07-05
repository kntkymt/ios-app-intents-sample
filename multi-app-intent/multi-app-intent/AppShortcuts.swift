import AppIntents
import FirstAppIntent
import Intermediate
import LibraryKit

struct ParentIntent: AppIntent {
    static let title: LocalizedStringResource = "Parent Intent"
    static let description = IntentDescription(
        "An intent returning an AppEntity declared in a dependency module.")

    init() {}

    func perform() async throws -> some IntentResult & ReturnsValue<CounterEntity> {
        let _ = IntermediateHelper()
        return .result(value: CounterEntity(id: "parent"))
    }
}

struct ParentShelfIntent: AppIntent {
    static let title: LocalizedStringResource = "Parent Shelf Intent"
    static let description = IntentDescription(
        "An intent returning an AppEntity declared in a dynamic framework.")

    init() {}

    func perform() async throws -> some IntentResult & ReturnsValue<ShelfEntity> {
        .result(value: ShelfEntity(id: "shelf"))
    }
}

struct MultiAppShortcuts: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: ParentIntent(),
            phrases: [
                "Run parent intent in \(.applicationName)",
            ],
            shortTitle: "Run Parent Intent",
            systemImageName: "1.circle"
        )
    }
}

struct MultiAppIntentsPackage: AppIntentsPackage {
    static var includedPackages: [any AppIntentsPackage.Type] {
        [
            FirstAppIntentPackage.self,
            IntermediatePackage.self,
        ]
    }
}
