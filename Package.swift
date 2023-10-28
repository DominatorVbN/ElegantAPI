// swift-tools-version:5.8

import PackageDescription

let package = Package(
    name: "ElegantAPI",
    platforms: [.iOS(.v16), .macOS(.v13)],
    products: [
        .library(
            name: "ElegantAPI",
            targets: ["ElegantAPI"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-docc-plugin.git", from: "1.0.0"),
        .package(url: "https://source.skip.tools/skip.git", from: "0.7.8")
    ],
    targets: [
        .target(
            name: "ElegantAPI",
            dependencies: [],
            plugins: [.plugin(name: "skipstone", package: "skip")]
        ),
        .testTarget(
            name: "ElegantAPITests",
            dependencies: ["ElegantAPI"],
            plugins: [.plugin(name: "skipstone", package: "skip")]
        ),
    ]
)
