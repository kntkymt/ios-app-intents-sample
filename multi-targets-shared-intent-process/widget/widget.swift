import WidgetKit
import SwiftUI
import SampleAppIntents
import AppIntents

struct widgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            HStack {
                let pid = String(describing: ProcessInfo().processIdentifier)
                Text("PID: \(pid)")
                    .frame(maxWidth: .infinity, alignment: .leading)

                Button(intent: ResetLogIntent()) {
                    Image(systemName: "trash")
                }

                Button(intent: RefreshWidgetIntent()) {
                    Image(systemName: "arrow.clockwise")
                }

                let item = Item(id: 1, name: "", price: 300, thumbnailURLs: [], pid: pid)
                Button(intent: OpenItemIntent(target: ItemEntity(item: item))) {
                    Text("Open")
                }

                Button(intent: SearchItemIntent()) {
                    Image(systemName: "magnifyingglass")
                }
            }

            ForEach(entry.logEntries.suffix(4)) { entry in
                VStack {
                    Text("pid: \(entry.pid), date: \(entry.date.formatted(date: .omitted, time: .standard))")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("caller: \(entry.file)/\(entry.function)")
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Divider()
                }
            }
        }
    }
}

struct widget: Widget {
    let kind: String = "Sample"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            widgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .supportedFamilies([.systemLarge])
    }
}

struct RefreshWidgetIntent: AppIntent {
    static var title: LocalizedStringResource = "Refresh widget"

    static var isDiscoverable: Bool {
        false
    }

    func perform() async throws -> some IntentResult {
        // automatically refresh widget timeline after trigger intent based on fundamental interactive widget behavior
        return .result()
    }
}

struct ResetLogIntent: AppIntent {
    static var title: LocalizedStringResource = "Reset Log"

    @Dependency
    var logger: Logger

    static var isDiscoverable: Bool {
        false
    }

    func perform() async throws -> some IntentResult {
        await logger.resetEntries()
        return .result()
    }
}
