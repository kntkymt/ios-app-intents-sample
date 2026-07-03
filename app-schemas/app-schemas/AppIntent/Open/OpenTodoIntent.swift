import AppIntents

/// A third app intent that also conforms to the `system` domain `open` schema,
/// to test whether multiple `.system.open` declarations are allowed.
///
/// Mirrors ``OpenNotificationIntent``: instead of opening a top-level screen via
/// ``AppScreenEntity``, it targets a specific ``TodoEntity`` and opens the app to
/// the ToDo screen.
//@AppIntent(schema: .system.open)
//struct OpenTodoIntent: OpenIntent {
//    @Parameter(title: "Todo")
//    var target: TodoEntity
//
//    @MainActor
//    func perform() async throws -> some IntentResult {
//        let navigation = AppNavigation.shared
//        navigation.selectedScreen = .todo
//
//        return .result()
//    }
//}
