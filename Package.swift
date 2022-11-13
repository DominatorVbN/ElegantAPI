// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "ElegantAPI",
    products: [
        .library(
            name: "ElegantAPI",
            targets: ["ElegantAPI"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-docc-plugin.git", from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "ElegantAPI",
            dependencies: []),
        .testTarget(
            name: "ElegantAPITests",
            dependencies: ["ElegantAPI"]),
    ]
)
