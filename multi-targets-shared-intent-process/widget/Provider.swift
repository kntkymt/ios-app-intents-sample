import WidgetKit
import SampleAppIntents

struct Provider: TimelineProvider {
    func getSnapshot(in context: Context, completion: @escaping @Sendable (SimpleEntry) -> Void) {
        Task {
            let logEntries = await Logger().getEntries()
            completion(
                SimpleEntry(
                    date: Date(),
                    logEntries: logEntries
                )
            )
        }
    }
    
    func getTimeline(in context: Context, completion: @escaping @Sendable (Timeline<SimpleEntry>) -> Void) {
        Task {
            let logEntries = await Logger().getEntries()
            completion(
                .init(
                    entries: [
                        SimpleEntry(
                            date: Date(),
                            logEntries: logEntries
                        )
                    ],
                    policy: .never
                )
            )
        }
    }
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(
            date: Date(),
            logEntries: []
        )
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date

    let logEntries: [Logger.LogEntry]
}
