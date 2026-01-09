import SwiftUI
import SampleAppIntents

struct ContentView: View {
    @State var logEntries: [Logger.LogEntry] = []

    var body: some View {
        VStack {
            Text("pid: \(ProcessInfo().processIdentifier)")

            List(logEntries) { entry in
                LogEntryRow(entry: entry)
            }
            .refreshable {
                logEntries = Logger().getEntries()
            }
        }
        .padding()
    }
}


private struct LogEntryRow: View {
    let entry: Logger.LogEntry

    var body: some View {
        VStack {
            Text("pid: \(entry.pid), date: \(entry.date.formatted(date: .omitted, time: .standard))")
                .frame(maxWidth: .infinity, alignment: .leading)
            Text("caller: \(entry.file)/\(entry.function)")
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}
