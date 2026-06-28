import SwiftUI
import AppIntents
import FirstAppIntent

struct ContentView: View {
    var body: some View {
        VStack(spacing: 12) {
            Text("Hello, SPM!")
                .font(.title)
            Text("Two AppIntents modules are linked from a local Swift Package")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
    }
}

//public struct FirstAppShortcuts: AppShortcutsProvider {
//    public static var appShortcuts: [AppShortcut] {
//        AppShortcut(
//            intent: FirstAppIntent(),
//            phrases: [
//                "Run first intent in \(.applicationName)",
//            ],
//            shortTitle: "Run First Intent",
//            systemImageName: "1.circle"
//        )
//    }
//}
