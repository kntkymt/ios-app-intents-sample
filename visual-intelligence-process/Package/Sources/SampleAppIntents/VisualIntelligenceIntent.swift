#if canImport(VisualIntelligence)
import AppIntents
import UIKit
import CoreVideo
import VisualIntelligence

// definition of Visual Intelligence
@available(iOS 26.0, *)
@AppIntent(schema: .visualIntelligence.semanticContentSearch)
struct VisualIntelligenceIntent {
    static let title: LocalizedStringResource = "Items Image Search"

    @Dependency
    var logger: Logger

    var semanticContent: SemanticContentDescriptor

    // same meaning as `: OpenIntent`, openAppWhenRun = true
    static let supportedModes: IntentModes = [.foreground(.immediate)]

    func perform() async throws -> some IntentResult {
        await logger.trace()

        return .result()
    }
}

// entry of Visual Intelligence
@available(iOS 26.0, *)
struct VisualIntelligenceIntentValueQuery: IntentValueQuery {
    @Dependency
    var logger: Logger

    func values(for input: SemanticContentDescriptor) async throws -> [ItemEntity] {
        await logger.trace()

        let image: UIImage? = {
            guard let cvPixelBuffer = input.pixelBuffer else {
                return nil
            }

            let ciImage = cvPixelBuffer.withUnsafeBuffer { cvPixelBuffer in
                CIImage(cvPixelBuffer: cvPixelBuffer)
            }
            guard let cgImage = CIContext().createCGImage(ciImage, from: ciImage.extent) else {
                return nil
            }

            return UIImage(cgImage: cgImage)
        }()

        if let image {
            await logger.addImage(image)
        }

        return (0..<30).map {
            ItemEntity(item: Item(id: $0))
        }
    }
}


#endif
