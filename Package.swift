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
        .package(url: "https://github.com/apple/swift-crypto.git", .upToNextMajor(from: "2.0.0")),
    ],
    targets: [
        .target(
            name: "PadlokShare",
            dependencies: [
                .product(name: "Crypto", package: "swift-crypto"),
            ]),
        .testTarget(
            name: "PadlokShareTests",
            dependencies: ["PadlokShare"]),
    ]
)
