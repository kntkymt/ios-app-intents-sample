import Foundation
import UIKit
import WidgetKit

@MainActor
public struct Logger {
    public struct LogEntry: Hashable, Identifiable, Sendable {
        public var date: Date
        public var id: Int
        public var pid: String
        public var message: String?
        public var file: String
        public var function: String
        public var appState: UIApplication.State

        public init(
            date: Date,
            id: Int,
            pid: String,
            message: String?,
            file: String,
            function: String,
            appState: UIApplication.State
        ) {
            self.date = date
            self.id = id
            self.pid = pid
            self.message = message
            self.file = file
            self.function = function
            self.appState = appState
        }
    }

    public nonisolated init() {}

    public func trace(
        date: Date = Date(),
        pid: String = String(describing: ProcessInfo().processIdentifier),
        message: String? = nil,
        file: String = #file,
        function: String = #function
    ) {
        let entry = LogEntry(
            date: date,
            id: nextSequence(),
            pid: pid,
            message: message,
            file: file,
            function: function,
            appState: UIApplication.shared.applicationState
        )
        Logger.state.entries.append(entry)
        print(entry)

        WidgetCenter.shared.reloadAllTimelines()

    }

    public func getEntries() -> [LogEntry] {
        Logger.state.entries
    }

    public func addImage(_ uiImage: UIImage) {
        Logger.state.images.append(uiImage)
    }

    public func getImages() -> [UIImage] {
        Logger.state.images
    }

    private static let state = State()

    private func nextSequence() -> Int {
        let sequence = Self.state.sequence
        Self.state.sequence += 1
        return sequence
    }

    public func a() async { }
}

extension Logger {
    fileprivate final class State {
        var sequence: Int = 0
        var entries: [LogEntry] = []

        var images: [UIImage] = []
    }
}
