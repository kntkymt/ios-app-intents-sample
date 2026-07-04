# `@AppIntent(schema: .camera.openInCaptureMode)` doesn't work

FB23562640

`@AppIntent(schema: .camera.openInCaptureMode)` doesn’t work. 
When I say  “Open Camera in XXX app” then Siri emits error message “something wrong”

```
import AppIntents

@AppEnum(schema: .camera.captureMode)
enum CaptureMode: String, AppEnum {
    case photo
    case video

    static var caseDisplayRepresentations: [CaptureMode: DisplayRepresentation] = [
        .photo: "Photo",
        .video: "Video",
    ]
}

@AppIntent(schema: .camera.openInCaptureMode)
struct NavigateToCaptureModeIntent: OpenIntent {
    @Parameter
    var target: CaptureMode

    func perform() async throws -> some IntentResult {
        .result()
    }
}
```