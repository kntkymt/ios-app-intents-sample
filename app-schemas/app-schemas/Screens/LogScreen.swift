import SwiftUI

/// Displays the ``Log`` entries recorded across the app (e.g. `AppEntity`
/// query methods), so the timing of each call can be inspected.
struct LogScreen: View {
    private let repository = LogRepository()

    @State private var logs: [Log] = []

    var body: some View {
        NavigationStack {
            List {
                if logs.isEmpty {
                    ContentUnavailableView(
                        "No Logs",
                        systemImage: "clock.arrow.circlepath",
                        description: Text("Recorded calls will appear here.")
                    )
                } else {
                    // Newest first.
                    ForEach(logs.reversed()) { log in
                        LogRow(log: log)
                    }
                }
            }
            .navigationTitle("Log")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: clear) {
                        Image(systemName: "trash")
                    }
                    .disabled(logs.isEmpty)
                }
            }
            .refreshable { await load() }
            .task { await load() }
        }
    }

    private func load() async {
        logs = await repository.getLogs()
    }

    private func clear() {
        Task {
            await repository.clear()
            await load()
        }
    }
}

/// A single row describing one logged call.
private struct LogRow: View {
    let log: Log

    var body: some View {
        HStack {
            Image(systemName: "clock.arrow.circlepath")
                .foregroundStyle(.blue)
            VStack(alignment: .leading, spacing: 4) {
                Text(log.callerName)
                    .font(.headline)
                Text(log.date, format: .dateTime.year().month().day().hour().minute().second())
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Text("\(log.count)")
                .font(.body.monospacedDigit())
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    LogScreen()
}
