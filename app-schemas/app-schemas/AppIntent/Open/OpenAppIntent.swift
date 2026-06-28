import AppIntents

/// An app intent that opens the app to one of its top-level screens by
/// conforming to the `system` domain `open` schema.
///
/// Unlike an `OpenIntent` that targets a specific ``TodoEntity``, this opens the
/// app itself. The ``AppScreenEntity`` (backed by the ``AppScreen`` `AppEnum`)
/// describes which screen to show. Siri, Spotlight, and Apple Intelligence use
/// this schema to launch the app.
@AppIntent(schema: .system.open)
struct OpenAppIntent: OpenIntent {
    @Parameter(title: "Screen")
    var target: AppScreenEntity

    @MainActor
    func perform() async throws -> some IntentResult {
        // `OpenIntent` opens the app; select the requested tab in `RootView`.
        AppNavigation.shared.selectedScreen = target.screen
        return .result()
    }
}
