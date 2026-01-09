// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "Package",
    platforms: [.iOS(.v26)],
    products: [
        .library(
            name: "SampleAppIntents",
            targets: ["SampleAppIntents"]
        )
    ],
    targets: [
        .target(
            name: "SampleAppIntents",
            dependencies: [
            ]
        )
    ]
)
