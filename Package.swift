// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "GPUCIImageView",
    platforms: [
        .iOS(.v9),
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
