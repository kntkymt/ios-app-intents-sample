import SwiftUI
import SampleAppIntents
import AppIntents

@main
struct App: SwiftUI.App {

    init() {
        let logger = Logger()
        logger.trace()
        AppDependencyManager.shared.add(dependency: logger)
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
