import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(spacing: 12) {
            Text("Hello, Bazel!")
                .font(.title)
            Text("Two AppIntents modules are wired to ios_application")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
    }
}
