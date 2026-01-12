import AppIntents

#if canImport(VisualIntelligence)
import UIKit
import CoreVideo
import VisualIntelligence

@available(iOS 26.0, *)
struct VisualIntelligenceIntentValueQuery: IntentValueQuery {
    func values(for input: SemanticContentDescriptor) async throws -> [ItemEntity] {
        (0..<4).map(ItemEntity.init)
    }
}

@available(iOS 26.0, *)
@AppIntent(schema: .visualIntelligence.semanticContentSearch)
struct VisualIntelligenceIntent: AppIntent {
    static let title: LocalizedStringResource = "Image Search Intent"

    var semanticContent: SemanticContentDescriptor

    func perform() async throws -> some IntentResult {
        return .result()
    }
    
    static let a = VisualIntelligenceIntentValueQuery()
}
#endif

struct ItemEntity: AppEntity {
    var id: Int

    static var typeDisplayRepresentation: TypeDisplayRepresentation {
        TypeDisplayRepresentation(
            name: LocalizedStringResource("Item")
        )
    }

    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(
            title: "\(id)",
            subtitle: "subtitle"
        )
    }

    static let defaultQuery = ItemEntityQuery()
}

struct ItemEntityQuery: EntityQuery {
    func entities(for identifiers: [ItemEntity.ID]) async throws -> [ItemEntity] {
      []
    }
}

// entities returned by visual search queries must be associated with an OpenIntent.
struct OpenItemIntent: OpenIntent {
    static let title: LocalizedStringResource = "Open Item"

    @Parameter(title: "Item")
    var target: ItemEntity

    func perform() async throws -> some IntentResult {
        return .result()
    }
}
