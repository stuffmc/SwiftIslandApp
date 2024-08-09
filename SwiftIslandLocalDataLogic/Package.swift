// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftIslandLocalDataLogic",
    platforms: [.iOS(.v17), .visionOS(.v1)],
    products: [
        .library(
            name: "SwiftIslandLocalDataLogic",
            targets: ["SwiftIslandLocalDataLogic"])
    ],
    dependencies: [
        .package(url: "https://github.com/sindresorhus/Defaults.git", from: "8.0.0"),
    ],
    targets: [
        .target(
            name: "SwiftIslandLocalDataLogic",
            dependencies: [
                .product(name: "Defaults", package: "Defaults"),
            ]),
        .testTarget(
            name: "SwiftIslandLocalDataLogicTests",
            dependencies: ["SwiftIslandLocalDataLogic"])
    ]
)
