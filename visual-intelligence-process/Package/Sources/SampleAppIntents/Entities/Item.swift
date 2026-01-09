import Foundation

public struct Item: Hashable, Sendable {
    public var id: Int
    public var name: String
    public var price: Int
    public var pid: String

    public var thumbnailURLs: [URL]

    public init(
        id: Int,
        name: String,
        price: Int,
        thumbnailURLs: [URL],
        pid: String
    ) {
        self.id = id
        self.name = name
        self.price = price
        self.thumbnailURLs = thumbnailURLs
        self.pid = pid
    }
}

public extension Item {
    init(id: Int) {
        self.init(
            id: id,
            name: "Stub",
            price: 300,
            thumbnailURLs: [],
            pid: String(describing: ProcessInfo().processIdentifier)
        )
    }

    static var stub: [Item] {
        [
            Item(
                id: 1,
                name: "kntk",
                price: 300,
                thumbnailURLs: [URL(string: "https://avatars.githubusercontent.com/u/44288050?v=4")!],
                pid: String(describing: ProcessInfo().processIdentifier)
            ),
            Item(
                id: 2,
                name: "swift",
                price: 50000,
                thumbnailURLs: [URL(string: "https://avatars.githubusercontent.com/u/42816656?s=48&v=4")!],
                pid: String(describing: ProcessInfo().processIdentifier)
            )
        ]
    }
}
