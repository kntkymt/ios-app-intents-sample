import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(spacing: 12) {
            Text("Hello, SPM!")
                .font(.title)
            Text("The root App Intents module is the app target; dependency modules come from a local Swift Package")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
    }
}
