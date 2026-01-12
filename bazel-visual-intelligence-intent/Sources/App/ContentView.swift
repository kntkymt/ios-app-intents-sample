import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(spacing: 12) {
            Text("Hello, Bazel!")
                .font(.title)
            Text("rules_apple + rules_xcodeproj")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
    }
}
