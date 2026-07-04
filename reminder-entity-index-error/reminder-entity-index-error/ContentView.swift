import SwiftUI
import Playgrounds
import AppIntents
import CoreSpotlight

@main struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct ContentView: View {
    var body: some View {
        Text("Hello, world!")
            .padding()
            .onAppear {
                Task {
                    try? await CSSearchableIndex.default().indexAppEntities(ReminderEntity.dummies)
                }
            }
    }
}
