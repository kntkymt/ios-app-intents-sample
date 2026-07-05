import AppIntents

/// The top-level destinations the app can open, modeled as an `AppEnum`.
///
/// Each case maps to a tab in ``RootView``.
enum AppScreen: String, AppEnum {
    case todo
    case notification

    /// Human-readable label, reused for both tab titles and `AppEnum` display.
    var title: String {
        switch self {
        case .todo: "ToDo"
        case .notification: "Notifications"
        }
    }

    static let typeDisplayRepresentation = TypeDisplayRepresentation(name: "Screen")

    static let caseDisplayRepresentations: [AppScreen: DisplayRepresentation] = [
        .todo: "ToDo",
        .notification: "Notifications"
    ]
}

/// An app entity that represents a whole screen of the app rather than a piece
/// of domain content like ``TodoEntity``.
///
/// `OpenIntent` (and the `.system.open` schema) requires its `target` to be an
/// `AppEntity`, so this thin entity wraps the ``AppScreen`` `AppEnum` to act as
/// the target of ``OpenAppIntent``.
struct AppScreenEntity: AppEntity {
    static let defaultQuery = AppScreenQuery()
    static let typeDisplayRepresentation = TypeDisplayRepresentation(name: "Screen")

    static var isAssistantOnly: Bool {
        true
    }

    /// The underlying `AppEnum` value this entity represents.
    let screen: AppScreen

    var id: String { screen.rawValue }

    var displayRepresentation: DisplayRepresentation {
        AppScreen.caseDisplayRepresentations[screen] ?? DisplayRepresentation(title: "\(screen.title)")
    }

    init(screen: AppScreen) {
        self.screen = screen
    }

    /// Because the set of screens is small and fixed, the query is an
    /// `EnumerableEntityQuery`: it can hand the system every screen at once,
    /// which also lets the Shortcuts app generate a Find action automatically.
    struct AppScreenQuery: EnumerableEntityQuery {
        func entities(for identifiers: [AppScreenEntity.ID]) async throws -> [AppScreenEntity] {
            identifiers
                .compactMap(AppScreen.init(rawValue:))
                .map(AppScreenEntity.init(screen:))
        }

        func allEntities() async throws -> [AppScreenEntity] {
            AppScreen.allCases.map(AppScreenEntity.init(screen:))
        }
    }
}
