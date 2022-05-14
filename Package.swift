// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "CleanyModal",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "CleanyModal",
            targets: ["CleanyModal"]
        )
    ],
    targets: [
        .target(
            name: "CleanyModal",
            path: "CleanyModal"
        )
    ]
)
