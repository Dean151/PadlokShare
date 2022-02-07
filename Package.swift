// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "PadlokShare",
    platforms: [
        .macOS(.v11)
    ],
    products: [
        .library(
            name: "PadlokShare",
            targets: ["PadlokShare"]),
    ],
    dependencies: [
        .package(url: "https://github.com/krzyzanowskim/CryptoSwift.git", .upToNextMajor(from: "1.0.0"))
    ],
    targets: [
        .target(
            name: "PadlokShare",
            dependencies: [
                .product(name: "CryptoSwift", package: "CryptoSwift"),
            ]),
        .testTarget(
            name: "PadlokShareTests",
            dependencies: ["PadlokShare"]),
    ]
)
