import AppIntents

/// The capture modes the app's camera can open into, modeled as an `AppEnum`
/// that conforms to the `camera` domain `captureMode` schema.
///
/// Siri and Apple Intelligence use this schema to understand which mode the user
/// asked for (for example, "open the camera in video mode").
@AppEnum(schema: .camera.captureMode)
enum CaptureMode: String {
    case photo

    static let caseDisplayRepresentations: [CaptureMode: DisplayRepresentation] = [
        .photo: "Photo"
    ]
}

/// An app intent that opens the app's camera in a specific ``CaptureMode`` by
/// conforming to the `camera` domain `openInCaptureMode` schema.
///
/// Like the other `OpenIntent`s in this directory, opening the app is handled by
/// the system; `perform()` only records which mode was requested so the UI can
/// react. The `target` here is the ``CaptureMode`` `AppEnum` the schema expects.
@AppIntent(schema: .camera.openInCaptureMode)
struct NavigateToCaptureModeIntent: OpenIntent {
    var target: CaptureMode

    @MainActor
    func perform() async throws -> some IntentResult {
        // `OpenIntent` brings the app to the foreground; presenting the (dummy)
        // ``CameraScreen`` as a sheet in the requested mode is our job.
        AppNavigation.shared.presentedCaptureMode = target
        return .result()
    }
}
