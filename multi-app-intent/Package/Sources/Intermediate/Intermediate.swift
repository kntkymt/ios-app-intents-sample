import AppIntents
import BookAppIntent
import Foundation
import SecondAppIntent

// An intermediate module without App Intents of its own, sitting between the root App Intents
// module and a transitive dependency module which declares App Intents.
public struct IntermediateHelper {
    public init() {
        let _ = SecondAppIntent()
    }
}

public struct IntermediatePackage: AppIntentsPackage {
    public static var includedPackages: [any AppIntentsPackage.Type] {
        [
            SecondAppIntentPackage.self,
            BookAppIntentPackage.self,
        ]
    }
}
