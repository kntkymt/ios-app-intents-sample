// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "Package",
    platforms: [
        .iOS(.v18),
    ],
    products: [
        .library(
            name: "FirstAppIntent",
            targets: ["FirstAppIntent"]
        ),
        .library(
            name: "Intermediate",
            targets: ["Intermediate"]
        ),
    ],
    targets: [
        .target(
            name: "FirstAppIntent"
        ),
        .target(
            name: "Intermediate",
            dependencies: [
                "BookAppIntent",
                "SecondAppIntent",
            ]
        ),
        .target(
            name: "SecondAppIntent"
        ),
        .target(
            name: "BookAppIntent"
        ),
    ]
)
