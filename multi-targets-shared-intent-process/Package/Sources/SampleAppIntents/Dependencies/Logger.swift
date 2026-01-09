import Foundation
import WidgetKit

@MainActor
public struct Logger {
    public struct LogEntry: Hashable, Identifiable, Sendable {
        public var date: Date
        public var id: Int
        public var pid: String
        public var file: String
        public var function: String

        public init(
            date: Date,
            id: Int,
            pid: String,
            file: String,
            function: String
        ) {
            self.date = date
            self.id = id
            self.pid = pid
            self.file = file
            self.function = function
        }
    }

    public nonisolated init() {}

    public func trace(
        date: Date = Date(),
        pid: String = String(describing: ProcessInfo().processIdentifier),
        file: String = #file,
        function: String = #function
    ) {
        let entry = LogEntry(
            date: date,
            id: nextSequence(),
            pid: pid,
            file: file,
            function: function
        )
        Logger.state.entries.append(entry)

        WidgetCenter.shared.reloadAllTimelines()

    }

    public func getEntries() -> [LogEntry] {
        Logger.state.entries
    }

    public func resetEntries() {
        Logger.state.entries.removeAll()
    }

    private static let state = State()

    private func nextSequence() -> Int {
        let sequence = Self.state.sequence
        Self.state.sequence += 1
        return sequence
    }
}

private extension Logger {
    final class State {
        var sequence: Int = 0
        var entries: [LogEntry] = []
    }
}
