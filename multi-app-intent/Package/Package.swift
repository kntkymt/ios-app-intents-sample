// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "Package",
    platforms: [
        .iOS(.v17),
    ],
    products: [
        .library(
            name: "FirstAppIntent",
            targets: ["FirstAppIntent"]
        ),
        .library(
            name: "SecondAppIntent",
            targets: ["SecondAppIntent"]
        ),
    ],
    targets: [
        .target(
            name: "FirstAppIntent"
        ),
        .target(
            name: "SecondAppIntent"
        ),
    ]
)
