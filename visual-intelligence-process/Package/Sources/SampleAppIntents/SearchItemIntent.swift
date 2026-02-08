import AppIntents
import UIKit

struct SearchItemIntent: AppIntent {    
    public static let title: LocalizedStringResource = "Search Items"

    @Dependency
    var logger: Logger

    func perform() async throws -> some ReturnsValue<[ItemEntity]> {
        await logger.trace()

        return .result(value: Item.stub.map {
            ItemEntity(item: $0)
        })
    }
}
