// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "GPUCIImageView",
    platforms: [
        .iOS(.v12),
        .macOS(.v10_11),
    ],
    products: [
        .library(name: "GPUCIImageView", targets: ["GPUCIImageView"]),
    ],
    targets: [
        .target(
            name: "GPUCIImageView",
            dependencies: [],
            path: "Sources"
        ),
    ]
)
