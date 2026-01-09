import WidgetKit
import SwiftUI
import SampleAppIntents
import AppIntents

@main
struct widgetBundle: WidgetBundle {
    init() {
        let logger = Logger()
        logger.trace()
        AppDependencyManager.shared.add(dependency: logger)
    }

    var body: some Widget {
        widget()
    }
}
