// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "BikeStations",
    products: [
        .library(name: "App", targets: ["App"]),
        .executable(name: "Run", targets: ["Run"])
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", .upToNextMajor(from: "2.1.0")),
        .package(url: "https://github.com/vapor/fluent-provider.git", .upToNextMajor(from: "1.2.0")),
        .package(url: "https://github.com/PerfectlySoft/Perfect-XML.git", .upToNextMajor(from: "3.0.0")),
        .package(url: "https://github.com/BrettRToomey/Jobs.git", from: "1.1.1"),
    ],
    targets: [
        .target(name: "App", dependencies: ["Vapor", "FluentProvider", "PerfectXML","Jobs"],
                exclude: [
                    "Config",
                    "Public",
                    "Resources",
                ]),
        .target(name: "Run", dependencies: ["App"]),
        .testTarget(name: "AppTests", dependencies: ["App", "Testing"])
    ]
)
