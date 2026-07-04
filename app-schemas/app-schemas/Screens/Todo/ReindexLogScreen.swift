import SwiftUI

/// Displays the ``ReindexLog`` entries recorded by ``TodoIndexer``, so the
/// timing of each reindex (full, partial, or delete-all) can be inspected.
struct ReindexLogScreen: View {
    private let repository = ReindexLogRepository()

    @State private var logs: [ReindexLog] = []

    var body: some View {
        NavigationStack {
            List {
                if logs.isEmpty {
                    ContentUnavailableView(
                        "No Reindex Logs",
                        systemImage: "clock.arrow.circlepath",
                        description: Text("Reindex calls will appear here.")
                    )
                } else {
                    // Newest first.
                    ForEach(logs.reversed()) { log in
                        ReindexLogRow(log: log)
                    }
                }
            }
            .navigationTitle("Reindex Log")
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

/// A single row describing one reindex call.
private struct ReindexLogRow: View {
    let log: ReindexLog

    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundStyle(color)
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
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

    private var title: String {
        switch log.kind {
        case .entities: "entities(for:)"
        case .suggested: "suggestedEntities()"
        case .reindex: "reindexEntities(for:)"
        case .reindexAll: "reindexAllEntities()"
        }
    }

    private var icon: String {
        switch log.kind {
        case .entities: "magnifyingglass"
        case .suggested: "lightbulb"
        case .reindex: "arrow.triangle.2.circlepath.circle"
        case .reindexAll: "arrow.triangle.2.circlepath"
        }
    }

    private var color: Color {
        switch log.kind {
        case .entities: .blue
        case .suggested: .orange
        case .reindex: .green
        case .reindexAll: .purple
        }
    }
}

#Preview {
    ReindexLogScreen()
}
