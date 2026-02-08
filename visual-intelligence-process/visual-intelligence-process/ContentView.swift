import SwiftUI
import SampleAppIntents

enum Tab: String, CaseIterable {
    case logs
    case images
}

struct ContentView: View {
    @State var tab: Tab = .logs

    var body: some View {
        VStack {
            Picker("Tab", selection: $tab) {
                ForEach(Tab.allCases, id: \.self) {
                    tab in
                    switch tab {
                    case .logs:
                        Text("Log")
                    case .images:
                        Text("Image")
                    }
                }
            }.pickerStyle(SegmentedPickerStyle())

            Text("pid: \(ProcessInfo().processIdentifier)")

            switch tab {
            case .images:
                ImageEntriesView()

            case .logs:
                LogEntriesView()
            }
        }
        .padding()
    }
}

private struct LogEntriesView: View {
    @State var logEntries: [Logger.LogEntry] = []

    var body: some View {
        List(logEntries) { entry in
            VStack(alignment: .leading) {
                Text("pid: \(entry.pid), date: \(entry.date.formatted(date: .omitted, time: .standard))")
                Text("caller: \(entry.lastFilePath)/\(entry.function)")
                Text("app state: \(entry.appState.description)")
                if let message = entry.message {
                    Text("\(message)")
                }
            }
        }
        .refreshable {
            refreshEntries()
        }
        .onAppear {
            refreshEntries()
        }
    }

    private func refreshEntries() {
        logEntries = Logger().getEntries()
    }
}

private struct ImageEntriesView: View {

    @State var images: [UIImage] = []

    var body: some View {
        List {
            ForEach(0..<images.count, id: \.self) { index in
                VStack {
                    Text(images[index].size.debugDescription)

                    Image(uiImage: images[index])
                        .resizable()
                }
            }
        }
        .refreshable {
            refreshEntries()
        }
        .onAppear {
            refreshEntries()
        }
    }

    private func refreshEntries() {
        images = Logger().getImages()
    }
}

private extension Logger.LogEntry {
    var lastFilePath: String {
        guard let slashIndex = file.lastIndex(of: "/") else {
            return file
        }

        return String(file.suffix(from: file.index(after: slashIndex)))
    }
}

private extension UIApplication.State {
    var description: String {
        switch self {
        case .inactive: "inactive"
        case .active: "active"
        case .background: "background"
        @unknown default: "unknown"
        }
    }
}
