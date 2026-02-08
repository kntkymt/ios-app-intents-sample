import AppIntents
import UIKit

// entities returned by visual search queries must be associated with an OpenIntent.
public struct OpenItemIntent: OpenIntent {
    public static let title: LocalizedStringResource = "Open Item"

    public init(target: ItemEntity) {
        self.target = target
    }

    public init() {}

    @Parameter(title: "Item")
    public var target: ItemEntity

    @Dependency
    var logger: Logger

    public static var isDiscoverable: Bool {
        false
    }

    @MainActor
    public func perform() async throws -> some IntentResult {
        logger.trace()
        return .result()
    }
}
