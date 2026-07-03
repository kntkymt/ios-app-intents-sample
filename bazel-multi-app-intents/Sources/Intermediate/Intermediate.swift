import Foundation
import SecondAppIntent

// An intermediate module without App Intents of its own, sitting between the root App Intents
// module and a transitive dependency module which declares App Intents.
public struct IntermediateHelper {
    public init() {
        let _ = SecondAppIntent()
    }
}
